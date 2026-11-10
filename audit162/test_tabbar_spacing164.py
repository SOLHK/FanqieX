#!/usr/bin/env python3
"""Execute the factory's spacing branch and button-width instructions.

UIKit safe-area values use explicit boundary fixtures. These checks do not
render glass, measure labels or claim native device touch acceptance.
"""
import argparse
import json
from pathlib import Path
import struct

from arm64 import CPU, MASK64, require
from mock_uikit import Runtime


class SpacingRuntime(Runtime):
    def __init__(self, data, slide, insets):
        super().__init__(data, slide)
        self.insets = insets
        self.continuation = None

    def handle(self, cpu, pc):
        relative = pc - self.slide
        if relative in (0x6580, 0x643c, 0x6a20):
            self.continuation = relative
            cpu.pc = cpu.RETURN
            return True
        if relative == 0xa5d4 and self.selector_names.get(cpu.x[1]) == 'safeAreaInsets':
            require(cpu.x[0] == self.BAR, 'Safe-area lookup uses the pinned host bar')
            self.event('safeAreaInsets', self.BAR)
            self.clobber(cpu, fp_result=self.insets)
            cpu.pc = cpu.x[30]
            return True
        return super().handle(cpu, pc)


def spacing(data, width, count, insets, origin, slide):
    rt = SpacingRuntime(data, slide, insets)
    words_end, = struct.unpack_from('<I', data, 0x800 + 61 * 4)
    cpu = CPU(data, rt, slide, ranges=[(0x800, 0x4000), (0x643c, 0x6a20),
                                     (0x14080, 0x800 + words_end)])
    cpu.x[19] = rt.BAR
    cpu.wf(8, 7)
    cpu.wf(9, 56)
    cpu.wf(10, origin)
    cpu.wf(11, width)
    cpu.wf(13, count)
    before_x, before_v, before_sp = cpu.x.copy(), cpu.v.copy(), cpu.sp
    cpu.run(0x6568, check_abi=False)
    require(cpu.sp == before_sp, 'Spacing balances its temporary stack')
    require(all(cpu.x[index] == before_x[index] for index in range(18, 30) if index != 21),
            'Spacing preserves factory callee-saved integer registers')
    require(all(cpu.v[index] & MASK64 == before_v[index] & MASK64
                for index in range(8, 16) if index not in (10, 11)),
            'Spacing preserves factory height, item count and other saved FP registers')
    require(not any(event['event'] in ('setFrame', 'setHidden', 'addSubview') for event in rt.events),
            'Spacing adjusts factory inputs before any presentation mutation')
    return rt, cpu


def check_case(data, width, count, insets, origin, slide):
    rt, cpu = spacing(data, width, count, insets, origin, slide)
    safe_margin = max(insets[1], insets[3])
    capacity_margin = (width - (count * 44 + 8)) / 2
    if safe_margin > capacity_margin:
        require(rt.continuation == 0x643c, 'Unfittable safe area restores the original host bar')
        require(cpu.fp(10) == origin and cpu.fp(11) == width, 'Rejected layout retains original inputs')
        return {'width': width, 'tabs': count, 'safe_area': insets,
                'slide': hex(slide), 'restored': True}
    margin = min(max(20, safe_margin), capacity_margin)
    left, frame_width = cpu.fp(10), cpu.fp(11)
    require(rt.continuation == 0x6580, 'The factory continues with final symmetric geometry')
    require(cpu.x[21] == slide + 0xbac9, 'Continuation restores original selector-address setup')
    require(left - origin == margin and origin + width - (left + frame_width) == margin,
            'Left and right margins match in the original bar coordinate system')
    require(margin >= safe_margin and frame_width >= count * 44 + 8,
            'Layout respects the safe area and preserves 44-point button targets')

    # The unchanged factory consumes this adjusted width before laying out
    # button frames. Run its actual row-padding, height and FDIV instructions.
    cpu.wf(9, 56)
    cpu.wf(13, count)
    cpu.run(0x69fc, check_abi=False)
    stride = cpu.fp(13)
    require(rt.continuation == 0x6a20, 'The real button-width calculation executed')
    require(abs(stride - (frame_width - 8) / count) < 1e-9 and stride >= 44,
            'Each host button receives an equal usable column')
    centers = [left + 4 + stride * (index + 0.5) for index in range(count)]
    require(abs((centers[0] + centers[-1]) / 2 - (origin + width / 2)) < 1e-9,
            'The first and last host content columns center across the capsule')
    require(cpu.fp(12) == 4, 'The existing vertical content inset is preserved')
    return {'width': width, 'tabs': count, 'safe_area': insets, 'slide': hex(slide),
            'margin': margin, 'button_width': stride, 'origin': origin, 'restored': False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--baseline', type=Path)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    require(struct.unpack_from('<I', data, 0x818)[0] in (0x10604,0x10605,0x10606,0x10607,0x10701,0x10702,0x10703,0x10704), 'Expected actual 1.6.4 candidate')
    fixtures = [
        (320, 4, (0, 0, 0, 0), 0),
        (375, 4, (0, 0, 34, 0), 0),
        (390, 4, (0, 0, 34, 0), 0),
        (440, 4, (0, 0, 34, 0), 0),
        (744, 4, (0, 44, 21, 0), 0),
        (852, 4, (0, 0, 21, 59), 0),
        (390, 4, (0, 0, 34, 0), 13),
        (208, 4, (0, 0, 0, 0), 0),
        (310, 6, (0, 0, 0, 0), 0),
        (208, 4, (0, 20, 0, 20), 0),
    ]
    fixtures.extend((440, count, (0, 0, 34, 0), 0) for count in (2, 3, 5, 6))
    cases = [check_case(data, width, count, insets, origin, slide)
             for slide in (0, 0x180000000) for width, count, insets, origin in fixtures]
    negative = False
    if args.baseline:
        old = args.baseline.read_bytes()
        _, cpu = spacing(old, 390, 4, (0, 0, 34, 0), 0, 0)
        require(cpu.fp(10) == 12 and cpu.fp(11) == 366,
                'Actual old factory retains the reported crowded 12-point margins')
        negative = True
    report = {'passed': True, 'device_tested': False, 'cases': cases,
              'baseline_reproduced': negative,
              'scope': 'Actual ARM64 factory spacing and button-width inputs with modeled UIKit safe areas'}
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
