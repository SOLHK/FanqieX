#!/usr/bin/env python3
"""Exercise comment-related ad and glass hooks in the candidate ARM64 image."""
import argparse
import json
from pathlib import Path
import struct

from arm64 import CPU, require
from mock_uikit import Runtime


class HookRuntime(Runtime):
    HOST_IMP = 0x33000500

    def __init__(self, data, slide):
        super().__init__(data, slide)
        self._class('CommentConfigBase', 'NSObject')
        self._class('SSBizAdConfigHelper', 'CommentConfigBase')
        self._class('SSAdCommonConfigAdapter', 'CommentConfigBase')
        self._class('ParagraphCommentConfig', 'CommentConfigBase')
        self.failed_adds = set()
        self.unknown_superclasses = set()
        self.boundary_results = {}

    def handle(self, cpu, pc):
        entry = pc - self.slide
        receiver, selector = cpu.x[:2]
        marker=self.data.find(b'FQ164DIA')
        decision=struct.unpack_from('<I',self.data,marker+16)[0]+0x800 if marker>=0 else -1
        native_install=struct.unpack_from('<I',self.data,marker+8)[0]+0x800 if marker>=0 else -1
        if entry in (decision,native_install):
            # Decision serialization is exercised by the diagnostic suite.
            # This fixture retains real trampoline and original host behavior.
            result=0
        elif pc == self.HOST_IMP:
            result = 1
        elif pc == self.SUPERCLASS_IMP and receiver in self.unknown_superclasses:
            result = 0
        elif entry == 0xa58c and (receiver, selector) in self.failed_adds:
            self.event('rejected_class_addMethod', receiver,
                       selector=self.selector_names[selector])
            result = 0
        elif entry == 0x4018 and self.boundary_results:
            # The fixture represents a host that passed the independent UUID gate.
            cpu.pc = self.slide + 0x40b8
            return True
        elif entry in self.boundary_results:
            result = self.boundary_results[entry]
        else:
            return super().handle(cpu, pc)
        self.clobber(cpu, result)
        cpu.pc = cpu.x[30]
        return True


def make_cpu(rt, include_glass=False):
    data, slide = rt.data, rt.slide
    extension_code_end, = struct.unpack_from('<I', data, 0x800 + 61 * 4)
    cpu = CPU(data, rt, slide, ranges=[(0x800, 0x4000), (0x4000, 0x4918),
                                     (0x14080, 0x800 + extension_code_end)])
    # Read the pinned image's ad and glass tables using their chained rebases.
    # The installer itself decides which rows run and which classes it mutates.
    offsets = list(range(0x100b0, 0x10170, 8))
    offsets.extend(0x10170 + 24 * index + field
                   for index in range(45) for field in (8, 16))
    if include_glass:
        for base, count in ((0x10660, 24), (0x10a78, 41), (0x11120, 10)):
            offsets.extend(range(base, base + 40 * count, 8))
    for offset in offsets:
        pointer, = struct.unpack_from('<Q', data, offset)
        cpu.pointers[slide + offset] = slide + (pointer & ((1 << 36) - 1))
    return cpu


def check_comment_rules(data, slide, mode):
    rt = HookRuntime(data, slide)
    cpu = make_cpu(rt)

    parent = rt.classes['CommentConfigBase']
    sibling = rt.classes['ParagraphCommentConfig']
    cases = []
    for class_name, name, is_class_method in (
        ('SSBizAdConfigHelper', 'enableSeriesCommentAd', True),
        ('SSAdCommonConfigAdapter', 'commentListAdSwitch', False),
    ):
        target = rt.classes[class_name]
        if is_class_method:
            owner, other, ancestor = (rt.metaclasses[x] for x in (target, sibling, parent))
        else:
            owner, other, ancestor = target, sibling, parent
        selector = rt.sel(name)
        encoding = 'v16@0:8' if mode == 'wrong_encoding' else 'B16@0:8'
        inherited = rt._add(ancestor, name, rt.HOST_IMP, encoding)
        original = inherited
        if mode == 'owned':
            original = rt._add(owner, name, rt.HOST_IMP, encoding)
        if mode == 'add_rejected':
            rt.failed_adds.add((owner, selector))
        if mode == 'unknown_owner':
            rt.unknown_superclasses.add(target)
        cases.append((owner, other, selector, inherited, original))

    for _ in range(2):
        cpu.run(0x4650, args=(1 << 12,))
        for owner, other, selector, inherited, original in cases:
            require(rt.get_method(other, selector) == inherited,
                    'Sibling paragraph-comment class retains the parent Method')
            require(rt.methods[inherited]['imp'] == rt.HOST_IMP,
                    'Original shared implementation is untouched')
            method = rt.get_method(owner, selector)
            if mode in ('wrong_encoding', 'add_rejected', 'unknown_owner'):
                require(method == inherited, 'Unsafe registration leaves target unchanged')
                require(not any(e['event'] == 'method_setImplementation' for e in rt.events),
                        'Unsafe input never reaches the runtime setter')
                continue
            require(method != inherited and rt.methods[method]['class'] == owner,
                    'Ad implementation belongs to the target class or metaclass')
            if mode == 'owned':
                require(method == original, 'Existing own Method is reused')
            replacement = rt.methods[method]['imp']
            if struct.unpack_from('<I',data,0x818)[0] != 0x10604:
                require(replacement == slide + 0x48d0, 'Target uses the original ad-filter replacement')
            else:
                require(replacement >= slide+0x14080, 'Target uses a scoped diagnostic rule trampoline')
            require(cpu.run(replacement - slide, args=(owner, selector))['result'] == 0,
                    'The target ad remains blocked')
            require(cpu.run(rt.HOST_IMP - slide, args=(other, selector))['result'] == 1,
                    'Sibling host implementation remains callable')
    if mode == 'add_rejected':
        require(sum(e['event'] == 'rejected_class_addMethod' for e in rt.events) == 4,
                'Both installations exercise both runtime failures')
    return {'slide': hex(slide), 'mode': mode, 'rules': len(cases)}


def check_glass_rules(data, slide):
    rt = HookRuntime(data, slide)
    rt.own[rt.TabBar].pop(rt.sel('fqab_barRatio'))  # Keep the independent overlay idle.
    rt._class('WKContentWorld', 'NSObject')
    rt._class('CAShapeLayer', 'NSObject')
    parent = rt._class('SharedCommentView', 'UIView')
    sibling = rt._class('ParagraphCommentBubbleView', 'SharedCommentView')
    html_parent = rt._class('SharedWebDelegate', 'NSObject')
    html_sibling = rt._class('ParagraphCommentWebDelegate', 'SharedWebDelegate')
    cpu = make_cpu(rt, include_glass=True)

    # Model independent setup and execute all three legacy glass installation
    # loops from the candidate bytes.
    rt.boundary_results.update({
        0xa5bc: 0,            # autorelease pool push
        0xa574: 0,            # autorelease pool pop
        0x4338: 0x40000,      # saved options: glass enabled
        0x43fc: 0,            # prepare system glass
        0x4704: 0,            # install settings entry
        0x47dc: 1,            # glass availability
    })
    layout = 'layoutSubviews'
    web = 'webView:didStartProvisionalNavigation:'
    inherited_layout = rt._add(parent, layout, rt.HOST_IMP, 'v16@0:8')
    inherited_web = rt._add(html_parent, web, rt.HOST_IMP, 'v32@0:8@16@24')
    rows = (
        ('FQCCommentBottomToolBar', 'SharedCommentView', sibling,
         layout, inherited_layout, 'fqab_commentTools', 0x5f28),
        ('FQCCommentV1BottomToolBar', 'SharedCommentView', sibling,
         layout, inherited_layout, 'fqab_v4_comment_input', 0x82a4),
        ('BDWebView', 'SharedWebDelegate', html_sibling,
         web, inherited_web, 'fqab_htmlStart', 0x8e60),
    )
    targets = [rt._class(row[0], row[1]) for row in rows]
    cpu.run(0x4000)
    for target, (_, _, sibling, name, inherited, alias, replacement) in zip(targets, rows):
        selector = rt.sel(name)
        owned = rt.get_method(target, selector)
        require(owned != inherited and rt.methods[owned]['class'] == target,
                'Legacy glass installs on the named target only')
        require(rt.methods[owned]['imp'] == slide + replacement, 'Expected legacy glass replacement')
        original_alias = rt.get_method(target, rt.sel(alias))
        require(original_alias and rt.methods[original_alias]['imp'] == rt.HOST_IMP,
                'Legacy glass alias preserves original implementation')
        require(rt.get_method(sibling, selector) == inherited and
                rt.methods[inherited]['imp'] == rt.HOST_IMP,
                'Unrelated paragraph-comment sibling retains its original behavior')
    return {'slide': hex(slide), 'mode': 'legacy_glass', 'rules': len(rows)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    slides = (0, 0x180000000)
    cases = [check_comment_rules(data, slide, mode) for slide in slides
             for mode in ('inherited', 'owned', 'wrong_encoding', 'add_rejected', 'unknown_owner')]
    cases.extend(check_glass_rules(data, slide) for slide in slides)
    report = {'passed': True, 'device_tested': False, 'cases': cases}
    if args.report:
        args.report.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
