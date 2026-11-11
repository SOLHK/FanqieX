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
SHELF_REFRESH = 'SSNewRefreshHeader'
SHELF_SCROLL = 'scrollViewDidScroll:'
DOUBLE_ROW = 'SSBookStoreDoubleRowViewController'
DOUBLE_ROW_SCROLL = 'storeTabScrollViewDidScroll:'
DOUBLE_ROW_LAYOUT = 'viewWillLayoutSubviews'
UPDATE_INSET = 'updateCollectionViewInsets'
FLOATING_LAYOUT = 'updateFullGenreFloatingViewWithScrollView:'
PROPERTIES = (
    'contentView', 'simpleHeader', 'currentTabVC', 'containerView', 'collectionView',
    'currentSelectedListViewController', 'doubleRowNestContainerScrollView', 'listView',
    'nestedView', 'viewIfLoaded',
    'delegate', 'backgroundView', 'headerBgImgView', 'headerView', 'tabSelectView',
    'headerBackgroundView', 'fullGenreFloatingContainerView', 'functionCell',
    'layoutContainerView', 'filterView', 'tabContainer', 'simpleTabView', 'view',
)


class Runtime(TopChromeRuntime, HeaderRuntime):
    def __init__(self, data):
        super().__init__(data)
        self.dispatch_methods = True
        for cls in (SHELF, SHELF_LIST, DOUBLE_ROW):
            self._class(cls, 'UIViewController')
        self._class('UICollectionView', 'UIScrollView')
        self._class('SSNestedContainerScrollView', 'UIScrollView')
        self._class('SSBookStoreNestedTabView', 'UIView')
        self._class('SSBookStoreTabViewController', 'UIViewController')
        self._class('FQRJXCategoryListContainerView', 'UIView')
        self._class(SHELF_REFRESH, 'UIView')
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
        for cls, selector, address, encoding in (
                (SHELF_LIST, SHELF_SCROLL, self.original_shelf_scroll, 'v24@0:8@16'),
                (SHELF_REFRESH, 'setState:', self.original_refresh_state, 'v24@0:8q16'),
                (SHELF_REFRESH, 'setAnimationHidden:', self.original_refresh_visibility, 'v20@0:8B16'),
                (SHELF_REFRESH, 'placeSubviews', self.LAYOUT_IMP, 'v16@0:8'),
                (SHELF_REFRESH, 'animationView', self.LAYOUT_IMP, '@16@0:8'),
                (SHELF_REFRESH, 'isRefreshing', self.LAYOUT_IMP, 'B16@0:8')):
            self._add(self.classes[cls], selector, address, encoding)

    def handle(self, cpu, pc):
        if pc == self.original_shelf_scroll:
            self.event('shelf_scroll', cpu.x[0])
            return self.finish(cpu)
        if pc == self.original_refresh_state:
            self.objects[cpu.x[0]].state['refresh_state'] = cpu.x[2]
            return self.finish(cpu)
        if pc == self.original_refresh_visibility:
            header = self.objects[cpu.x[0]].state
            self.objects[header['animationView']].state['hidden'] = bool(cpu.x[2])
            return self.finish(cpu)
        if pc == self.original_double_row_scroll:
            return self.finish(cpu)
        if pc == self.original_double_row_layout:
            tab = self.objects[cpu.x[0]].state
            nested = self.objects[tab['nestedView']].state
            nested['frame'] = tab['stockNestedFrame']
            nested['bounds'] = (0, 0, *nested['frame'][2:])
            return self.finish(cpu)
        if pc in (self.original_update_inset, self.original_float_layout):
            tab = self.objects[cpu.x[0]].state
            if pc == self.original_update_inset:
                self.objects[tab['collectionView']].state['contentInset'] = tab['stockInset']
            else:
                holder = self.objects[tab['fullGenreFloatingContainerView']].state
                holder['frame'] = (0, 0, 440, 36)
            return self.finish(cpu)
        if pc-self.slide == 0xa5d4 and cpu.x[0] in self.objects:
            state = self.objects[cpu.x[0]].state
            name = self.selector_names.get(cpu.x[1])
            if name in PROPERTIES and name in state:
                return self.finish(cpu, state[name])
            if name in ('mj_header', 'animationView', 'isDragging') and name in state:
                return self.finish(cpu, state[name])
            if name == 'isRefreshing' and 'refresh_state' in state:
                return self.finish(cpu, state['refresh_state'] in (3, 4))
            if name == 'setAlpha:':
                state['alpha'] = cpu.fp(0)
                return self.finish(cpu)
            if name == 'setContentOffset:' and 'pinnedInnerScroll' in state:
                inner = self.objects[state['pinnedInnerScroll']].state
                y = cpu.fp(1)
                inner['frame'] = (0, y, *inner['frame'][2:])
                inner['bounds'] = (0, y - 370, *inner['bounds'][2:])
        return super().handle(cpu, pc)


def surface(r, owner):
    for child in r.objects[owner].state['subviews']:
        view = r.objects[child]
        if (r.class_names[view.cls] == 'UIVisualEffectView' and
                r.class_names[r.objects[view.state['effect']].cls] == 'UIBlurEffect'):
            return child
    return 0


def exercise_shelf_refresh(c, r, tab, scroll):
    scroll_state = r.objects[scroll].state
    original_inset, original_offset = scroll_state['contentInset'], scroll_state['contentOffset']
    header_frame = (0, -54, 440, 54)
    header = r.view(SHELF_REFRESH, 'bookshelf refresh header', header_frame, scroll, refresh_state=1)
    animation = r.view('UIView', 'native three-dot artwork', (199, 8, 42, 36), header)
    r.objects[header].state['animationView'] = animation
    scroll_state.update(mj_header=header, delegate=tab, isDragging=False)
    call(c, r, header, 'placeSubviews')
    require(r.objects[animation].state['hidden'] and not r.objects[header].state['hidden'],
            'The idle artwork alone is hidden in the expanded shelf viewport')

    rest = -original_inset[0]
    scroll_state.update(contentOffset=(0, rest-30), isDragging=True)
    call(c, r, tab, SHELF_SCROLL, scroll)
    require(not r.objects[animation].state['hidden'], 'A real pull reveals the original artwork')
    call(c, r, header, 'setState:', 3)
    scroll_state.update(contentOffset=(0, rest), isDragging=False)
    call(c, r, tab, SHELF_SCROLL, scroll)
    require(not r.objects[animation].state['hidden'], 'Active refreshing stays visible when dragging ends')
    call(c, r, header, 'setState:', 1)
    require(r.objects[animation].state['hidden'],
            'Stock completion hides stale artwork even without another scroll event')

    call(c, r, header, 'setAnimationHidden:', 1)
    scroll_state.update(contentOffset=(0, rest-30), isDragging=True)
    call(c, r, tab, SHELF_SCROLL, scroll)
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
    tab = r.obj(SHELF_LIST if shelf else DOUBLE_ROW if nested else 'SSBookStoreTabViewController',
                'active tab', **tab_state)
    if shelf:
        holder = r.view('UIView', 'native pinned filter holder', (0,0,440,36), page,
                        backgroundColor=stock_fill, clipsToBounds=True)
        filter_view = r.view('UIView', 'native filter controls', (0,0,440,36), holder)
        cell = r.obj('UIViewController', 'shelf function row', layoutContainerView=filter_view)
        r.objects[tab].state.update(fullGenreFloatingContainerView=holder, functionCell=cell,
                                   stockInset=stock_inset)
        owner = r.obj(SHELF, 'shelf', view=root, headerView=header, tabSelectView=tabs,
                      containerView=viewport, currentTabVC=tab, headerBgImgView=artwork)
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
    blur = surface(r,root)
    root_children = r.objects[root].state['subviews']
    require(blur and root_children.index(viewport)<root_children.index(blur)<root_children.index(header),
            'Effect samples the cover and keeps foreground controls above it')
    require(r.objects[blur].state['frame']==(0,0,440,boundary) and
            r.objects[r.objects[blur].state['effect']].state['style']==6 and
            not r.objects[blur].state['userInteractionEnabled'], 'Passive ultra-thin material spans the toolbar')
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
    if shelf:
        refresh_animation = exercise_shelf_refresh(c, r, tab, scroll)
        call(c,r,tab,FLOATING_LAYOUT,scroll)
        require(surface(r,holder) and r.objects[holder].state['frame']==(0,boundary,440,36),
                'Pinned filter gets its own blur and keeps its screen position under the main toolbar')
        # A native write at a deeply scrolled offset must not move the anchor.
        scroll_state['contentOffset']=(0,64)
        scroll_state['bounds']=(0,64,*scroll_state['bounds'][2:])
        applied_offset=(0,64)
        stock_offset=64+boundary
        call(c,r,tab,UPDATE_INSET)
        require(scroll_state['contentOffset']==applied_offset and scroll_state['contentInset']==applied_inset,
                'Host mid-scroll inset rewrites do not move the visible cover')
    for _ in range(3):
        call(c,r,owner,layout)
    require(surface(r,root)==blur and scroll_state['contentOffset']==applied_offset, 'Settled layout reuses blur and offset')
    require(not r.objects[header].state['opaque'], 'Stock fill no longer hides the backdrop')
    require(not r.objects[tab_strip].state['opaque'] and r.objects[artwork].state['alpha']==0.25,
            'Opaque tab strip and gradient artwork above the pager stop blocking the backdrop')
    if shelf:
        scroll_state['contentInset']=stock_inset
    r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=1
    call(c,r,owner,layout)
    require(not surface(r,root) and r.objects[content_viewport].state['frame']==viewport_frame and
            scroll_state['contentInset']==stock_inset and scroll_state['contentOffset']==(0,stock_offset),
            'Disabling glass restores stock geometry and inset')
    require(r.objects[header].state['backgroundColor']==stock_fill and r.objects[header].state['opaque'],
            'Disabling glass restores stock foreground fill and opacity hint')
    require(r.objects[tab_strip].state['backgroundColor']==stock_fill and r.objects[artwork].state['alpha']==1,
            'Disabling glass restores the exact tab strip fill and gradient artwork')
    if shelf:
        call(c, r, tab, SHELF_SCROLL, scroll)
        require(not r.objects[refresh_animation].state['hidden'],
                'Removing the expanded viewport restores native refresh-artwork visibility')
        require(not surface(r,holder) and r.objects[holder].state['frame']==(0,0,440,36),
                'Disabling glass restores the original pinned-filter holder')


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
