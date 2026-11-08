#!/usr/bin/env python3
"""Exercise the complete emitted repair with the two logged nested-feed sizes.

No repair entry, feed helper, or observer is replaced by Python. Only the
documented framework/host API boundaries are modeled. This is not a device run.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct

from arm64 import CPU, require
from feed_runtime import Runtime as Feed, fixture, put_frame
from interaction_runtime import Runtime as Interaction, read_entries
from legacy_runtime import Runtime as Legacy
from new_scenarios import saved
from test_feed_viewport import labels_for


class Integrated(Interaction, Feed, Legacy):
    def handle(self, cpu, pc):
        if pc - self.slide == self.entries['main_repair']:
            # Bypass only Interaction's component-audit isolation. Executing
            # Lrepair must exercise the actual entire repair and observer.
            return super(Interaction, self).handle(cpu, pc)
        return super().handle(cpu, pc)


def run(data, composed):
    entries = read_entries(data)
    feed_entries = labels_for(data, composed)
    words = struct.unpack_from('<64I', data, 0x800)
    ext = struct.unpack_from('<28I', data, 0x800 + words[60] + 16)
    cases = []
    instruction_count = 0
    for tab, inner, outer_height, outer_offset in (
        (2, 784, 858, 597.6666666666666),
        (3, 776, 850, 313),
    ):
        r = Integrated(data, entries, selected=tab)
        f = fixture(r, tab=tab, inner_height=inner,
                    outer_height=outer_height, outer_offset=outer_offset)
        # Keep the actual modeled original buttons/items connected to the
        # original selection route while using the supplied log geometry.
        r.objects[r.BAR].state.update(
            items=r.obj('NSArray', 'items', items=r.items.copy()),
            selectedItem=r.items[tab])
        f['items'] = r.items
        feed = f['feed']
        c = CPU(data, r, ranges=[(0x900, entries['main_code_end']),
                                (0x14080, entries['extension_code_end']),
                                (0x4000, 0xa574)])
        c.pointers.update(r.rebase_pointers)
        c.run(entries['main_repair'], r.BAR, max_steps=3000000)
        st = r.objects[feed].state
        require(st['frame'] == (0, 0, 440, 850),
                'Whole-tree repair finds and extends the actual nested feed')
        require(st['contentInset'] == (3, 4, 5 + 850 - inner, 6),
                'Whole repair preserves the last-item scroll range')
        require(feed_entries['LFconsider'] in c.executed and
                feed_entries['LFwatch'] in c.executed,
                'Feed consideration and post-layout hook execute in full repair')
        lens = r.associated(r.PROXY, 'lens')
        require(lens and r.objects[lens].state['effect'] == 0,
                'Resting selected capsule coexists with feed geometry repair')
        require(r.objects[lens].state.get('userInteractionEnabled') is False,
                'The selected overlay does not intercept the original buttons')
        cases.append({'name': 'full_repair_nested_feed_and_gray_selection',
                      'tab_index': tab, 'extension_points': 850 - inner,
                      'passed': True})

        def host_layout(runtime, receiver):
            if receiver == feed:
                put_frame(runtime, feed, (0, 0, 440, inner))
        r.layout_mutator = host_layout
        before_calls = sum(e['event'] == 'original_layout' for e in r.events)
        r.invoke(c, feed, r.sel('layoutSubviews'))
        require(st['frame'][3] == 850 and st['contentInset'][2] == 5 + 850 - inner,
                'Original host layout reset is repaired in the same callback')
        require(sum(e['event'] == 'original_layout' for e in r.events) == before_calls + 1,
                'Original feed layout executes once')
        cases.append({'name': 'full_repair_installed_posthook', 'tab_index': tab,
                      'passed': True})

        # The original tab action invokes sync -> complete repair. The old
        # feed must be retired before the next page can become active.
        c.run(0x56c0, r.BAR, r.sel('fqab_homeTabPressed:'), r.buttons[0],
              max_steps=3000000)
        require(r.route_calls == [0] and r.selected_index() == 0,
                'Original tab target/action still routes exactly once')
        require(st['frame'][3] == inner and st['contentInset'] == (3, 4, 5, 6),
                'Switching to bookstore restores the old nested-feed geometry')
        require(r.objects[f['cell']].state['clipsToBounds'] and
                r.objects[f['container']].state['clipsToBounds'],
                'Switching page restores intermediate clipping')
        cases.append({'name': 'original_tab_action_restores_nested_feed',
                      'tab_index': tab, 'passed': True})

        r.flush_main(c)
        r.drain_operations(c)
        records = saved(r)
        require(any(item.get('data', {}).get('selectedIndex') == 0 for item in records),
                'The actual observer records the selected page change')
        c.run(0x6db4, r.BAR, r.PROXY, max_steps=3000000)
        require(not r.associated(r.PROXY, 'overlay'),
                'Original restore releases overlay ownership')
        require((r.BAR, feed_entries['LFrecords_key']) not in r.associations,
                'Original restore releases nested-feed records')
        require((feed, feed_entries['LFowner_key']) not in r.associations,
                'Original restore releases feed observation')
        require(all(r.objects[b].state['superview'] == r.PROXY_CONTENT for b in r.buttons),
                'Original button hierarchy is restored')
        cases.append({'name': 'observer_and_original_restore_complete_path',
                      'tab_index': tab, 'passed': True})
        instruction_count += c.steps
    return {'passed': True, 'candidate_sha256': hashlib.sha256(data).hexdigest(),
            'instructions': instruction_count, 'tests': cases,
            'repair_entries_intercepted': False, 'device_ui_tested': False,
            'limits': ['UIKit/Foundation and original host method bodies are modeled.',
                       'No native rendering, physical touches, iOS load or installation tested.']}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    report = run(args.candidate.read_bytes(), args.candidate.with_suffix('.composed.s'))
    target = args.report or args.candidate.with_suffix('.feed-integration.json')
    target.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'passed': True, 'tests': len(report['tests']),
                      'candidate_sha256': report['candidate_sha256'],
                      'instructions': report['instructions'], 'report': str(target)}))
