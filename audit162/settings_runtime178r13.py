"""Exercise the R13 settings UI in the ARM64 fixture."""
import struct

from arm64 import release_version, require
from test_control_glass166 import send
from test_controls171 import call

EXTRA_SETTINGS_LABELS = ["LFQD_FQDInitDiagnosticsPolicy", "LFQD_DiagnosticsEnabledKey"]


class SettingsBoundary178R13:
    SETTINGS_LAYOUT = 0x330c3700
    SCREENSHOT_SHARE = 0x330c3710
    SETTINGS_DATA_SOURCE = 0x330c3720
    DIAGNOSTIC_ACTION = 0x330c3730

    def size_settings_view(self, view, frame):
        state = self.objects[view].state
        delta = frame[2] - state["frame"][2]
        state["frame"] = frame
        state["bounds"] = (0., 0., frame[2], frame[3])
        if delta and state.get("autoresizesSubviews", True):
            for child in state.get("subviews", ()):
                child_state = self.objects[child].state
                mask = child_state.get("settings_mask", 0)
                x, y, w, h = child_state["frame"]
                if mask == 1:
                    child_state["frame"] = (x + delta, y, w, h)
                elif mask == 2:
                    self.size_settings_view(child, (x, y, w + delta, h))

    def responds(self, receiver, name):
        if getattr(self, "settings_boundary", False):
            obj = self.objects[receiver]
            if name == "anyObject" and obj.cls == self.classes.get("NSHashTable"):
                return True
            if name == "lowercaseString" and obj.cls == self.classes.get("NSString"):
                return True
            if name in ("accessibilityIdentifier", "navigationItem", "tableFooterView",
                        "navigationController", "topViewController", "viewIfLoaded") and name in obj.state:
                return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        if pc == self.DIAGNOSTIC_ACTION:
            self.settings_diagnostics_receiver = cpu.x[0]
            return self.finish(cpu)
        if pc == self.SETTINGS_DATA_SOURCE:
            name = self.selector_names[cpu.x[1]]
            section = cpu.x[3]
            if name == "numberOfSectionsInTableView:":
                return self.finish(cpu, 4)
            if name == "tableView:numberOfRowsInSection:":
                return self.finish(cpu, (6, 9, 3, 1)[section])
            if name == "tableView:cellForRowAtIndexPath:":
                return self.finish(cpu, section)
            return self.finish(cpu, self.text_object(str(section)))
        if pc == self.SETTINGS_LAYOUT:
            self.settings_layout_calls += 1
            return self.finish(cpu)
        if pc == self.SCREENSHOT_SHARE:
            self.screenshot_share_calls.append(cpu.x[2])
            return self.finish(cpu)
        if pc - self.slide != 0xa5d4 or not getattr(self, "settings_boundary", False):
            return super().handle(cpu, pc)
        receiver, selector, value = cpu.x[:3]
        name = self.selector_names.get(selector)
        classes = self.classes
        if name in ("openStartupFromController:", "openBookstoreFromController:", "presentFromController:",
                    "openFromSettingsController:"):
            if receiver in (classes.get("FQXNavigationPreferences"), classes.get("FQXSettingsBackup"),
                            classes.get("FQXBookExportPlugin")):
                self.settings_destination = (name, value)
                return self.finish(cpu)
        if receiver == classes["NSCharacterSet"] and name == "whitespaceAndNewlineCharacterSet":
            return self.finish(cpu, self.obj("NSCharacterSet", "whitespace"))
        if receiver == classes["UIImage"] and name == "systemImageNamed:":
            return self.finish(cpu, self.obj("UIImage", "settings search icon"))
        if receiver == classes.get("NSIndexPath") and name == "indexPathForRow:inSection:":
            return self.finish(cpu, self.obj("NSIndexPath", "settings index", row=value, section=cpu.x[3]))
        if receiver == classes["UIColor"] and name in ("secondarySystemGroupedBackgroundColor", "systemGroupedBackgroundColor"):
            return self.finish(cpu, self.color(name))
        if receiver == classes["UIAlertController"] and name == "alertControllerWithTitle:message:preferredStyle:":
            return self.finish(cpu, self.obj("UIAlertController", "local reward alert", message=cpu.x[3], actions=[]))
        if receiver == classes["UIAlertAction"] and name == "actionWithTitle:style:handler:":
            return self.finish(cpu, self.obj("UIAlertAction", "alert acknowledgement"))
        if receiver in self.metaclasses and name == "new":
            cls = self.class_names[receiver]
            if cls in ("UIView", "UILabel", "UISwitch", "UISearchBar"):
                return self.finish(cpu, self.view(cls, "settings view"))
            if cls == "UIViewController":
                return self.finish(cpu, self.obj(cls, "settings detail page",
                                                 view=self.view("UIView", "settings detail view")))
        if receiver in self.objects:
            state = self.objects[receiver].state
            if name in ("row", "section") and name in state:
                return self.finish(cpu, state[name])
            if name == "pushViewController:animated:":
                state["pushedViewController"] = value
                self.objects[value].state["navigationController"] = receiver
                return self.finish(cpu)
            if name == "popViewControllerAnimated:":
                return self.finish(cpu, state.pop("pushedViewController"))
            if receiver == self.DEFAULTS and name == "setInteger:forKey:":
                state["values"][self.string_value(cpu.x[3])] = value
                return self.finish(cpu)
            if receiver == self.DEFAULTS and name == "removeObjectForKey:":
                state["values"].pop(self.string_value(value), None)
                return self.finish(cpu)
            if name == "text" and self.is_kind(receiver, classes["UISearchBar"]):
                return self.finish(cpu, state.get("text", 0))
            if name == "reloadData" and self.is_kind(receiver, classes.get("UITableView")):
                state["reloads"] = state.get("reloads", 0) + 1
                return self.finish(cpu)
            if name == "setAutoresizingMask:":
                state["settings_mask"] = value
                return self.finish(cpu)
            if name == "setAutoresizesSubviews:":
                state["autoresizesSubviews"] = value
                return self.finish(cpu)
            if name == "setFrame:" and "frame" in state:
                self.size_settings_view(receiver, tuple(cpu.fp(i) for i in range(4)))
                return self.finish(cpu)
            if name == "sizeThatFits:" and self.is_kind(receiver, classes["UISwitch"]):
                return self.finish(cpu, fp=(61., 28.))
            if name in ("componentsSeparatedByCharactersInSet:", "lowercaseString", "containsString:", "characterAtIndex:"):
                text = self.string_value(receiver)
                if name == "componentsSeparatedByCharactersInSet:":
                    return self.finish(cpu, self.box(text.split()))
                if name == "lowercaseString":
                    return self.finish(cpu, self.text_object(text.lower()))
                if name == "containsString:":
                    return self.finish(cpu, int(self.string_value(value) in text))
                return self.finish(cpu, ord(text[value]))
            if name in ("initWithTitle:style:target:action:", "initWithImage:style:target:action:"):
                state.update(content=value, target=cpu.x[4], action=cpu.x[5])
                return self.finish(cpu, receiver)
            if name in ("setLeftBarButtonItem:", "setRightBarButtonItems:", "setAccessibilityIdentifier:",
                        "setPlaceholder:", "setDelegate:", "setTableFooterView:", "setOn:", "setLineBreakMode:"):
                key = "isOn" if name == "setOn:" else name[3].lower() + name[4:-1]
                state[key] = value
                return self.finish(cpu)
            if name in ("navigationItem", "rightBarButtonItem", "accessibilityIdentifier", "tableFooterView",
                        "navigationController", "topViewController", "viewIfLoaded"):
                return self.finish(cpu, state.get(name, 0))
            if name in ("setSearchBarStyle:", "setEdgesForExtendedLayout:"):
                return self.finish(cpu)
            if name == "anyObject" and "items" in state:
                return self.finish(cpu, next(iter(state["items"]), 0))
            if name == "addAction:":
                state["actions"].append(value)
                return self.finish(cpu)
            if name == "presentViewController:animated:completion:":
                state["presentedViewController"] = value
                return self.finish(cpu)
        return super().handle(cpu, pc)


def exercise_settings(cpu, runtime, labels, options, titles):
    for name, parent in (("UIBarButtonItem", "NSObject"), ("UISearchBar", "UIView"),
                         ("FQXNavigationPreferences", "NSObject"), ("FQXSettingsBackup", "NSObject"),
                         ("NSIndexPath", "NSObject"),
                         ("NSCharacterSet", "NSObject"), ("UIAlertController", "UIViewController"),
                         ("UIAlertAction", "NSObject"), ("SSReaderParagraphCommentAdapter", "NSObject")):
        if name not in runtime.classes:
            runtime._class(name, parent)
    runtime.settings_boundary = True
    try:
        return check_settings(cpu, runtime, labels, options, titles)
    finally:
        runtime.settings_boundary = False


def check_settings(cpu, runtime, labels, options, titles):
    def state(view):
        return runtime.objects[view].state

    def descendants(view):
        for child in state(view).get("subviews", ()):
            yield child
            yield from descendants(child)

    navigation = runtime.obj("UINavigationItem", "plugin settings navigation",
                             rightBarButtonItem=runtime.obj("UIBarButtonItem", "done"))
    state(options)["navigationItem"] = navigation
    new_layout = release_version(runtime.data) in ("1.78R14", "1.78R15", "1.78R16", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6")
    if new_layout:
        for name, base, selector, imp, signature in (
            ("FanqieAdBlockOptionsController", "UIViewController", "viewDidLayoutSubviews",
             runtime.SETTINGS_LAYOUT, "v16@0:8"),
            ("SSReadingShareScreenshotPendantView", "UIView", "showWithShareAction:",
             runtime.SCREENSHOT_SHARE, "v24@0:8@?16"),
        ):
            runtime._class(name, base)
            runtime._add(runtime.classes[name], selector, imp, signature)
        options = runtime.obj("FanqieAdBlockOptionsController", "settings controller", **state(options))
        runtime.settings_layout_calls = 0
        runtime.screenshot_share_calls = []
        if release_version(runtime.data) in ("1.78R19", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6"):
            for selector, encoding in (
                ("numberOfSectionsInTableView:", "q24@0:8@16"),
                ("tableView:numberOfRowsInSection:", "q32@0:8@16q24"),
                ("tableView:titleForHeaderInSection:", "@32@0:8@16q24"),
                ("tableView:titleForFooterInSection:", "@32@0:8@16q24"),
                ("tableView:cellForRowAtIndexPath:", "@32@0:8@16@24"),
            ):
                runtime._add(runtime.classes["FanqieAdBlockOptionsController"], selector,
                             runtime.SETTINGS_DATA_SOURCE, encoding)
        call(cpu, labels, "LFQH_FQHPageInstall")
    runtime.objects[runtime.DEFAULTS].state["values"].pop("FanqieX.DiagnosticsEnabled", None)
    grouped = release_version(runtime.data) in ("1.78R24", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6")
    if grouped:
        runtime._class("FQXBookExportPlugin", "NSObject")
    table = state(options)["tableView"]
    call(cpu, labels, "LFQH_FQHInstallOptionsToggles", options)
    header = state(table)["tableHeaderView"]
    footer = state(table)["tableFooterView"]
    appearance = state(state(navigation)["leftBarButtonItem"])
    require(runtime.string_value(appearance["content"]) == "外观", "Appearance occupies left toolbar item")
    require(len(state(state(navigation)["rightBarButtonItems"])["items"]) == 2,
            "Search and Done both remain reachable")
    require(sum(runtime.is_kind(v, runtime.classes["UISearchBar"]) for v in descendants(header)) == 1,
            "Settings have one search field")
    by_title = {
        runtime.string_value(state(v).get("accessibilityLabel", 0)): v
        for v in descendants(header)
        if runtime.is_kind(v, runtime.classes["UISwitch"])
    }
    search = next(v for v in descendants(header) if runtime.is_kind(v, runtime.classes["UISearchBar"]))
    router = state(search)["delegate"]
    has_local_reward = struct.unpack_from("<I", runtime.data, 0x818)[0] < 0x15706
    if has_local_reward:
        reward = next(v for v in descendants(footer)
                      if runtime.string_value(state(v).get("accessibilityLabel", 0)) == "模拟立即领取")
        reward_switch = next(v for v in descendants(footer)
                             if runtime.string_value(state(v).get("accessibilityLabel", 0)) == "听书奖励本地测试"
                             and runtime.is_kind(v, runtime.classes["UISwitch"]))
    else:
        for panel in (header, footer):
            for view in descendants(panel):
                label = runtime.string_value(state(view).get("accessibilityLabel", 0))
                require(label not in ("听书奖励本地测试", "模拟立即领取"),
                        "The retired local reward controls are absent")
        require(not runtime.get_method(runtime.objects[router].cls, runtime.sel("fqx178_testListenReward:")),
                "The legacy router exposes no local reward action")
    diagnostic_switch = next(v for v in descendants(footer)
                             if runtime.string_value(state(v).get("accessibilityLabel", 0)) == "开启诊断"
                             and runtime.is_kind(v, runtime.classes["UISwitch"]))
    require(bool(state(diagnostic_switch)["isOn"]) == new_layout, "The UI reflects the release diagnostics default")
    if new_layout:
        viewport = runtime.view("UIView", "settings sheet viewport", (0., 0., 440., 806.))
        state(options)["navigationController"] = runtime.obj("UINavigationController", "settings navigation",
                                                              viewIfLoaded=viewport)
        for width in (320., 428.):
            table_width = width + 40.
            runtime.size_settings_view(table, (0., 0., table_width, 806.))
            runtime.size_settings_view(viewport, (0., 0., width, 806.))
            for wrapper in (header, footer):
                x, y, _, height = state(wrapper)["frame"]
                runtime.size_settings_view(wrapper, (x, y, table_width, height))
            send(cpu, runtime, options, "viewDidLayoutSubviews")
            require(state(header)["frame"][2] == state(footer)["frame"][2] == table_width,
                    "Header and footer keep the settled width owned by UITableView")
            cards = [v for panel in (header, footer) for v in state(panel)["subviews"] if v != search]
            require(all(state(v)["frame"][0] == 20. and state(v)["frame"][2] == width - 40. for v in cards),
                    "All cards fit the visible settings viewport with symmetric insets")
            for panel in (header, footer):
                for switch in descendants(panel):
                    if not runtime.is_kind(switch, runtime.classes["UISwitch"]):
                        continue
                    parent = state(switch)["superview"]
                    x, _, w, _ = state(switch)["frame"]
                    require(x + w == state(parent)["bounds"][2] - 20.,
                            "Every switch fits inside its card with the same 20 pt right margin")
            search_frame = state(search)["frame"]
            require(search_frame[0] == 16. and search_frame[2] == width - 32.,
                    "Search field has symmetric insets")
        require(runtime.settings_layout_calls == 2, "The options layout forwards to the original")
        if release_version(runtime.data) in ("1.78R19", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6"):
            require(send(cpu, runtime, options, "numberOfSectionsInTableView:", table)["result"] == 1,
                    "The primary settings page keeps only the native appearance section")
            require(send(cpu, runtime, options, "tableView:numberOfRowsInSection:", table, 0)["result"] == 1,
                    "The first page excludes ad and welfare rows")
            path = runtime.obj("NSIndexPath", "root first row", row=0, section=0)
            mapped = send(cpu, runtime, options, "tableView:cellForRowAtIndexPath:", table, path)["result"]
            require(state(mapped)["section"] == 3 and state(mapped)["row"] == 0,
                    "The glass setting uses the original appearance cell and action")
            ads = next(v for v in descendants(header)
                       if runtime.string_value(state(v).get("accessibilityLabel", 0)) == "广告与福利")
            target, action, _ = state(ads)["control_targets"][0]
            send(cpu, runtime, target, runtime.selector_names[action], ads)
            page = state(state(options)["navigationController"])["pushedViewController"]
            require(send(cpu, runtime, page, "numberOfSectionsInTableView:", table)["result"] == 3,
                    "The secondary page exposes all native ad and welfare sections")
            for section, rows in enumerate((6, 9, 3)):
                require(send(cpu, runtime, page, "tableView:numberOfRowsInSection:", table, section)["result"] == rows,
                        "Secondary sections retain every original switch")
                path = runtime.obj("NSIndexPath", "secondary row", row=rows-1, section=section)
                require(send(cpu, runtime, page, "tableView:cellForRowAtIndexPath:", table, path)["result"] == path,
                        "Secondary cells keep their original index and setting action")
        screenshot_switch = by_title["截图后一键分享"]
        pendant = runtime.view("SSReadingShareScreenshotPendantView", "reading screenshot share")
        action_object = runtime.obj("NSObject", "host share callback")
        require(state(screenshot_switch)["isOn"], "Reader screenshot share preserves the host default")
        for enabled in (True, False, True):
            target, action, _ = state(screenshot_switch)["control_targets"][0]
            state(screenshot_switch)["isOn"] = enabled
            send(cpu, runtime, target, runtime.selector_names[action], screenshot_switch)
            send(cpu, runtime, pendant, "showWithShareAction:", action_object)
        require(runtime.screenshot_share_calls == [action_object, action_object],
                "The switch suppresses only the reader screenshot share presentation and can restore it")
    if has_local_reward:
        target, action, _ = state(reward)["control_targets"][0]
        send(cpu, runtime, target, runtime.selector_names[action], reward)
        require("请先打开" in runtime.string_value(state(state(options)["presentedViewController"])["message"]),
                "An unarmed test does not report a simulated award")
        state(options)["presentedViewController"] = 0
        target, action, _ = state(reward_switch)["control_targets"][0]
        state(reward_switch)["isOn"] = True
        send(cpu, runtime, target, runtime.selector_names[action], reward_switch)
        target, action, _ = state(reward)["control_targets"][0]
        send(cpu, runtime, target, runtime.selector_names[action], reward)
        reward_message = runtime.string_value(state(state(options)["presentedViewController"])["message"])
        require("模拟领取成功" in reward_message and "等待 0 秒" in reward_message and "账号余额不变" in reward_message,
                "The armed test immediately reports only a local simulated award")
    state(options)["presentedViewController"] = 0

    def shown(identifier):
        visible_rows = [row for group in state(header)["subviews"] if not state(group).get("hidden")
                        for row in state(group).get("subviews", ()) if not state(row).get("hidden")]
        return any(identifier in (runtime.string_value(state(row).get("accessibilityIdentifier", 0)) or "")
                   for row in visible_rows)

    for query, present, absent in (("右按大", "短剧右侧互动按钮", "暂停时显示界面"),
                                   ("滚 收缩", "短剧滚动自动收缩", "默认最高画质")):
        send(cpu, runtime, router, "searchBar:textDidChange:", search, runtime.text_object(query))
        require(shown(present) and not shown(absent), f"Search filters groups by fuzzy setting title: {query!r}")
    reward_queries = ("听书奖励",) if has_local_reward else ("听书奖励", "模拟立即领取")
    for query in reward_queries:
        send(cpu, runtime, router, "searchBar:textDidChange:", search, runtime.text_object(query))
        require(shown(query) == has_local_reward and not shown("默认清屏播放"),
                f"Search finds the local reward only before it was retired: {query!r}")
    send(cpu, runtime, router, "searchBar:textDidChange:", search, runtime.text_object(""))
    require(shown("暂停时显示界面") and shown("短剧右侧互动按钮"), "Clearing search restores groups")
    if release_version(runtime.data) in ("1.78R23", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6"):
        for title, selector in (("默认启动页", "openStartupFromController:"),
                                ("书城顶部分类", "openBookstoreFromController:"),
                                ("设置备份与恢复", "presentFromController:")):
            row = next(v for v in descendants(header)
                       if runtime.string_value(state(v).get("accessibilityLabel", 0)) == title)
            target, action, _ = state(row)["control_targets"][0]
            send(cpu, runtime, target, runtime.selector_names[action], row)
            require(runtime.settings_destination == (selector, options),
                    "Each page/configuration row opens its corresponding secondary page")
    if grouped:
        original_navigation = state(options).get("navigationController", 0)
        runtime._class("FQXSettingsMenu", "UIViewController")
        visible = runtime.obj("FQXSettingsMenu", "visible settings submenu", presentedViewController=0)
        state(options)["navigationController"] = runtime.obj("UINavigationController", "grouped settings stack",
                                                               topViewController=visible)
        for title, selector, expected in (("导出书籍", "openFromSettingsController:", visible),
                                          ("默认启动页", "openStartupFromController:", visible),
                                          ("设置备份与恢复", "presentFromController:", options)):
            row = next(v for v in descendants(header)
                       if runtime.string_value(state(v).get("accessibilityLabel", 0)) == title)
            target, action, _ = state(row)["control_targets"][0]
            send(cpu, runtime, target, runtime.selector_names[action], row)
            require(runtime.settings_destination == (selector, expected),
                    "Grouped actions use the visible presenter while backup retains its root owner")
        if has_local_reward:
            target, action, _ = state(reward)["control_targets"][0]
            send(cpu, runtime, target, runtime.selector_names[action], reward)
            require(state(visible)["presentedViewController"] and not state(options)["presentedViewController"],
                    "Local reward presents on the visible grouped submenu")
        for selector in ("fqab_156_exportDiagnostics:", "fqab_156_presentDiagnostics:"):
            runtime._add(runtime.objects[options].cls, selector, runtime.DIAGNOSTIC_ACTION, "v24@0:8@16")
        export = next(v for v in descendants(footer)
                      if runtime.string_value(state(v).get("accessibilityLabel", 0)) == "导出日志")
        target, action, _ = state(export)["control_targets"][0]
        send(cpu, runtime, target, runtime.selector_names[action], export)
        require(runtime.settings_diagnostics_receiver == visible and
                runtime.get_method(runtime.classes["FQXSettingsMenu"], runtime.sel("fqab_156_presentDiagnostics:")),
                "Grouped diagnostic export and its asynchronous completion stay on the visible controller")
        state(options)["navigationController"] = original_navigation
    if release_version(runtime.data) in ("1.78R22", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6"):
        compact = by_title["短剧滚动自动收缩"]
        position_row = next(v for v in descendants(header)
                            if runtime.string_value(state(v).get("accessibilityLabel", 0)) == "收缩位置")
        navigation_view = runtime.view("UIView", "compact settings viewport", (0., 0., 390., 844.))
        nav = runtime.obj("UINavigationController", "compact settings navigation", viewIfLoaded=navigation_view)
        state(options)["navigationController"] = nav

        def tap(control):
            target, action, _ = state(control)["control_targets"][0]
            send(cpu, runtime, target, runtime.selector_names[action], control)

        if release_version(runtime.data) in ("2.0.1beta4", "2.0.1beta5", "2.0.1beta6"):
            zoom = by_title["刷视频时自动缩放 Dock"]
            require(not state(zoom)["isOn"] and not state(compact)["isOn"],
                    "Both short-video Dock switches start off")
            values = state(runtime.DEFAULTS)["values"]
            for switch, other, key in ((zoom, compact, "FanqieX.DramaDockScrollZoom.1"),
                                       (compact, zoom, "FanqieX.BottomDramaCompact.1")):
                state(switch)["isOn"] = True
                tap(switch)
                require(values.get(key) and not state(other)["isOn"] and
                        bool(state(position_row)["hidden"]) == (switch == zoom),
                        "Each Dock switch visibly turns off the other; only the single button has a position")
            state(compact)["isOn"] = False
            tap(compact)
        require(state(position_row)["hidden"], "Position is hidden by default")
        query = runtime.text_object("收缩")
        state(search)["text"] = query
        send(cpu, runtime, state(search)["delegate"], "searchBar:textDidChange:", search, query)
        require(state(position_row)["hidden"], "Settings search cannot expose position when auto-compact is off")
        state(compact)["isOn"] = True
        tap(compact)
        require(not state(position_row)["hidden"] and not shown("暂停时显示界面"),
                "Enabling compaction reveals position while retaining the current settings search")
        values = state(runtime.DEFAULTS)["values"]
        position_key = "FanqieX.BottomDramaCompactPosition.1"
        selected = "居中" if release_version(runtime.data) == "2.0.1beta3" else "右侧"
        for selection, index in (("左侧", 1), ("居中", 2), ("右侧", 0), ("居中", 2)):
            tap(position_row)
            page = state(nav)["pushedViewController"]
            require(runtime.string_value(state(page)["title"]) == "收缩位置", "Position opens its own page")
            choices = {runtime.string_value(state(v)["accessibilityLabel"]): v
                       for v in descendants(state(page)["view"]) if state(v).get("accessibilityLabel")}
            require(list(choices) == ["左侧", "居中", "右侧"], "The second page offers all three positions")
            checked = runtime.string_value(state(choices[selected])["titles"][0])
            require(checked.endswith("✓"), "The secondary page marks the saved position")
            tap(choices[selection])
            require(values[position_key] == index and "pushedViewController" not in state(nav),
                    "A position tap saves the choice and returns to the settings page")
            selected = selection
        state(compact)["isOn"] = False
        tap(compact)
        require(state(position_row)["hidden"] and values[position_key] == 2,
                "Disabling compaction hides the row and keeps the last chosen position")
        state(compact)["isOn"] = True
        tap(compact)
        send(cpu, runtime, appearance["target"], runtime.selector_names[appearance["action"]], 0)
        appearance_page = state(nav)["pushedViewController"]
        send(cpu, runtime, appearance_page, "fqx178_resetBottom:", 0)
        require(state(position_row)["hidden"] and not state(compact)["isOn"] and position_key not in values,
                "Restoring dock defaults clears the position and synchronizes the root switch and row")
        state(search)["text"] = runtime.text_object("")
        send(cpu, runtime, state(search)["delegate"], "searchBar:textDidChange:", search, state(search)["text"])
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieX.DiagnosticsEnabled"] = True
    diagnostic_owner = runtime.classes["SSReaderParagraphCommentAdapter"]
    cache_key = runtime.slide + labels["LFQD_DiagnosticsEnabledKey"]
    runtime.associations.pop((diagnostic_owner, cache_key), None)
    call(cpu, labels, "LFQD_FQDInitDiagnosticsPolicy")
    names = [f"底栏显示：{title}" for title in titles] + [
        "书架显示今日看听读时长", "我的显示金币与福利卡片", "阅读菜单显示上下栏背景",
        "横屏画面铺满（等比裁切）", "书架显示筛选按钮", "书外主题跟随系统"]
    if release_version(runtime.data) in ("1.78R20", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6"):
        names.append("我的显示推荐内容")
    return [by_title[title] for title in names]
