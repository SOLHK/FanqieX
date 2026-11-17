#!/usr/bin/env python3
"""Execute the linked menu's actual ARM64 updateRows and property methods.

Only imported Objective-C/Foundation APIs are modeled. Class/method/ivar metadata,
constant NSString/NSArray values, SearchText, row filtering, folder extraction and
sort comparator instructions come from the supplied merged dylib. NSString's
empty-prefix result follows Apple's documented NO contract, not Python startswith.
No UIKit rendering or device execution is claimed.
"""
import argparse
import functools
import hashlib
import json
import struct
import sys
from pathlib import Path

from arm64 import CPU, MASK64, require

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
sys.path.insert(0, str(ROOT / "repair162"))
import merge_book_export as macho


class HeapCPU(CPU):
    def write(self, address, size, value):
        if 0x40000000 <= address < 0x50000000:
            for index, byte in enumerate((value & ((1 << (size * 8)) - 1)).to_bytes(size, "little")):
                self.memory[address + index] = byte
            return
        super().write(address, size, value)


class Runtime:
    def __init__(self, data):
        self.data = data
        self.objects = {}
        self.symbols = {}
        self.symbol_addresses = {}
        self.classes = {}
        self.prefix_calls = []
        self.calls = 0
        self.executed = set()
        commands, segments = macho.commands(data), macho.segments(data)
        starts, imports = macho.fixup_input(data, commands, segments)
        self.slots = macho.walk_fixups(data, segments, starts)
        self.pointers = {}
        for offset, (_, value) in self.slots.items():
            if value >> 63:
                name = imports[value & macho.BIND_MASK][2]
                if name not in self.symbol_addresses:
                    pointer = 0x50000000 + len(self.symbol_addresses) * 0x100
                    self.symbol_addresses[name] = pointer
                    self.symbols[pointer] = name
                self.pointers[offset] = self.symbol_addresses[name]
            else:
                self.pointers[offset] = value & macho.TARGET_MASK
        self.pointers[self.symbol_addresses["___stack_chk_guard"]] = 0x1234567890abcdef
        self.sections = macho.sections(data)
        for section in self.sections:
            if section["name"] != "__objc_classlist":
                continue
            for address in range(section["offset"], section["offset"] + section["size"], 8):
                cls = self.ptr(address)
                ro = self.ptr(cls + 32) & ~7
                name = self.string(self.ptr(ro + 24))
                if name not in ("FQXSettingsMenu", "FQXSettingRow"):
                    continue
                methods = {}
                method_list = self.ptr(ro + 32)
                flags, count = struct.unpack_from("<II", data, method_list)
                for index in range(count):
                    entry = method_list + 8 + index * (flags & 0xfffc)
                    if flags & 0x80000000:
                        name_delta, type_delta, imp_delta = struct.unpack_from("<iii", data, entry)
                        sel = entry + name_delta
                        if not flags & 0x40000000:
                            sel = self.ptr(sel)
                        imp = entry + 8 + imp_delta
                    else:
                        sel, _, imp = self.ptr(entry), self.ptr(entry + 8), self.ptr(entry + 16)
                    methods[self.string(sel)] = (sel, imp)
                ivars = {}
                ivar_list = self.ptr(ro + 48)
                width, count = struct.unpack_from("<II", data, ivar_list)
                for index in range(count):
                    entry = ivar_list + 8 + index * width
                    offset = struct.unpack_from("<I", data, self.ptr(entry))[0]
                    ivars[self.string(self.ptr(entry + 8))] = offset
                self.classes[name] = {"methods": methods, "ivars": ivars}
        self.ranges = [(segment["vmaddr"], segment["vmaddr"] + segment["filesize"])
                       for segment in segments if segment["initprot"] & 4]

    def ptr(self, address):
        return self.pointers.get(address, struct.unpack_from("<Q", self.data, address)[0])

    def string(self, address):
        return macho.cstring(self.data, address, len(self.data))

    def obj(self, cls, value=None, **state):
        address = 0x40000000 + len(self.objects) * 0x1000
        self.objects[address] = {"class": cls, "value": value, **state}
        return address

    def value(self, address):
        if not address:
            return None
        if address in self.objects:
            return self.objects[address]["value"]
        isa = self.symbols.get(self.ptr(address))
        if isa == "___CFConstantStringClassReference":
            flags, = struct.unpack_from("<I", self.data, address + 8)
            content, length = self.ptr(address + 16), self.ptr(address + 24)
            wide = bool(flags & 0x10)
            return self.data[content:content + length * (2 if wide else 1)].decode("utf-16-le" if wide else "utf-8")
        if isa == "_OBJC_CLASS_$_NSConstantArray":
            count, storage = self.ptr(address + 8), self.ptr(address + 16)
            return [self.ptr(storage + index * 8) for index in range(count)]
        raise AssertionError(f"Unmodeled object {address:#x}, isa={isa}")

    def finish(self, cpu, result=0):
        self.calls += 1
        for index in range(18):
            cpu.x[index] = 0xc0000000 + self.calls * 0x100 + index
        cpu.x[0] = result & MASK64
        cpu.pc = cpu.x[30]
        return True

    def invoke_block(self, parent, block, left, right):
        cpu = HeapCPU(self.data, self, ranges=self.ranges)
        cpu.memory, cpu.pointers = parent.memory, parent.pointers
        cpu.sp = parent.sp - 0x2000
        result = cpu.run(cpu.read(block + 16, 8), block, left, right)["result"]
        self.executed.update(cpu.executed)
        return result if result < (1 << 63) else result - (1 << 64)

    def handle(self, cpu, pc):
        symbol = self.symbols.get(pc)
        if not symbol:
            return False
        args = cpu.x[:8]
        if symbol in ("_objc_retain", "_objc_retainAutoreleasedReturnValue", "_objc_autoreleaseReturnValue",
                      "_objc_retainAutoreleaseReturnValue", "_objc_retainAutorelease", "_objc_autorelease",
                      "_objc_retainBlock", "_objc_unsafeClaimAutoreleasedReturnValue"):
            return self.finish(cpu, args[0])
        if symbol == "_objc_release":
            return self.finish(cpu)
        if symbol == "_objc_setProperty_nonatomic_copy":
            cpu.write(args[0] + args[3], 8, args[2])
            return self.finish(cpu)
        if symbol == "_objc_storeStrong":
            cpu.write(args[0], 8, args[1])
            return self.finish(cpu)
        if symbol != "_objc_msgSend":
            raise AssertionError(f"Unmodeled import {symbol} from {cpu.x[30]:#x}")
        receiver, selector, argument = args[:3]
        if not receiver:
            return self.finish(cpu)
        name = self.string(selector)
        obj = self.objects.get(receiver)
        if obj and obj["class"] in self.classes and name in self.classes[obj["class"]]["methods"]:
            cpu.pc = self.classes[obj["class"]]["methods"][name][1]
            return True
        cls_symbol = self.symbols.get(receiver, "")
        if cls_symbol.startswith("_OBJC_CLASS_$_"):
            cls = cls_symbol.split("$_", 1)[1]
            if name in ("array", "orderedSet"):
                return self.finish(cpu, self.obj(cls, []))
            if name in ("whitespaceAndNewlineCharacterSet", "standardUserDefaults", "localeWithLocaleIdentifier:"):
                return self.finish(cpu, self.obj(cls))
        if obj and name in obj:
            return self.finish(cpu, obj[name])
        if name == "boolForKey:":
            return self.finish(cpu, 0)
        value = self.value(receiver)
        result = 0
        if name == "countByEnumeratingWithState:objects:count:":
            state, buffer, limit = args[2:5]
            consumed = cpu.read(state, 8)
            items = value[consumed:consumed + limit]
            for index, item in enumerate(items):
                cpu.write(buffer + index * 8, 8, item)
            cpu.write(state, 8, consumed + len(items))
            cpu.write(state + 8, 8, buffer)
            cpu.write(state + 16, 8, state + 24)
            cpu.write(state + 24, 8, 0)
            result = len(items)
        elif name == "stringByTrimmingCharactersInSet:":
            result = self.obj("NSString", value.strip())
        elif name in ("stringByApplyingTransform:reverse:", "stringByFoldingWithOptions:locale:"):
            require(value in ("", "作者"), "This fixture only normalizes empty or already-simple Chinese queries")
            result = self.obj("NSString", value)
        elif name == "lowercaseString":
            result = self.obj("NSString", value.lower())
        elif name == "stringByReplacingOccurrencesOfString:withString:":
            result = self.obj("NSString", value.replace(self.value(argument), self.value(args[3])))
        elif name == "length":
            result = len(value.encode("utf-16-le")) // 2
        elif name == "isEqualToString:":
            result = int(value == self.value(argument))
        elif name == "hasPrefix:":
            prefix = self.value(argument)
            result = int(bool(prefix) and value.startswith(prefix))
            self.prefix_calls.append({"receiver": value, "prefix": prefix, "result": bool(result)})
        elif name == "stringByAppendingString:":
            result = self.obj("NSString", value + self.value(argument))
        elif name == "substringFromIndex:":
            result = self.obj("NSString", value[argument:])
        elif name == "componentsSeparatedByString:":
            result = self.obj("NSArray", [self.obj("NSString", part) for part in value.split(self.value(argument))])
        elif name == "componentsSeparatedByCharactersInSet:":
            result = self.obj("NSArray", [self.obj("NSString", part) for part in value.split()])
        elif name == "containsString:":
            needle = self.value(argument)
            result = int(bool(needle) and needle in value)
        elif name == "characterAtIndex:":
            result = int.from_bytes(value.encode("utf-16-le")[argument * 2:argument * 2 + 2], "little")
        elif name == "objectAtIndexedSubscript:":
            result = value[argument]
        elif name == "firstObject":
            result = value[0] if value else 0
        elif name == "count":
            result = len(value)
        elif name == "addObject:":
            if obj["class"] != "NSMutableOrderedSet" or all(self.value(item) != self.value(argument) for item in value):
                value.append(argument)
        elif name == "array":
            result = self.obj("NSArray", value.copy())
        elif name == "indexOfObject:":
            result = next((i for i, item in enumerate(value) if self.value(item) == self.value(argument)), (1 << 63) - 1)
        elif name == "sortedArrayUsingComparator:":
            result = self.obj("NSArray", sorted(value, key=functools.cmp_to_key(
                lambda left, right: self.invoke_block(cpu, argument, left, right))))
        elif name == "sortUsingComparator:":
            value.sort(key=functools.cmp_to_key(lambda left, right: self.invoke_block(cpu, argument, left, right)))
        else:
            raise AssertionError(f"Unmodeled Foundation selector {name}, receiver={receiver:#x} ({value!r})")
        return self.finish(cpu, result)


def run_case(data, path="", search_cycle=False):
    rt = Runtime(data)
    cpu = HeapCPU(data, rt, ranges=rt.ranges)
    cpu.pointers.update(rt.pointers)
    menu = rt.obj("FQXSettingsMenu")
    menu_ivars = rt.classes["FQXSettingsMenu"]["ivars"]
    for offset in menu_ivars.values():
        cpu.write(menu + offset, 8, 0)
    rows = []
    for title, route in (("隐藏作者的话", "阅读/阅读页面净化/章末内容"),
                         ("隐藏章末讨论入口", "阅读/阅读页面净化/章末内容"),
                         ("显示前台通知提醒", "通知管理"),
                         ("导出当前视频", "导出与备份")):
        row = rt.obj("FQXSettingRow")
        ivars = rt.classes["FQXSettingRow"]["ivars"]
        for offset in ivars.values():
            cpu.write(row + offset, 8, 0)
        cpu.write(row + ivars["_title"], 8, rt.obj("NSString", title))
        cpu.write(row + ivars["_path"], 8, rt.obj("NSString", route))
        cpu.write(row + ivars["_searchTitle"], 8, rt.obj("NSString", title))
        cpu.write(row + ivars["_searchText"], 8, rt.obj("NSString", title + " " + route))
        rows.append(row)
    cpu.write(menu + menu_ivars["_catalog"], 8, rt.obj("NSArray", rows))
    cpu.write(menu + menu_ivars["_path"], 8, rt.obj("NSString", path))
    query = rt.obj("NSString", "")
    search_bar = rt.obj("UISearchBar", text=query)
    cpu.write(menu + menu_ivars["_search"], 8, rt.obj("UISearchController", searchBar=search_bar))
    selector, imp = rt.classes["FQXSettingsMenu"]["methods"]["updateRows"]
    result = cpu.run(imp, menu, selector)
    rt.executed.update(cpu.executed)
    folders = [rt.value(item) for item in rt.value(cpu.read(menu + menu_ivars["_folders"], 8))]
    visible = rt.value(cpu.read(menu + menu_ivars["_visibleRows"], 8))
    row_selector, row_imp = rt.classes["FQXSettingsMenu"]["methods"]["tableView:numberOfRowsInSection:"]
    count = cpu.run(row_imp, menu, row_selector, 0, args=[menu, row_selector, 0, 0])["result"]
    require(count == len(folders) + len(visible), "The actual table data-source count matches stored rows/folders")
    outcome = {"path": path, "folders": folders, "visible_rows": len(visible), "table_row_count": count,
               "prefix_calls": list(rt.prefix_calls), "update_rows_imp": hex(imp),
               "actual_arm64_instructions": result["instructions"], "executed_addresses": len(rt.executed)}
    if search_cycle:
        rt.objects[search_bar]["text"] = rt.obj("NSString", "作者")
        cpu.run(imp, menu, selector)
        matches = rt.value(cpu.read(menu + menu_ivars["_visibleRows"], 8))
        require(matches == [rows[0]], "The actual menu search returns the author-word setting")
        require(cpu.run(row_imp, args=[menu, row_selector, 0, 0])["result"] == 1,
                "The actual table data source shows the search result")
        rt.objects[search_bar]["text"] = rt.obj("NSString", "")
        cpu.run(imp, menu, selector)
        restored = [rt.value(item) for item in rt.value(cpu.read(menu + menu_ivars["_folders"], 8))]
        require(restored == folders and not rt.value(cpu.read(menu + menu_ivars["_visibleRows"], 8)),
                "Clearing search restores the same root folders instead of retaining search rows")
        outcome["search_then_clear"] = {"matched_rows": 1, "restored_folders": restored}
    return outcome


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--expect-empty-root", action="store_true")
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    cases = [run_case(data, search_cycle=True), run_case(data, "阅读"),
             run_case(data, "阅读/阅读页面净化"), run_case(data, "阅读/阅读页面净化/章末内容"),
             run_case(data, "通知管理")]
    require(cases[0]["folders"] == ([] if args.expect_empty_root else ["阅读", "通知管理", "导出与备份"]),
            "Root folders reproduce the broken image or satisfy the repaired contract")
    require(cases[1]["folders"] == ["阅读页面净化"] and cases[2]["folders"] == ["章末内容"] and
            cases[3]["visible_rows"] == 2 and cases[4]["visible_rows"] == 1,
            "Nested folders and direct leaf rows remain reachable")
    report = {"passed": True, "sha256": hashlib.sha256(data).hexdigest(),
              "expected_regression_reproduced": args.expect_empty_root, "cases": cases,
              "native_menu_methods_executed": True, "foundation_boundary_modeled": True, "device_tested": False,
              "contract_source": "https://developer.apple.com/documentation/foundation/nsstring/hasprefix(_:)",
              "limits": "Empty and already-simple Chinese query boundaries; candidate ARM64 grouping, search, property methods and sorting execute; no UIKit rendering."}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
