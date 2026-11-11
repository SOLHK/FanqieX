"""Run the shipped ARM64 top-bar hooks against UIKit geometry boundaries."""

import argparse
import json
import struct
from pathlib import Path

from arm64 import CPU, require
from test_feed_viewport import labels_for
from test_header173 import call, drawn_rect
from test_home_glass165 import HOME, LABELS, Runtime as HeaderRuntime
from top_chrome_runtime import TopChromeRuntime


SHELF = 'SSBookShelf525ViewController'
SHELF_LIST = 'SSBookShelfSubViewController'
SHELF_FUNCTION_CELL = 'SSBookShelfFunctionCell'
SHELF_SUBHEADER = 'SS525BookShelfSubHeaderView'
REFRESH_HEADER = 'SSNewRefreshHeader'
FLAT_STORE = 'SSBookStoreTabViewController'
SHELF_SCROLL = 'scrollViewDidScroll:'
DOUBLE_ROW = 'SSBookStoreDoubleRowViewController'
DOUBLE_ROW_SCROLL = 'storeTabScrollViewDidScroll:'
DOUBLE_ROW_LAYOUT = 'viewWillLayoutSubviews'
UPDATE_INSET = 'updateCollectionViewInsets'
FLOATING_LAYOUT = 'updateFullGenreFloatingViewWithScrollView:'
FLOW_LAYOUT = 'configFlowLayout'
PROPERTIES = (
    'contentView', 'simpleHeader', 'currentTabVC', 'containerView', 'collectionView', 'collectionViewLayout',
    'currentSelectedListViewController', 'doubleRowNestContainerScrollView', 'listView',
    'nestedView', 'viewIfLoaded',
    'delegate', 'backgroundView', 'headerBgImgView', 'headerView', 'tabSelectView',
    'headerBackgroundView', 'fullGenreFloatingContainerView', 'functionCell',
    'layoutContainerView', 'filterView', 'tabContainer', 'simpleTabView', 'view',
    'containerScrollView', 'refreshHeader', 'viewModel', 'uiConfigParams',
)


class Runtime(TopChromeRuntime, HeaderRuntime):
    def __init__(self, data):
        super().__init__(data)
        self.dispatch_methods = True
        for cls in (SHELF, SHELF_LIST, DOUBLE_ROW):
            self._class(cls, 'UIViewController')
        for cls in (SHELF_FUNCTION_CELL, SHELF_SUBHEADER):
            self._class(cls, 'UIView')
        self._class('UICollectionView', 'UIScrollView')
        self._class('UICollectionViewFlowLayout', 'NSObject')
        self._class('SSNestedContainerScrollView', 'UIScrollView')
        self._class('SSBookStoreNestedTabView', 'UIView')
        self._class(FLAT_STORE, 'UIViewController')
        self._class('FQRJXCategoryListContainerView', 'UIView')
        self._class(REFRESH_HEADER, 'UIView')
        self.original_update_inset = 0x3304e200
        self.original_float_layout = 0x3304e300
        self.original_double_row_scroll = 0x3304e400
        self.original_double_row_layout = 0x3304e500
        self.hosts[0x3304e100] = (SHELF, 'viewLayout')
        self._add(self.classes[SHELF], 'viewLayout', 0x3304e100, 'v16@0:8')
        self._add(self.classes[SHELF_LIST], UPDATE_INSET, self.original_update_inset, 'v16@0:8')
        self._add(self.classes[SHELF_LIST], FLOATING_LAYOUT, self.original_float_layout, 'v24@0:8@16')
        self._add(self.classes[DOUBLE_ROW], DOUBLE_ROW_SCROLL, self.original_double_row_scroll, 'v24@0:8@16')
        self._add(self.classes[DOUBLE_ROW], DOUBLE_ROW_LAYOUT, self.original_double_row_layout, 'v16@0:8')
        self.original_shelf_scroll = 0x3304e600
        self.original_refresh_state = 0x3304e610
        self.original_refresh_visibility = 0x3304e620
        self.original_flat_store_scroll = 0x3304e630
        self.original_flow_layout = 0x3304e640
        for cls, selector, address, encoding in (
                (SHELF_LIST, FLOW_LAYOUT, self.original_flow_layout, 'v16@0:8'),
                (SHELF_LIST, SHELF_SCROLL, self.original_shelf_scroll, 'v24@0:8@16'),
                (FLAT_STORE, 'scrollViewDidScroll:', self.original_flat_store_scroll, 'v24@0:8@16'),
                (REFRESH_HEADER, 'setState:', self.original_refresh_state, 'v24@0:8q16'),
                (REFRESH_HEADER, 'setAnimationHidden:', self.original_refresh_visibility, 'v20@0:8B16'),
                (REFRESH_HEADER, 'placeSubviews', self.LAYOUT_IMP, 'v16@0:8'),
                (REFRESH_HEADER, 'animationView', self.LAYOUT_IMP, '@16@0:8'),
                (REFRESH_HEADER, 'isRefreshing', self.LAYOUT_IMP, 'B16@0:8')):
            self._add(self.classes[cls], selector, address, encoding)

    def handle(self, cpu, pc):
        if pc == self.original_flow_layout:
            tab = self.objects[cpu.x[0]].state
            layout = self.objects[tab['collectionViewLayout']].state
            # Inspected host configFlowLayout explicitly enables UIKit pinning,
            # independently of the fullGenreFloatingContainerView path below.
            layout['sectionHeadersPinToVisibleBounds'] = True
            layout['host_configurations'] = layout.get('host_configurations', 0) + 1
            return self.finish(cpu)
        if pc == self.original_shelf_scroll:
            self.event('shelf_scroll', cpu.x[0])
            return self.finish(cpu)
        if pc == self.original_refresh_state:
            header = self.objects[cpu.x[0]].state
            previous = header['refresh_state']
            header['refresh_state'] = cpu.x[2]
            scroll = header.get('nativeRefreshScroll')
            if scroll and previous != 3 and cpu.x[2] == 3:
                state = self.objects[scroll].state
                top, *inset = state['contentInset']
                # The host holds the pull by adding the header's height to
                # its current inset.
                top += header['frame'][3]
                state.update(contentInset=(top, *inset), contentOffset=(0, -top),
                             bounds=(0, -top, *state['bounds'][2:]))
            return self.finish(cpu)
        if pc == self.original_refresh_visibility:
            header = self.objects[cpu.x[0]].state
            self.objects[header['animationView']].state['hidden'] = bool(cpu.x[2])
            return self.finish(cpu)
        if pc in (self.original_double_row_scroll, self.original_flat_store_scroll):
            return self.finish(cpu)
        if pc == self.original_double_row_layout:
            tab = self.objects[cpu.x[0]].state
            nested = self.objects[tab['nestedView']].state
            nested['frame'] = tab['stockNestedFrame']
            nested['bounds'] = (0, 0, *nested['frame'][2:])
            return self.finish(cpu)
        if pc == self.original_update_inset:
            tab = self.objects[cpu.x[0]].state
            self.objects[tab['collectionView']].state['contentInset'] = tab['stockInset']
            return self.finish(cpu)
        if pc == self.original_float_layout:
            tab = self.objects[cpu.x[0]].state
            scroll = tab['collectionView']
            holder = tab['fullGenreFloatingContainerView']
            cell = self.objects[tab['functionCell']].state
            list_state = self.objects[scroll].state
            # Stock reparents the same layout container after the inline row
            # crosses the leading edge, and takes its inline cleanup on nil.
            should_pin = cpu.x[2] == scroll and (
                list_state['contentOffset'][1] + list_state['contentInset'][0] > cell['frame'][1])
            parent = holder if should_pin else cell['contentView']
            row = cell['layoutContainerView']
            if self.objects[row].state['superview'] != parent:
                self.reparent(row, parent)
            self.objects[holder].state.update(frame=(0, 0, 440, 36), hidden=not should_pin)
            self.event('shelf_floating_layout', cpu.x[0], scroll=cpu.x[2])
            return self.finish(cpu)
        if pc-self.slide == 0xa5d4 and cpu.x[0] in self.objects:
            state = self.objects[cpu.x[0]].state
            name = self.selector_names.get(cpu.x[1])
            if self.is_kind(cpu.x[0], self.classes['UICollectionViewFlowLayout']):
                if name == 'sectionHeadersPinToVisibleBounds':
                    return self.finish(cpu, state[name])
                if name == 'setSectionHeadersPinToVisibleBounds:':
                    state['sectionHeadersPinToVisibleBounds'] = bool(cpu.x[2])
                    return self.finish(cpu)
                if name == 'invalidateLayout':
                    state['invalidations'] += 1
                    return self.finish(cpu)
            if name in PROPERTIES and name in state:
                return self.finish(cpu, state[name])
            if name in ('mj_header', 'animationView', 'isDragging') and name in state:
                return self.finish(cpu, state[name])
            if name == 'isRefreshing' and 'refresh_state' in state:
                return self.finish(cpu, state['refresh_state'] in (3, 4))
            if name == 'colorWithAlphaComponent:' and self.is_kind(cpu.x[0], self.classes['UIColor']):
                color = self.obj('UIColor', 'adaptive top chrome tint', source=cpu.x[0], alpha=cpu.fp(0))
                return self.finish(cpu, color)
            if name == 'setAlpha:':
                state['alpha'] = cpu.fp(0)
                return self.finish(cpu)
            if name == 'setContentOffset:' and 'pinnedInnerScroll' in state:
                inner = self.objects[state['pinnedInnerScroll']].state
                y = cpu.fp(1)
                inner['frame'] = (0, y, *inner['frame'][2:])
                inner['bounds'] = (0, y - 370, *inner['bounds'][2:])
        return super().handle(cpu, pc)


def surfaces(r, owner):
    return [child for child in r.objects[owner].state['subviews']
            if r.is_kind(child, r.classes['UIVisualEffectView']) and
            r.is_kind(r.objects[child].state['effect'], r.classes['UIBlurEffect'])]


def exercise_refresh(c, r, tab, scroll, nested_view=None):
    scroll_state = r.objects[scroll].state
    original_inset, original_offset = scroll_state['contentInset'], scroll_state['contentOffset']
    header_frame = (0, -54, 440, 54)
    header = r.view(REFRESH_HEADER, 'native refresh header', header_frame, scroll, refresh_state=1)
    animation = r.view('UIView', 'native three-dot artwork', (199, 8, 42, 36), header)
    r.objects[header].state['animationView'] = animation
    rest = -original_inset[0]
    scroll_state.update(mj_header=header, delegate=nested_view or tab, isDragging=False,
                        contentOffset=(0,rest), bounds=(0,rest,*scroll_state['bounds'][2:]))
    selector = 'scrollViewDidScroll:'
    if nested_view:
        r.objects[nested_view].state.update(containerScrollView=scroll, refreshHeader=header)
        selector = DOUBLE_ROW_SCROLL
        require(drawn_rect(r, animation)[1] == 98 and rest == -188,
                'The device-matched nested rest position exposes the old idle spinner under the top bar')
    call(c, r, header, 'placeSubviews')
    require(r.objects[animation].state['hidden'] and not r.objects[header].state['hidden'],
            'The idle artwork alone is hidden in the expanded viewport')

    scroll_state.update(contentOffset=(0, rest-30), isDragging=True)
    call(c, r, tab, selector, scroll)
    require(not r.objects[animation].state['hidden'], 'A real pull reveals the original artwork')
    call(c, r, header, 'setState:', 3)
    scroll_state.update(contentOffset=(0, rest), isDragging=False)
    call(c, r, tab, selector, scroll)
    require(not r.objects[animation].state['hidden'], 'Active refreshing stays visible when dragging ends')
    call(c, r, header, 'setState:', 1)
    require(r.objects[animation].state['hidden'],
            'Stock completion hides stale artwork even without another scroll event')

    call(c, r, header, 'setAnimationHidden:', 1)
    scroll_state.update(contentOffset=(0, rest-30), isDragging=True)
    call(c, r, tab, selector, scroll)
    require(r.objects[animation].state['hidden'], 'Host-requested visibility still wins on a new pull')
    call(c, r, header, 'setAnimationHidden:', 0)
    require(not r.objects[animation].state['hidden'], 'The host can show artwork normally on a subsequent pull')
    scroll_state.update(contentOffset=(0, rest), isDragging=False)
    replacement = r.view('UIView', 'reloaded theme artwork', (199, 8, 42, 36), header)
    r.reparent(animation, 0)
    r.objects[header].state['animationView'] = replacement
    call(c, r, header, 'placeSubviews')
    require(r.objects[replacement].state['hidden'], 'Layout suppresses replacement idle artwork after a theme reload')
    require(r.objects[header].state['frame'] == header_frame and scroll_state['contentInset'] == original_inset,
            'Refresh visibility leaves the native header position and trigger insets intact')
    scroll_state.update(contentOffset=original_offset, bounds=(0,original_offset[1],*scroll_state['bounds'][2:]))
    return replacement


def exercise_nested_refresh_geometry(c, r, tab, scroll, animation):
    state = r.objects[scroll].state
    original_offset = state['contentOffset']
    idle_inset = state['contentInset']
    idle_offset = -idle_inset[0]
    header = state['mj_header']
    r.objects[header].state['nativeRefreshScroll'] = scroll
    ranking = r.view('UIView', 'first bookstore ranking card', (12, 4, 416, 248), scroll)
    state.update(contentOffset=(0, idle_offset), bounds=(0, idle_offset, *state['bounds'][2:]))
    ranking_top = drawn_rect(r, ranking)[1]
    require(ranking_top == 148 and idle_offset == -188,
            'The fixture puts the first result just below the device-matched toolbar')
    for _ in range(2):
        state.update(contentOffset=(0, idle_offset - 60), bounds=(0, idle_offset - 60, *state['bounds'][2:]),
                     isDragging=True)
        call(c, r, tab, DOUBLE_ROW_SCROLL, scroll)
        require(state['contentOffset'] == (0, idle_offset - 60), 'Layout leaves a live pull in place')
        state['isDragging'] = False
        call(c, r, header, 'setState:', 3)
        call(c, r, tab, DOUBLE_ROW_LAYOUT)
        require(state['contentInset'] == (242, *idle_inset[1:]) and state['contentOffset'] == (0, -242),
                'Bookstore layout during refresh does not add the toolbar height to the native hold inset')
        require(not r.objects[animation].state['hidden'], 'The native refreshing artwork remains visible')
        call(c, r, header, 'setState:', 1)
        call(c, r, tab, DOUBLE_ROW_LAYOUT)
        require(state['contentInset'] == (242, *idle_inset[1:]) and state['contentOffset'] == (0, -242),
                'An idle layout waits for the native refresh hold to finish restoring its inset')
        # MJRefresh adds insetTDelta to the current top in its completion
        # animation. Applying this to an inflated inset leaves a visible gap.
        top, *inset = state['contentInset']
        top -= r.objects[header].state['frame'][3]
        state.update(contentInset=(top, *inset), contentOffset=(0, -top), bounds=(0, -top, *state['bounds'][2:]))
        call(c, r, tab, DOUBLE_ROW_LAYOUT)
        require(state['contentInset'] == idle_inset and state['contentOffset'] == (0, idle_offset) and
                drawn_rect(r, ranking)[1] == ranking_top,
                'Bookstore returns the ranking card to its original screen position after refresh')
        require(r.objects[animation].state['hidden'], 'The artwork hides at idle without leaving a gap')
    state.update(contentOffset=original_offset, bounds=(*original_offset, *state['bounds'][2:]))


def exercise_shelf_canvas(c, r, owner, tab, scroll, blur, config):
    state = r.objects[scroll].state
    bounds, offset, inset = state['bounds'], state['contentOffset'], state['contentInset']
    rest = -inset[0]
    blur_state = r.objects[blur].state
    content = r.objects[blur_state['contentView']].state
    palette = r.objects[config].state
    shelf_canvas = palette['backgroundColor']
    common_canvas = r.color('systemBackgroundColor')

    def position(y):
        state.update(contentOffset=(0, y), bounds=(0, y, *bounds[2:]))

    def tint():
        color = content['backgroundColor']
        color_state = r.objects[color].state
        return color_state.get('source', color), color_state.get('alpha', 1)

    position(rest)
    call(c, r, owner, 'viewLayout')
    require(tint() == (shelf_canvas, 1), 'At rest the toolbar exactly matches the host shelf canvas')
    position(rest + 8)
    call(c, r, tab, SHELF_SCROLL, scroll)
    require(0.0625 < tint()[1] < 1, 'The shelf canvas fades during the first points of scrolling')
    position(rest + 24)
    owner_state = r.objects[owner].state
    prior_tint = tint()
    owner_state['currentTabVC'] = 0
    call(c, r, tab, SHELF_SCROLL, scroll)
    require(tint() == prior_tint, 'A noncurrent shelf tab cannot repaint the top bar')
    owner_state['currentTabVC'] = tab
    call(c, r, tab, SHELF_SCROLL, scroll)
    require(tint() == (common_canvas, 0.0625), 'Scrolled shelf uses the common lightly tinted blur')
    position(rest)
    call(c, r, tab, SHELF_SCROLL, scroll)
    require(tint() == (shelf_canvas, 1), 'Returning to the top removes the color seam without a relayout')

    palette['backgroundColor'] = r.color('host shelf dark canvas')
    call(c, r, owner, 'viewLayout')
    require(tint() == (palette['backgroundColor'], 1), 'Resting shelf follows the host theme color after relayout')
    header = state['mj_header']
    call(c, r, header, 'setState:', 3)
    require(tint() == (common_canvas, 0.0625), 'The active refresh restores the regular tint on state change')
    call(c, r, header, 'setState:', 1)
    require(tint() == (palette['backgroundColor'], 1), 'The resting color returns immediately after refresh')
    require(surfaces(r, r.objects[owner].state['view']) == [blur] and blur_state['alpha'] == 1 and
            not blur_state['hidden'] and state['contentInset'] == inset and state['contentOffset'] == (0, rest),
            'Only the owned tint changes while the native blur and shelf scroll geometry are retained')
    palette['backgroundColor'] = shelf_canvas
    state.update(contentOffset=offset, bounds=bounds)
    call(c, r, tab, SHELF_SCROLL, scroll)


def exercise_shelf_section_headers(c, r, owner, tab, scroll):
    state = r.objects[scroll].state
    offset, bounds = state['contentOffset'], state['bounds']
    layout = r.objects[tab].state['collectionViewLayout']
    flow = r.objects[layout].state
    preferences = r.objects[r.DEFAULTS].state['values']
    header = r.view('UIView', 'native supplementary filter header', (0, 76, 440, 36), scroll,
                    userInteractionEnabled=True)
    book = r.view('UIView', 'book in the same section', (12, 112, 100, 260), scroll)
    section_end = 470

    def position(y):
        state.update(contentOffset=(0, y), bounds=(0, y, *bounds[2:]))
        # Model UIKit's supplementary header clamp, separately from the host's
        # custom floating-container logic. Pinning ends when its section ends.
        top = min(max(76, y + state['contentInset'][0]), section_end - 36) if (
            flow['sectionHeadersPinToVisibleBounds']) else 76
        r.objects[header].state['frame'] = (0, top, 440, 36)

    require(not flow['sectionHeadersPinToVisibleBounds'] and flow['invalidations'] == 1,
            'The mounted shelf also disables the separate UIKit supplementary-header pinning')
    initial_layout = r.obj('UICollectionViewFlowLayout', 'layout before collection creation',
                           sectionHeadersPinToVisibleBounds=False, invalidations=0)
    initial_tab = r.obj(SHELF_LIST, 'not yet mounted shelf', collectionViewLayout=initial_layout)
    call(c, r, initial_tab, FLOW_LAYOUT)
    require(r.objects[initial_layout].state['host_configurations'] == 1 and
            not r.objects[initial_layout].state['sectionHeadersPinToVisibleBounds'],
            'Initial host layout configuration is handled before its collection view exists')
    rest = -state['contentInset'][0]
    for delta in (0, 24, 140, 260):
        position(rest + delta)
        call(c, r, tab, SHELF_SCROLL, scroll)
        require(r.objects[header].state['frame'] == (0, 76, 440, 36),
                'The supplementary filter stays at its content origin throughout the book section')
    require(drawn_rect(r, header)[3] == 0 and drawn_rect(r, book)[3] > 0,
            'The filter has scrolled out while books in its own section are still visible')
    for _ in range(3):
        call(c, r, owner, 'viewLayout')
    require(flow['invalidations'] == 1, 'Settled layouts do not repeatedly invalidate the shelf')
    call(c, r, tab, FLOW_LAYOUT)
    require(flow['host_configurations'] == 1 and not flow['sectionHeadersPinToVisibleBounds'] and
            flow['invalidations'] == 2, 'A host reconfiguration cannot reinstate section-header pinning')

    replacement = r.obj('UICollectionViewFlowLayout', 'replacement shelf flow layout',
                        sectionHeadersPinToVisibleBounds=True, invalidations=0)
    r.objects[tab].state['collectionViewLayout'] = replacement
    state['collectionViewLayout'] = replacement
    call(c, r, owner, 'viewLayout')
    require(flow['sectionHeadersPinToVisibleBounds'] and
            not r.objects[replacement].state['sectionHeadersPinToVisibleBounds'],
            'Replacing a layout restores the old one and updates only the current shelf layout')
    preferences['FanqieAdBlock.GlassDisabled.1'] = 1
    call(c, r, owner, 'viewLayout')
    require(r.objects[replacement].state['sectionHeadersPinToVisibleBounds'],
            'Disabling glass restores native supplementary-header pinning')

    # An originally unpinned layout must stay unpinned after enable/disable.
    r.objects[replacement].state['sectionHeadersPinToVisibleBounds'] = False
    invalidations = r.objects[replacement].state['invalidations']
    preferences['FanqieAdBlock.GlassDisabled.1'] = 0
    call(c, r, owner, 'viewLayout')
    preferences['FanqieAdBlock.GlassDisabled.1'] = 1
    call(c, r, owner, 'viewLayout')
    require(not r.objects[replacement].state['sectionHeadersPinToVisibleBounds'] and
            r.objects[replacement].state['invalidations'] == invalidations,
            'An originally unpinned layout is never made sticky by teardown')
    preferences['FanqieAdBlock.GlassDisabled.1'] = 0
    r.objects[tab].state['collectionViewLayout'] = layout
    state['collectionViewLayout'] = layout
    call(c, r, owner, 'viewLayout')
    position(rest)
    require(drawn_rect(r, header)[3] == 36 and r.objects[header].state['userInteractionEnabled'],
            'Returning to the top leaves the native filter header visible and interactive')
    state.update(contentOffset=offset, bounds=bounds)


def exercise(data, labels, kind):
    r = Runtime(data)
    r.labels = labels
    words = struct.unpack_from('<64I', data, 0x800)
    c = CPU(data, r, ranges=[(0x800,0x4000), (0x4878,0x48d0), (0x14080,0x800+words[61])])
    c.pointers.update(r.rebase_pointers)
    c.run(labels['LFQH_FQHInstall'], max_steps=1500000)

    shelf, nested, full_flat = kind == 'shelf', kind == 'nested bookstore', kind == 'bookstore in full pager'
    boundary = 106 if shelf else 144
    viewport_frame = (0, boundary, 440, 956-boundary)
    pager_frame = (0,0,440,956) if nested or full_flat else viewport_frame
    root = r.view('UIView', 'page', (0,0,440,956), r.ROOT)
    viewport = r.view('FQRJXCategoryListContainerView', 'pager', pager_frame, root)
    horizontal = r.view('UIScrollView', 'horizontal pager', (0,0,440,pager_frame[3]), viewport, clipsToBounds=True)
    page = r.view('UIView', 'active page', (0,0,440,pager_frame[3]), horizontal)
    content_viewport = viewport
    if nested:
        # Device trace: the pager already begins at y0. The host's nested
        # view starts at y144 and clips the coordinator which begins at -44.
        viewport_frame = (0,144,440,813)
        content_viewport = r.view('SSBookStoreNestedTabView', 'header-inset nested content', viewport_frame,
                                  page, clipsToBounds=True)
    scroll_class = 'SSNestedContainerScrollView' if nested else 'UICollectionView'
    stock_inset = (44 if nested else 6, 3, 32, 5)
    stock_offset = 650 if nested else 72
    scroll_y = -44 if nested else boundary if full_flat else 0
    scroll_height = 857 if nested else 956-boundary
    scroll = r.view(scroll_class, 'vertical feed', (0,scroll_y,440,scroll_height), content_viewport if nested else page,
                    clipsToBounds=True, contentInset=stock_inset, contentOffset=(0,stock_offset))
    scroll_state = r.objects[scroll].state
    scroll_state['bounds'] = (0,stock_offset,440,scroll_height)
    stock_edge_hidden = full_flat
    edge = r.enable_native_top_edge(scroll, hidden=stock_edge_hidden)
    edge_state = r.objects[edge].state
    if full_flat:
        content_viewport = scroll
    cover_parent, cover_y = scroll, 32
    stock_fill = r.color('host top bar')
    artwork = r.view('UIImageView', 'gradient artwork above pager', (0,0,440,boundary), root)
    header = r.view('UIView', 'header controls', (0,0,440,boundary-8), root,
                    backgroundColor=stock_fill, opaque=True)
    tabs = r.view('UIView', 'host tabs', (0,boundary-36,440,36), header)
    tab_strip = r.view('UICollectionView', 'host opaque tab strip', (0,0,440,36), tabs,
                       backgroundColor=stock_fill, opaque=True)
    r.objects[tabs].state['collectionView'] = tab_strip
    tab_state = {'collectionView': scroll, 'view': page, 'viewIfLoaded': page}
    unrelated_layout = r.obj('UICollectionViewFlowLayout', 'unrelated tab-strip layout',
                             sectionHeadersPinToVisibleBounds=True, invalidations=0)
    r.objects[tab_strip].state['collectionViewLayout'] = unrelated_layout
    if shelf:
        shelf_layout = r.obj('UICollectionViewFlowLayout', 'native shelf flow layout',
                             sectionHeadersPinToVisibleBounds=True, invalidations=0)
        tab_state['collectionViewLayout'] = shelf_layout
        scroll_state['collectionViewLayout'] = shelf_layout
    if nested:
        # The unlimited list pins to the coordinator's scroll top.
        inner = r.view('UICollectionView', 'nested feed list', (0,stock_offset,440,857), scroll,
                       clipsToBounds=True, contentInset=(4, 0, 32, 0))
        r.objects[inner].state['bounds'] = (0,stock_offset-370,440,857)
        scroll_state['pinnedInnerScroll'] = inner
        cover_parent, cover_y = inner, 254
        tab_state.update(doubleRowNestContainerScrollView=scroll, collectionView=inner,
                         nestedView=content_viewport, stockNestedFrame=viewport_frame)
    cover = r.view('UIView', 'cover', (12,cover_y,144,180), cover_parent)
    tab = r.obj(SHELF_LIST if shelf else DOUBLE_ROW if nested else FLAT_STORE,
                'active tab', **tab_state)
    if shelf:
        holder = r.view('UIView', 'native pinned filter holder', (0,0,440,36), page,
                        backgroundColor=stock_fill, clipsToBounds=True)
        cell = r.view(SHELF_FUNCTION_CELL, 'shelf function row', (0, 20, 440, 36), scroll)
        inline_parent = r.view('UIView', 'inline function-cell content', (0, 0, 440, 36), cell)
        row = r.view('UIView', 'already pinned native filter controls', (0,0,440,36), holder)
        subheader = r.view(SHELF_SUBHEADER, 'shelf subheader', (0, 0, 440, 36), row)
        filter_button = r.view('UIButton', 'native filter button', (365, 4, 62, 28), subheader,
                               userInteractionEnabled=True, enabled=True)
        r.objects[cell].state.update(contentView=inline_parent, layoutContainerView=row, headerView=subheader)
        config = r.obj('NSObject', 'native shelf theme', backgroundColor=r.color('host shelf light canvas'))
        model = r.obj('NSObject', 'shelf view model', uiConfigParams=config)
        r.objects[tab].state.update(fullGenreFloatingContainerView=holder, functionCell=cell,
                                   stockInset=stock_inset, viewModel=model)
        owner = r.obj(SHELF, 'shelf', view=root, headerView=header, tabSelectView=tabs,
                      containerView=viewport, currentTabVC=tab, headerBgImgView=artwork)
        r.objects[tab].state['delegate'] = owner
        layout = 'viewLayout'
    else:
        owner = r.obj(HOME, 'bookstore', contentView=root, simpleHeader=header, simpleTabView=tabs,
                      containerView=viewport, currentTabVC=0 if nested else tab, searchBgView=0,
                      backgroundView=artwork)
        layout = 'relayout'
    require(drawn_rect(r,cover)[1] == boundary, 'Stock clipping stops the cover at the toolbar edge')
    if nested:
        r.objects[tab].state['delegate'] = owner
        r.objects[viewport].state['currentSelectedListViewController'] = tab
        call(c,r,tab,DOUBLE_ROW_SCROLL,scroll)
    else:
        call(c,r,owner,layout)
    if shelf:
        require(r.objects[row].state['superview'] == inline_parent and r.objects[holder].state['hidden'] and
                not surfaces(r, holder), 'The first owned shelf layout returns any pinned controls to their inline cell')
    top_surfaces = surfaces(r, root)
    require(len(top_surfaces) == 1, 'Exactly one frame-bounded effect is active with the native scroll edge available')
    blur = top_surfaces[0]
    root_children = r.objects[root].state['subviews']
    require(root_children.index(viewport)<root_children.index(blur)<root_children.index(header),
            'Effect samples the cover and keeps foreground controls above it')
    blur_state = r.objects[blur].state
    require(blur_state['frame'] == (0, 0, 440, boundary) and
            r.objects[blur_state['effect']].state['style'] == 6 and
            blur_state['alpha'] == 1 and not blur_state['userInteractionEnabled'],
            'The passive ultra-thin effect remains at full opacity within the toolbar bounds')
    tint = r.objects[blur_state['contentView']].state['backgroundColor']
    require(tint and r.objects[tint].state == {'source': r.color('systemBackgroundColor'), 'alpha': 0.0625},
            'The blur content has a lightly tinted system background that adapts to appearance')
    require(edge_state['hidden'] and edge_state['style'] == r.top_edge_stock and
            not r.objects[header].state.get('interactions'),
            'Bounded material suppresses the separate automatic scroll edge without installing an interaction')
    applied_inset = (stock_inset[0]+boundary, *stock_inset[1:])
    applied_offset = (0,stock_offset-boundary)
    expanded = (0,0,440,viewport_frame[1]+viewport_frame[3])
    require(r.objects[content_viewport].state['frame']==expanded and
            scroll_state['contentOffset']==applied_offset and scroll_state['contentInset']==applied_inset,
            'Expanded viewport and matching inset preserve scroll anchor and stock bottom')
    expected_cover = boundary-70 if nested else boundary-40
    require(drawn_rect(r,cover)[1] == expected_cover and r.objects[horizontal].state['clipsToBounds'],
            'The same scrolling cover can now draw behind the toolbar without opening horizontal clipping')
    if nested:
        require(r.objects[inner].state['contentInset']==(4,0,32,0), 'Nested feed receives no duplicate padding')
        require(r.objects[viewport].state['frame']==pager_frame,
                'Already full-height pager remains untouched')
        call(c,r,tab,DOUBLE_ROW_LAYOUT)
        require(r.objects[content_viewport].state['frame']==expanded and
                scroll_state['contentInset']==applied_inset and scroll_state['contentOffset']==applied_offset,
                'Native nestedFrame writes do not reintroduce clipping or shift the book')
        geometry = [record for event, record in r.header_records if event == 'topChromeGeometry']
        require(geometry and geometry[-1]['stockViewportFrame'] == list(viewport_frame) and
                geometry[-1]['scrollClipRect'][1] == 0,
                'Device diagnostics identify the real clip owner and show that its visible range reaches the top')
    refresh_animation = exercise_refresh(c, r, tab, scroll, content_viewport if nested else None)
    if nested:
        exercise_nested_refresh_geometry(c, r, tab, scroll, refresh_animation)
    if shelf:
        exercise_shelf_canvas(c, r, owner, tab, scroll, blur, config)
        exercise_shelf_section_headers(c, r, owner, tab, scroll)
        # The restore cases intentionally disable/re-enable glass, replacing
        # its surface. Subsequent steady-state checks use that new instance.
        require(len(surfaces(r, root)) == 1, 'Re-enabling shelf glass installs one surface')
        blur = surfaces(r, root)[0]
        require(r.objects[unrelated_layout].state['sectionHeadersPinToVisibleBounds'] and
                r.objects[unrelated_layout].state['invalidations'] == 0,
                'The native top tab strip keeps its unrelated layout policy')
        rest = -applied_inset[0]
        scroll_state.update(contentOffset=(0, rest), bounds=(0, rest, *scroll_state['bounds'][2:]))
        call(c, r, tab, FLOATING_LAYOUT, scroll)
        resting_filter = drawn_rect(r, filter_button)
        require(resting_filter[1] > boundary and resting_filter[3] == 28 and
                r.objects[filter_button].state['enabled'] and r.objects[filter_button].state['userInteractionEnabled'],
                'The native filter stays visible and interactive inline at rest')
        scroll_state.update(contentOffset=(0, rest + 12), bounds=(0, rest + 12, *scroll_state['bounds'][2:]))
        call(c, r, tab, FLOATING_LAYOUT, scroll)
        require(drawn_rect(r, filter_button)[1] == resting_filter[1] - 12,
                'The filter moves by the same amount as the book list')
        # A native write at a deeply scrolled offset must not move the anchor.
        scroll_state['contentOffset']=(0,64)
        scroll_state['bounds']=(0,64,*scroll_state['bounds'][2:])
        applied_offset=(0,64)
        stock_offset=64+boundary
        call(c,r,tab,UPDATE_INSET)
        require(scroll_state['contentOffset']==applied_offset and scroll_state['contentInset']==applied_inset,
                'Host mid-scroll inset rewrites do not move the visible cover')
        call(c, r, tab, FLOATING_LAYOUT, scroll)
        require(r.objects[row].state['superview'] == inline_parent and r.objects[holder].state['hidden'] and
                not surfaces(r, holder) and drawn_rect(r, filter_button)[3] == 0,
                'The filter leaves the viewport on deep scroll without showing a fixed material')
    for _ in range(3):
        call(c,r,owner,layout)
    require(surfaces(r,root) == [blur] and scroll_state['contentOffset']==applied_offset,
            'Settled layout reuses one bounded blur and preserves the scrolled offset')
    geometry = [record for event, record in r.header_records if event == 'topChromeGeometry']
    require(geometry and geometry[-1]['material'] == 'systemUltraThin',
            'Bookstore and bookshelf diagnostics report the same bounded blur as Mine')
    clear = r.color('clearColor')
    require(not r.objects[header].state['opaque'] and r.objects[header].state['backgroundColor'] == clear,
            'The stock toolbar fill clears so the backdrop remains visible')
    require(not r.objects[tab_strip].state['opaque'] and r.objects[tab_strip].state['backgroundColor'] == clear and
            r.objects[artwork].state['alpha']==0.25,
            'Opaque tab strip and gradient artwork above the pager stop blocking the backdrop')
    if shelf:
        scroll_state['contentInset']=stock_inset
    r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=1
    call(c,r,owner,layout)
    require(not surfaces(r,root) and r.objects[content_viewport].state['frame']==viewport_frame and
            scroll_state['contentInset']==stock_inset and scroll_state['contentOffset']==(0,stock_offset),
            'Disabling glass restores stock geometry and inset')
    require(edge_state['hidden'] == stock_edge_hidden and edge_state['style'] == r.top_edge_stock,
            'Disabling glass restores the originally visible or hidden stock edge without changing style')
    require(r.objects[header].state['backgroundColor']==stock_fill and r.objects[header].state['opaque'],
            'Disabling glass restores stock foreground fill and opacity hint')
    require(r.objects[tab_strip].state['backgroundColor']==stock_fill and r.objects[artwork].state['alpha']==1,
            'Disabling glass restores the exact tab strip fill and gradient artwork')
    if shelf:
        call(c, r, tab, FLOATING_LAYOUT, scroll)
        require(not surfaces(r, holder) and not r.objects[holder].state['hidden'] and
                r.objects[holder].state['frame'] == (0, 0, 440, 36) and
                r.objects[row].state['superview'] == holder,
                'With glass disabled, the host again pins the same native controls')
        call(c, r, tab, SHELF_SCROLL, scroll)
    require(not r.objects[refresh_animation].state['hidden'],
            'Removing the expanded viewport restores native refresh-artwork visibility')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', required=True, type=Path)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix('.composed.s'), LABELS)
    cases = ('bookstore', 'nested bookstore', 'bookstore in full pager', 'shelf')
    for case in cases:
        exercise(data, labels, case)
    result = {'passed': True, 'device_tested': False, 'pixel_rendering_tested': False, 'cases': cases}
    args.report.write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(result, indent=2))
