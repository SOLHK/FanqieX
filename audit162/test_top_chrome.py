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
UPDATE_INSET = 'updateCollectionViewInsets'
FLOATING_LAYOUT = 'updateFullGenreFloatingViewWithScrollView:'
PROPERTIES = (
    'contentView', 'simpleHeader', 'currentTabVC', 'containerView', 'collectionView',
    'doubleRowNestContainerScrollView', 'listView', 'headerView', 'tabSelectView',
    'headerBackgroundView', 'fullGenreFloatingContainerView', 'functionCell',
    'layoutContainerView', 'filterView', 'tabContainer', 'simpleTabView', 'view',
)


class Runtime(TopChromeRuntime, HeaderRuntime):
    def __init__(self, data):
        super().__init__(data)
        self.dispatch_methods = True
        for cls in (SHELF, SHELF_LIST):
            self._class(cls, 'UIViewController')
        self._class('UICollectionView', 'UIScrollView')
        self._class('SSNestedContainerScrollView', 'UIScrollView')
        self._class('SSBookStoreTabViewController', 'UIViewController')
        self._class('FQRJXCategoryListContainerView', 'UIView')
        self.original_update_inset = 0x3304e200
        self.original_float_layout = 0x3304e300
        self.hosts[0x3304e100] = (SHELF, 'viewLayout')
        self._add(self.classes[SHELF], 'viewLayout', 0x3304e100, 'v16@0:8')
        self._add(self.classes[SHELF_LIST], UPDATE_INSET, self.original_update_inset, 'v16@0:8')
        self._add(self.classes[SHELF_LIST], FLOATING_LAYOUT, self.original_float_layout, 'v24@0:8@16')

    def handle(self, cpu, pc):
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
        return super().handle(cpu, pc)


def surface(r, owner):
    for child in r.objects[owner].state['subviews']:
        view = r.objects[child]
        if (r.class_names[view.cls] == 'UIVisualEffectView' and
                r.class_names[r.objects[view.state['effect']].cls] == 'UIBlurEffect'):
            return child
    return 0


def exercise(data, labels, kind):
    r = Runtime(data)
    r.labels = labels
    words = struct.unpack_from('<64I', data, 0x800)
    c = CPU(data, r, ranges=[(0x800,0x4000), (0x4878,0x48d0), (0x14080,0x800+words[61])])
    c.pointers.update(r.rebase_pointers)
    c.run(labels['LFQH_FQHInstall'], max_steps=1500000)

    shelf = kind == 'shelf'
    boundary = 106 if shelf else 144
    viewport_frame = (0, boundary, 440, 956-boundary)
    root = r.view('UIView', 'page', (0,0,440,956), r.ROOT)
    viewport = r.view('FQRJXCategoryListContainerView', 'pager', viewport_frame, root)
    horizontal = r.view('UIScrollView', 'horizontal pager', (0,0,440,956-boundary), viewport, clipsToBounds=True)
    page = r.view('UIView', 'active page', (0,0,440,956-boundary), horizontal)
    scroll_class = 'SSNestedContainerScrollView' if kind == 'nested bookstore' else 'UICollectionView'
    stock_inset = (6, 3, 32, 5)
    scroll = r.view(scroll_class, 'vertical feed', (0,0,440,956-boundary), page,
                    clipsToBounds=True, contentInset=stock_inset, contentOffset=(0, 72))
    scroll_state = r.objects[scroll].state
    scroll_state['bounds'] = (0, 72, 440, 956-boundary)
    cover = r.view('UIView', 'cover', (12,32,144,180), scroll)
    stock_fill = r.color('host top bar')
    header = r.view('UIView', 'header controls', (0,0,440,boundary), root,
                    backgroundColor=stock_fill, opaque=True)
    tabs = r.view('UIView', 'host tabs', (0,boundary-36,440,36), header)
    tab_state = {'collectionView': scroll, 'view': page}
    if kind == 'nested bookstore':
        # The nested coordinator is the vertical scroll, while the child list's
        # padding must continue to be managed by the host.
        inner = r.view('UICollectionView', 'nested feed list', (0,125,440,300), scroll,
                       clipsToBounds=True, contentInset=(4, 0, 32, 0))
        tab_state.update(doubleRowNestContainerScrollView=scroll, collectionView=inner)
    tab = r.obj(SHELF_LIST if shelf else 'SSBookStoreTabViewController', 'active tab', **tab_state)
    if shelf:
        holder = r.view('UIView', 'native pinned filter holder', (0,0,440,36), page,
                        backgroundColor=stock_fill, clipsToBounds=True)
        filter_view = r.view('UIView', 'native filter controls', (0,0,440,36), holder)
        cell = r.obj('UIViewController', 'shelf function row', layoutContainerView=filter_view)
        r.objects[tab].state.update(fullGenreFloatingContainerView=holder, functionCell=cell,
                                   stockInset=stock_inset)
        owner = r.obj(SHELF, 'shelf', view=root, headerView=header, tabSelectView=tabs,
                      containerView=viewport, currentTabVC=tab)
        layout = 'viewLayout'
    else:
        owner = r.obj(HOME, 'bookstore', contentView=root, simpleHeader=header, simpleTabView=tabs,
                      containerView=viewport, currentTabVC=tab, searchBgView=0)
        layout = 'relayout'
    require(drawn_rect(r,cover)[1] == boundary, 'Stock clipping stops the cover at the toolbar edge')
    call(c,r,owner,layout)
    blur = surface(r,root)
    root_children = r.objects[root].state['subviews']
    require(blur and root_children.index(viewport)<root_children.index(blur)<root_children.index(header),
            'Effect samples the cover and keeps foreground controls above it')
    require(r.objects[blur].state['frame']==(0,0,440,boundary) and
            r.objects[r.objects[blur].state['effect']].state['style']==7 and
            not r.objects[blur].state['userInteractionEnabled'], 'Passive adaptive thin material spans the toolbar')
    require(r.objects[viewport].state['frame']==(0,boundary-56,440,956-boundary+56) and
            scroll_state['contentOffset']==(0,16) and scroll_state['contentInset']==(62,3,32,5),
            'Expanded viewport and matching inset preserve scroll anchor and stock bottom')
    require(drawn_rect(r,cover)[1] == boundary-40 and r.objects[horizontal].state['clipsToBounds'],
            'The same scrolling cover can now draw behind the toolbar without opening horizontal clipping')
    if kind == 'nested bookstore':
        require(r.objects[inner].state['contentInset']==(4,0,32,0), 'Nested feed receives no duplicate padding')
    if shelf:
        call(c,r,tab,FLOATING_LAYOUT,scroll)
        require(surface(r,holder) and r.objects[holder].state['frame']==(0,56,440,36),
                'Pinned filter gets its own blur and keeps its screen position under the main toolbar')
        call(c,r,tab,UPDATE_INSET)
        require(scroll_state['contentOffset']==(0,16) and scroll_state['contentInset']==(62,3,32,5),
                'Host mid-scroll inset rewrites do not move the visible cover')
    for _ in range(3):
        call(c,r,owner,layout)
    require(surface(r,root)==blur and scroll_state['contentOffset']==(0,16), 'Settled layout reuses blur and offset')
    require(not r.objects[header].state['opaque'], 'Stock fill no longer hides the backdrop')
    if shelf:
        scroll_state['contentInset']=stock_inset
    r.objects[r.DEFAULTS].state['values']['FanqieAdBlock.GlassDisabled.1']=1
    call(c,r,owner,layout)
    require(not surface(r,root) and r.objects[viewport].state['frame']==viewport_frame and
            scroll_state['contentInset']==stock_inset and scroll_state['contentOffset']==(0,72),
            'Disabling glass restores stock geometry and inset')
    require(r.objects[header].state['backgroundColor']==stock_fill and r.objects[header].state['opaque'],
            'Disabling glass restores stock foreground fill and opacity hint')
    if shelf:
        require(not surface(r,holder) and r.objects[holder].state['frame']==(0,0,440,36),
                'Disabling glass restores the original pinned-filter holder')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('candidate', type=Path)
    parser.add_argument('--report', required=True, type=Path)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix('.composed.s'), LABELS)
    cases = ('bookstore', 'nested bookstore', 'shelf')
    for case in cases:
        exercise(data, labels, case)
    result = {'passed': True, 'device_tested': False, 'pixel_rendering_tested': False, 'cases': cases}
    args.report.write_text(json.dumps(result, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(result, indent=2))
