#!/usr/bin/env python3
"""Execute old/new ARM64 diagnostic observers across modeled native boundaries.

The observer, color canonicalizer, change/rate gate, snapshot builder, queue,
one-hour pruning and export serialization all execute the supplied dylib's
instructions. Only public UIKit/Foundation services are modeled. No rendered
UIKit pixels, native latency, iPhone loading or signing acceptance is claimed.

SemanticBoundary is intentionally importable without importing another runtime
module, so broader integration audits can prepend it to their existing runtime
MRO without replacing any patch implementation or introducing a circular import.
"""
import argparse
import hashlib
import json
import math
from pathlib import Path
import plistlib
import struct

from arm64 import CPU, bits, require


ROOT = Path(__file__).resolve().parents[1]
BASELINE_SHA = '6031d37a2d4e41038338eb0d5730bb6f30833fb0c3499bf4f5b781a88a64a7a1'
BASELINE158_SHA = '55a2c02e5962ad740816aaf2f8f2f6d9269eb9ecce37c69402897ff3776a4354'
BASELINE159_SHA = 'e4435d143a22e21991ae753bca5af3f2d945dd6cd6ac3ab514c71d2a5e4d0810'
ENTRY_INDEX = {
    'repair': 3, 'edge_key': 22, 'ui_present': 34, 'diagnostic_init': 35,
    'diagnostic_enqueue': 36, 'diagnostic_tick': 37,
    'diagnostic_maintenance': 38, 'diagnostic_observe': 39,
    'diagnostic_snapshot': 40, 'diagnostic_snapshot_all': 41,
    'diagnostic_heartbeat': 42, 'signature_key': 51, 'code_end': 55,
    'extension': 60, 'extension_code_end': 61,
}


def entries(data):
    words = struct.unpack_from('<64I', data, 0x800)
    require(words[6] in (0x10507, 0x10508, 0x10509, 0x10600), 'Pinned 1.5.7/1.5.8/1.5.9/1.6.0 directory')
    result = {name: 0x800+words[index] for name, index in ENTRY_INDEX.items()}
    result['version'] = words[6]
    if words[6] in (0x10508, 0x10509, 0x10600):
        marker = b'FQ158DIA'
        require(data.count(marker) == 1, 'One semantic diagnostic directory')
        at = data.index(marker)
        result.update(dict(zip(('semantic_observe', 'semantic_color', 'semantic_time',
                                'critical_key', 'sample_time_key', 'observe_busy_key'),
                               struct.unpack_from('<6I', data, at+8))))
        require(result['extension'] <= result['semantic_observe'] < result['extension_code_end'],
                'Semantic observer is in the emitted executable extension')
        branch = struct.unpack_from('<I', data, result['diagnostic_observe'])[0]
        require(branch & 0xfc000000 == 0x14000000, 'Main observer is a tail branch')
        delta = branch & 0x03ffffff
        if delta & (1 << 25):
            delta -= 1 << 26
        require(result['diagnostic_observe']+4*delta == result['semantic_observe'],
                'Actual main-directory branch reaches audited semantic observer')
    return result


class SemanticBoundary:
    """Additional public APIs only; never short-circuit diagnostic code."""

    def __init__(self, *args, **kwargs):
        self.semantic_uptime = 1000.0
        self.semantic_color_reads = 0
        self.semantic_color_resolves = 0
        self.semantic_view_reads = 0
        self.semantic_snapshot_calls = []
        self.semantic_reenter = None
        super().__init__(*args, **kwargs)
        words = struct.unpack_from('<64I', self.data, 0x800)
        self.semantic_snapshot_entry = 0x800+words[40]

    def fresh_color(self, rgba=None, *, conversion='rgb', dynamic=None):
        rgba = None if rgba is None else tuple(rgba)
        value = ('dynamic-color' if dynamic is not None else
                 'unsupported-color' if rgba is None else
                 'UIExtendedSRGBColorSpace '+','.join(str(v) for v in rgba))
        return self.obj('UIColor', 'value_color', rgba=rgba, conversion=conversion,
                        dynamic=dynamic, value=value)

    def semantic_rgba(self, receiver):
        st = self.objects[receiver].state
        if 'rgba' in st:
            return st['rgba']
        name = self.objects[receiver].name
        if name == 'color:clearColor':
            return (0., 0., 0., 0.)
        if name in ('color:whiteColor', 'color:systemBackgroundColor'):
            return (1., 1., 1., 1.)
        if name in ('color:blackColor', 'color:labelColor'):
            return (0., 0., 0., 1.)
        # Unmodeled named/pattern colors remain explicitly unknown rather than
        # inventing a component mapping solely to make a diagnostic test pass.
        return None

    def handle(self, cpu, pc):
        self.current_cpu = cpu
        rel = pc-self.slide
        if rel == self.semantic_snapshot_entry:
            # Observation of entry, not a replacement: original instructions
            # continue below, including complete snapshot construction and IO.
            self.semantic_snapshot_calls.append({
                'uptime': self.semantic_uptime,
                'event': self.string(cpu.x[1]), 'bar': cpu.x[0],
            })
        if rel != 0xa5d4:
            return super().handle(cpu, pc)
        a = cpu.x[:8]
        receiver, selector = a[:2]
        name = self.selector_names.get(selector)
        if not receiver or receiver not in self.objects:
            return super().handle(cpu, pc)
        st = self.objects[receiver].state
        if self.is_kind(receiver, self.UIView):
            if name not in ('retain', 'release', 'autorelease', 'class', 'isKindOfClass:'):
                self.semantic_view_reads += 1
                require(self.thread == 'main', 'Public view reads stay on main')
        if name == 'systemUptime':
            require(receiver == self.PROCESS, 'Monotonic clock uses NSProcessInfo')
            return self.finish(cpu, fp=(self.semantic_uptime,))
        if name == 'traitCollection':
            return self.finish(cpu, self.obj('UITraitCollection', 'current_traits',
                contrast=st.get('accessibilityContrast', 0),
                interfaceStyle=st.get('userInterfaceStyle', 1)))
        if name == 'userInterfaceStyle':
            return self.finish(cpu, st.get('interfaceStyle', 1))
        if not self.is_kind(receiver, self.classes['UIColor']):
            return super().handle(cpu, pc)
        if name == 'resolvedColorWithTraitCollection:':
            require(a[2] in self.objects and self.is_kind(a[2], self.classes['UITraitCollection']),
                    'Resolve color with a real view trait object')
            self.semantic_color_resolves += 1
            rgba = self.semantic_rgba(receiver)
            if st.get('dynamic') is not None:
                rgba = st['dynamic'][self.objects[a[2]].state['interfaceStyle']]
            result = self.fresh_color(rgba, conversion=st.get('conversion', 'rgb'))
            if self.semantic_reenter:
                callback, self.semantic_reenter = self.semantic_reenter, None
                old_x, old_v, old_pc = cpu.x[:], cpu.v[:], cpu.pc
                callback(cpu)
                cpu.x[:], cpu.v[:], cpu.pc = old_x, old_v, old_pc
            return self.finish(cpu, result)
        if name in ('getRed:green:blue:alpha:', 'getWhite:alpha:'):
            self.semantic_color_reads += 1
            rgba = self.semantic_rgba(receiver)
            conversion = st.get('conversion', 'rgb')
            if rgba is None or conversion == 'unsupported':
                return self.finish(cpu, 0)
            if name == 'getRed:green:blue:alpha:':
                if conversion == 'gray':
                    return self.finish(cpu, 0)
                outputs = zip(a[2:6], rgba)
            else:
                if conversion != 'gray' and len(set(rgba[:3])) != 1:
                    return self.finish(cpu, 0)
                outputs = ((a[2], rgba[0]), (a[3], rgba[3]))
            for address, value in outputs:
                require(address and address % 8 == 0, 'CGFloat out pointer is nonnil/aligned')
                cpu.write(address, 8, bits(value))
            return self.finish(cpu, 1)
        return super().handle(cpu, pc)


def make(data, slide=0, *, disk_root=None):
    # Late import lets other audit runtimes import SemanticBoundary safely.
    from mock_foundation import Runtime as FoundationRuntime

    class Runtime(SemanticBoundary, FoundationRuntime):
        pass

    d = entries(data)
    r = Runtime(data, slide=slide, disk_root=disk_root)
    c = CPU(data, r, slide=slide, ranges=[
        (0x900, d['code_end']), (d['extension']+128, d['extension_code_end']),
        (0x4338, 0x43fc), (0x711c, 0x746c),
    ])
    c.pointers.update(r.rebase_pointers)
    r.objects[r.BAR].state['backgroundColor'] = r.fresh_color((0., 0., 0., 0.))
    r.objects[r.ROOT].state['backgroundColor'] = r.fresh_color((1., 1., 1., 1.))
    return c, r, d


def observe(c, r, d, elapsed, *, wall=None):
    r.semantic_uptime = 1000.+elapsed
    r.now = 1700000000.+elapsed if wall is None else wall
    c.run(d['diagnostic_observe'], r.BAR, max_steps=30000000)


def journal(r):
    path = r.disk_root/'ApplicationSupport'/'FanqieAdBlockDiagnostics'/'recent.plist'
    envelope = plistlib.loads(path.read_bytes())
    require(isinstance(envelope, list) and len(envelope) == 1 and isinstance(envelope[0], bytes),
            'Actual store is the retained one-NSData binary plist format')
    return json.loads(envelope[0])


def flush(c, r):
    r.flush_main(c)
    r.drain_operations(c)


def queue_export(c, r, d):
    """Enqueue the public logger command; the real ARM64 exporter writes JSON."""
    receiver_class = r._class('DiagnosticVersionAuditReceiver', 'UIViewController')
    r._add(receiver_class, 'fqab_156_presentDiagnostics:',
           c.slide+d['ui_present'], 'v24@0:8@16')
    target = r.obj('DiagnosticVersionAuditReceiver', 'export_receiver')
    command = r.dict_pointer({'exportTarget': target, 'timestamp': r.box(r.now)})
    c.run(d['diagnostic_enqueue'], command)
    return target


def exported_payload(r, target):
    jobs = [job for job in r.main_jobs if job[0] == target]
    require(len(jobs) == 1, 'Actual export schedules exactly one completion')
    result = r.objects[jobs[0][2]].state['items']
    require('url' in result and 'error' not in result, 'Actual export produces a file URL')
    path = Path(r.string_value(result['url']))
    payload = json.loads(path.read_bytes())
    require(payload['recordCount'] == len(payload['entries']),
            'Actual exported JSON reports its complete entry count')
    return payload


def emitted_versions(data):
    c, r, d = make(data)
    observe(c, r, d, 0.)
    flush(c, r)
    records = journal(r)
    require(len(records) == 1 and records[0]['event'] == 'bottom_bar_state_changed',
            'Version check uses an actual ARM64-generated snapshot, not a supplied version field')
    target = queue_export(c, r, d)
    r.drain_operations(c)
    exported = exported_payload(r, target)
    require(exported['entries'] == records,
            'Export preserves the real journal record byte values')
    return {'event_version': records[0]['pluginVersion'],
            'export_version': exported['pluginVersion'],
            'instructions': c.steps,
            'real_export_json_written': True}


def version_regression(candidate, baseline158):
    require(hashlib.sha256(baseline158).hexdigest() == BASELINE158_SHA,
            'Export-version negative control is the exact user-supplied 1.5.8')
    old = emitted_versions(baseline158)
    new = emitted_versions(candidate)
    require(old['event_version'] == '1.5.8' and old['export_version'] == '1.5.7',
            'Old actual instructions reproduce the mixed runtime/export versions in the supplied log')
    require(old['event_version'] != old['export_version'],
            'The old 1.5.8 binary must fail event/export version consistency')
    require(new['event_version'] == new['export_version'] == '1.6.0',
            'Both actual new snapshot and export metadata identify 1.6.0')
    return {'passed': True, 'old_1_5_8': old, 'current_candidate': new,
            'old_158_sha256': hashlib.sha256(baseline158).hexdigest(),
            'old_consistency_failed': True, 'new_consistency_passed': True}


def upgrade_history_and_delayed_export(candidate, baseline157, baseline158):
    """Separate logger processes share only their real retained file bytes."""
    c157, r157, d157 = make(baseline157)
    observe(c157, r157, d157, 0.)
    flush(c157, r157)
    oldest = journal(r157)
    require(len(oldest) == 1 and oldest[0]['pluginVersion'] == '1.5.7',
            'The first history record is emitted by the actual 1.5.7 binary')

    c158, r158, d158 = make(baseline158, disk_root=r157.disk_root)
    observe(c158, r158, d158, 1800.)
    flush(c158, r158)
    middle = journal(r158)
    require(middle[:1] == oldest and
            [row['pluginVersion'] for row in middle] == ['1.5.7', '1.5.8'],
            'Restart into 1.5.8 loads the persisted 1.5.7 record without relabeling it')

    baseline159 = (ROOT / 'dist/1.5.9/FanqieAdBlock-1.5.9.dylib').read_bytes()
    require(hashlib.sha256(baseline159).hexdigest() == BASELINE159_SHA,
            'The upgrade predecessor is the exact user-tested 1.5.9')
    c159, r159, d159 = make(baseline159, disk_root=r157.disk_root)
    observe(c159, r159, d159, 2700.)
    flush(c159, r159)
    previous = journal(r159)
    require(previous[:2] == middle and
            [row['pluginVersion'] for row in previous] == ['1.5.7', '1.5.8', '1.5.9'],
            'Actual 1.5.9 retains historical versions before this upgrade')

    c, r, d = make(candidate, slide=0x180000000, disk_root=r157.disk_root)
    observe(c, r, d, 3600.)
    flush(c, r)
    before = journal(r)
    require(before[:3] == previous and
            [row['pluginVersion'] for row in before] == ['1.5.7', '1.5.8', '1.5.9', '1.6.0'],
            'Restart into 1.6.0 preserves every old event version and adds its own version')
    request_time = r.now
    target = queue_export(c, r, d)
    r.now += 1200.
    r.drain_operations(c)
    exported = exported_payload(r, target)
    require(exported['windowStart'] == request_time-3600. and
            exported['windowEnd'] == request_time,
            'A delayed worker uses the fixed export request window, not its later wall clock')
    require(exported['entries'] == before and journal(r) == before,
            'The inclusive one-hour boundary and all retained history survive the delayed export')
    require(exported['pluginVersion'] == '1.6.0' and exported['storageError'] == 'none',
            'Current export metadata does not overwrite old event provenance or claim a storage error')
    c.run(d['diagnostic_maintenance'])
    r.drain_operations(c)
    require(journal(r) == before[1:],
            'A later maintenance command prunes only the now-expired 1.5.7 event')
    return {'passed': True, 'independent_logger_processes': 4,
            'historical_versions_preserved': ['1.5.7', '1.5.8', '1.5.9'],
            'current_event_and_export_version': '1.6.0',
            'worker_delay_seconds': 1200, 'inclusive_boundary_preserved': True,
            'exported_record_count': exported['recordCount'],
            'post_maintenance_versions': [row['pluginVersion'] for row in journal(r)],
            'instructions': c157.steps+c158.steps+c159.steps+c.steps}


def equivalence_case(data, mutation, slide=0):
    c, r, d = make(data, slide)
    observe(c, r, d, 0.)
    pointers = []
    for i in range(1, 9):
        if mutation in ('bar_color', 'all'):
            value = r.fresh_color((0., 0., 0., 0.))
            r.objects[r.BAR].state['backgroundColor'] = value
            pointers.append(value)
        if mutation in ('parent_color', 'all'):
            value = r.fresh_color((1., 1., 1., 1.))
            r.objects[r.ROOT].state['backgroundColor'] = value
            pointers.append(value)
        if mutation in ('effect', 'all'):
            value = r.obj('UIGlassEffect', 'fresh_semantically_equal_effect',
                          style=1, tintColor=0, interactive=True)
            r.objects[r.PROXY].state['effect'] = value
            pointers.append(value)
        observe(c, r, d, float(i))
    flush(c, r)
    records = journal(r)
    require(len(set(pointers)) == len(pointers), 'Each replacement really has a different object identity')
    require(all(record['data'] == records[0]['data'] for record in records),
            'Every emitted full snapshot has identical semantic JSON data')
    require(c.sp == 0x70000000, 'Observer leaves stack balanced')
    return {'snapshots': len(records), 'observer_calls': 9,
            'replacement_objects': len(pointers), 'instructions': c.steps,
            'native_boundary_calls': r.calls,
            'color_conversions': r.semantic_color_reads,
            'all_snapshot_data_identical': True}


def assign_managed_scroll(r, d):
    row = r.obj('NSArray', 'owned_scroll_row', items=[r.SCROLL, r.EDGE, r.box(0)])
    rows = r.obj('NSArray', 'owned_scroll_table', items=[row])
    r.associations[(r.BAR, r.slide+d['edge_key'])] = rows


def semantic_changes(data):
    c, r, d = make(data)
    observe(c, r, d, 0.)
    r.objects[r.BAR].state['backgroundColor'] = r.fresh_color((.2, .3, .4, .9))
    observe(c, r, d, 1.)
    effect = r.objects[r.PROXY].state['effect']
    r.objects[effect].state['interactive'] = False
    observe(c, r, d, 2.)
    r.objects[effect].state['tintColor'] = r.fresh_color((.1, .2, .3, .4))
    observe(c, r, d, 3.)
    r.objects[effect].state['tintColor'] = r.fresh_color((.1, .2, .3, .4))
    observe(c, r, d, 4.)
    require(len(r.semantic_snapshot_calls) == 4, 'Equal new tint is deduplicated, actual public values are observed')
    r.objects[r.PROXY].state['effect'] = r.obj('UIVisualEffect', 'placeholder')
    observe(c, r, d, 5.)
    require(len(r.semantic_snapshot_calls) == 5, 'Effect class change is observed')
    # A fresh dynamic provider has the same resolved value until its view's
    # actual trait environment changes; provider identity is never recorded.
    dynamic = {1: (.9, .9, .9, 1.), 2: (.1, .1, .1, 1.)}
    r.objects[r.BAR].state['backgroundColor'] = r.fresh_color(dynamic=dynamic)
    observe(c, r, d, 6.)
    r.objects[r.BAR].state['backgroundColor'] = r.fresh_color(dynamic=dynamic)
    observe(c, r, d, 7.)
    require(len(r.semantic_snapshot_calls) == 6, 'Equivalent resolved dynamic provider is deduplicated')
    r.objects[r.BAR].state['userInterfaceStyle'] = 2
    observe(c, r, d, 8.)
    require(len(r.semantic_snapshot_calls) == 7, 'Changed view traits resolve to changed color semantics')
    flush(c, r)
    records = journal(r)
    require(len(records) == 7, 'Full actual snapshots pass through queue and journal')
    return {'passed': True, 'real_changes_recorded': 7, 'fresh_equal_tint_and_provider_deduplicated': True}


def throttling(data):
    c, r, d = make(data)
    assign_managed_scroll(r, d)
    observe(c, r, d, 0.)
    for i in range(1, 121):
        r.objects[r.SCROLL].state['bounds'] = (0., i*256., 390., 844.)
        observe(c, r, d, i/120.)
    times = [row['uptime'] for row in r.semantic_snapshot_calls]
    require(times == [1000., 1000.5, 1001.], '120Hz scroll produces at most two automatic snapshots per second')
    require(r.semantic_color_resolves == 6, 'Color conversion is also sampled, not repeated 120 times per second')
    r.objects[r.SCROLL].state['bounds'] = (0., 40000., 390., 844.)
    observe(c, r, d, 1.25)
    require(len(r.semantic_snapshot_calls) == 3, 'Intermediate scroll change is coalesced')
    observe(c, r, d, 1.5)
    require(len(r.semantic_snapshot_calls) == 4, 'Later monitor observation captures the final unsaved state')
    flush(c, r)
    records = journal(r)
    require(records[-1]['data']['managedScrolls'][0]['bounds'][1] == 40000.,
            'Final persisted snapshot contains the latest actual scroll bounds')
    before = len(r.semantic_snapshot_calls)
    for i in range(61):
        observe(c, r, d, 2.+i/120.)
    require(len(r.semantic_snapshot_calls) == before, 'Advancing time alone never manufactures a state-change snapshot')
    return {'passed': True, 'callbacks_at_120hz': 121, 'snapshots_in_first_second': 3,
            'minimum_noncritical_interval_seconds': .5, 'latest_pending_scroll_captured': True,
            'unchanged_callbacks_remain_deduplicated': True}


def urgent_changes(data):
    c, r, d = make(data)
    observe(c, r, d, 0.)
    second = r.obj('NSObject', 'second_selected_item')
    items = r.objects[r.objects[r.BAR].state['items']].state['items']
    items.append(second)
    r.objects[r.BAR].state['selectedItem'] = second
    observe(c, r, d, .01)
    r.objects[r.PROXY].state['hidden'] = True
    observe(c, r, d, .02)
    r.objects[r.PROXY].state['hidden'] = False
    observe(c, r, d, .03)
    r.associations.pop((r.BAR, r.slide+0xeb84))
    observe(c, r, d, .04)
    r.associations[(r.BAR, r.slide+0xeb84)] = r.PROXY
    observe(c, r, d, .05)
    r.objects[r.PROXY].state['alpha'] = 0.
    observe(c, r, d, .06)
    r.objects[r.PROXY].state['alpha'] = 1.
    observe(c, r, d, .07)
    r.reparent(r.ROOT, 0)
    observe(c, r, d, .08)
    require(len(r.semantic_snapshot_calls) == 9, 'All eight rapid selection/visibility/enable/lifecycle changes bypass throttle')
    flush(c, r)
    records = journal(r)
    require(records[1]['data']['selectedIndex'] == 1, 'Selection event includes the newly selected tab')
    require(records[4]['data']['glassProxy'] is None, 'Disabled proxy is recorded immediately')
    require(records[5]['data']['glassProxy']['viewId'] == r.PROXY, 'Re-enabled proxy is recorded immediately')
    return {'passed': True, 'rapid_critical_transitions_recorded': 8,
            'interval_seconds': .01, 'selected_index_and_disabled_state_verified': True}


def clock_and_guards(data):
    c, r, d = make(data, slide=0x110000000)
    observe(c, r, d, 0.)
    r.objects[r.BAR].state['backgroundColor'] = r.fresh_color((1., 0., 0., 1.))
    observe(c, r, d, .1, wall=1800000000.)
    observe(c, r, d, .2, wall=1600000000.)
    require(len(r.semantic_snapshot_calls) == 1, 'Wall-clock jumps do not bypass monotonic throttle')
    observe(c, r, d, .5)
    require(len(r.semantic_snapshot_calls) == 2, 'Real color change is sampled at monotonic deadline')
    before = r.semantic_view_reads
    r.thread = 'worker'
    c.run(d['diagnostic_observe'], r.BAR)
    r.thread = 'main'
    require(r.semantic_view_reads == before, 'Off-main observer returns before every UIKit read')
    r.semantic_reenter = lambda machine: machine.run(d['diagnostic_observe'], r.BAR)
    r.objects[r.BAR].state['backgroundColor'] = r.fresh_color((0., 1., 0., 1.))
    observe(c, r, d, 1.)
    require(len(r.semantic_snapshot_calls) == 3, 'Synchronous reentry cannot duplicate or recursively capture state')
    require(not r.associations.get((r.BAR, r.slide+d['observe_busy_key'])), 'Nonretaining busy marker is cleared')
    r.objects[r.BAR].state['backgroundColor'] = r.fresh_color((0., 0., 1., 1.))
    observe(c, r, d, -1.)
    require(len(r.semantic_snapshot_calls) == 4, 'Unexpected uptime rollback does not suppress all future captures')
    require(c.sp == 0x70000000, 'Nested observation and ASLR preserve stack/ABI')
    return {'passed': True, 'ASLR_slide': hex(c.slide), 'wall_clock_independent': True,
            'off_main_guard': True, 'synchronous_reentry_guard': True, 'rollback_recovery': True}


def color_canonicalization(data):
    c, r, d = make(data)
    # Execute the emitted helper directly; this also audits writable CGFloat
    # pointer ABI, exact state encodings and the nonfinite/unsupported paths.
    destination = 0x6fff0000
    traits = r.obj('UITraitCollection', 'fixed_traits', contrast=0, interfaceStyle=1)

    def convert(color):
        c.run(d['semantic_color'], color, traits, destination)
        return c.read(destination, 40).to_bytes(40, 'little')

    rgb = convert(r.fresh_color((.4, .4, .4, 1.)))
    gray = convert(r.fresh_color((.4, .4, .4, 1.), conversion='gray'))
    require(rgb == gray, 'Compatible RGB and grayscale representations normalize to identical RGBA')
    positive_zero = convert(r.fresh_color((0., .3, .4, 1.)))
    negative_zero = convert(r.fresh_color((-0., .3, .4, 1.)))
    require(positive_zero == negative_zero, 'Signed zero does not manufacture a color change')
    clear_a = convert(r.fresh_color((.9, .8, .7, 0.)))
    clear_b = convert(r.fresh_color((0., 0., 0., -0.)))
    require(clear_a == clear_b, 'Fully transparent colors ignore invisible RGB components')
    extended = struct.unpack('<Q4d', convert(r.fresh_color((1.2, -.1, .4, .8))))
    require(extended == (1, 1.2, -.1, .4, .8), 'Extended sRGB values are preserved, not clamped')
    for value in (float('nan'), float('inf'), -float('inf')):
        invalid = struct.unpack('<Q4d', convert(r.fresh_color((value, 0., 0., 1.))))
        require(invalid == (3, 0., 0., 0., 0.), 'Invalid components use stable explicit marker')
    unsupported = struct.unpack('<Q4d', convert(r.fresh_color(conversion='unsupported')))
    absent = struct.unpack('<Q4d', convert(0))
    require(unsupported == (2, 0., 0., 0., 0.) and absent == (0, 0., 0., 0., 0.),
            'Unsupported color is explicitly distinct from absent color')
    return {'passed': True, 'gray_rgb_equivalence': True, 'signed_zero_normalized': True,
            'transparent_rgb_normalized': True, 'extended_rgb_preserved': True,
            'nonfinite_and_unsupported_explicit': True}


def explicit_and_retention(data):
    c, r, d = make(data)
    observe(c, r, d, 0.)
    c.run(d['diagnostic_heartbeat'])
    export_name = data.index(b'export_snapshot\0')
    c.run(d['diagnostic_snapshot_all'], c.slide+export_name)
    require([row['event'] for row in r.semantic_snapshot_calls] == [
        'bottom_bar_state_changed', 'periodic_snapshot', 'export_snapshot'],
        'Explicit periodic/export snapshots run without automatic throttle')
    flush(c, r)
    snapshots = journal(r)
    require(len(snapshots) == 3, 'All three actual snapshots are persisted')
    require(all(row['pluginVersion'] == '1.6.0' for row in snapshots),
            'Automatic, periodic, and explicit export snapshots all report the current version')
    # Run actual hour-retention queue logic with boundary and older records,
    # then an actual export marker. This is not a replacement Python filter.
    r.now += 3600.
    c.run(d['diagnostic_enqueue'], r.record(r.now-3600., 'exact_hour_boundary'))
    c.run(d['diagnostic_enqueue'], r.record(r.now-3600.001, 'expired_marker'))
    c.run(d['diagnostic_enqueue'], r.record(r.now, 'fresh_marker'))
    receiver_class = r._class('DiagnosticExportAuditReceiver', 'UIViewController')
    r._add(receiver_class, 'fqab_156_presentDiagnostics:',
           c.slide+d['ui_present'], 'v24@0:8@16')
    target = r.obj('DiagnosticExportAuditReceiver', 'export_receiver')
    command = r.dict_pointer({'exportTarget': target, 'timestamp': r.box(r.now)})
    c.run(d['diagnostic_enqueue'], command)
    r.drain_operations(c)
    records = journal(r)
    names = [row['event'] for row in records]
    require('exact_hour_boundary' in names and 'fresh_marker' in names and 'expired_marker' not in names,
            'One-hour retention keeps the inclusive boundary and prunes only older records')
    jobs = [job for job in r.main_jobs if job[0] == target]
    require(len(jobs) == 1, 'Actual export schedules one completion')
    result = r.objects[jobs[0][2]].state['items']
    require('url' in result and 'error' not in result, 'Actual export produces a file URL')
    export_path = Path(r.string_value(result['url']))
    exported = json.loads(export_path.read_bytes())
    require(exported['pluginVersion'] == '1.6.0',
            'One-hour export envelope identifies the current plugin')
    require(exported['recordCount'] == len(exported['entries']) and
            any(row['event'] == 'exact_hour_boundary' for row in exported['entries']),
            'Export JSON contains complete retained records and accurate count')
    r.now += .001
    c.run(d['diagnostic_maintenance'])
    r.drain_operations(c)
    names = [row['event'] for row in journal(r)]
    require(names == ['fresh_marker'], 'Existing retention advances normally after the inclusive boundary')
    return {'passed': True, 'periodic_unthrottled': True, 'export_snapshot_unthrottled': True,
            'real_export_json_written': True, 'inclusive_one_hour_retention': True,
            'journal_format_unchanged': True}


def run_all(candidate, baseline, baseline158):
    require(hashlib.sha256(baseline).hexdigest() == BASELINE_SHA,
            'Negative control is the exact uploaded 1.5.7, not a simulated old algorithm')
    pairs = {}
    for mutation in ('bar_color', 'parent_color', 'effect', 'all'):
        old = equivalence_case(baseline, mutation)
        new = equivalence_case(candidate, mutation)
        require(old['snapshots'] == 9 and new['snapshots'] == 1,
                mutation+': old object-identity false positives reproduced and removed')
        pairs[mutation] = {'old_1_5_7': old, 'current_candidate': new}
    return {
        'passed': True,
        'scope': 'Actual supplied ARM64 control flow with public API boundary models; not iOS latency or pixels',
        'candidate_sha256': hashlib.sha256(candidate).hexdigest(),
        'baseline_sha256': hashlib.sha256(baseline).hexdigest(),
        'negative_controls': pairs,
        'runtime_export_version_regression': version_regression(candidate, baseline158),
        'cross_restart_history_and_delayed_export': upgrade_history_and_delayed_export(
            candidate, baseline, baseline158),
        'semantic_changes': semantic_changes(candidate),
        'throttling': throttling(candidate),
        'urgent_changes': urgent_changes(candidate),
        'clock_and_guards': clock_and_guards(candidate),
        'color_canonicalization': color_canonicalization(candidate),
        'explicit_and_retention': explicit_and_retention(candidate),
        'limits': [
            'Public effect class, tint and interactivity are observed; private same-class effect internals are not read.',
            'Nonconvertible/pattern colors have a stable unknown marker; their descriptions remain in periodic/export snapshots.',
            'Coalesced final changes are captured by a subsequent observer/monitor callback, not a newly scheduled timer.',
            'Critical selection/visibility/attachment transitions intentionally bypass the 0.5-second noncritical cap.',
            'No device timing, Core Animation compositing, renderer or dylib injection was executed.',
        ],
    }


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--baseline', type=Path, default=ROOT/'baseline'/'FanqieAdBlock-1.5.7.dylib')
    parser.add_argument('--baseline158', type=Path,
                        default=ROOT/'baseline'/'FanqieAdBlock-1.5.8.dylib',
                        help='Pinned 1.5.8 for actual runtime/export-version negative control')
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    report = run_all(args.candidate.read_bytes(), args.baseline.read_bytes(),
                     args.baseline158.read_bytes())
    encoded = json.dumps(report, ensure_ascii=False, indent=2)+'\n'
    if args.output:
        args.output.write_text(encoded)
    print(encoded)
