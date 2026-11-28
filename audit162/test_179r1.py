#!/usr/bin/env python3
"""Verify FanqieX 1.79R1 fixes against the compiled ARM64 extension."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import release_version, require
from test_control_glass166 import send
from test_controls171 import call
from test_drama_spacing178r2 import DISABLED, Runtime as SpacingRuntime, global_rect, glass_rect
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, make

CONTENT_BASE = "SSShortVideoDistributionContentBaseView"
NOVEL_ENTRANCE = "SSShortVideoOriginalNovelEntranceView"
RELATED_SEL = "applyRelatedInfoUIToContentView:textArray:showTag:recommendTagText:bookInfo:canShowReadTip:"


class Runtime(SpacingRuntime):
    RELATED_NATIVE = 0x33790000
    WILL_MOVE_NATIVE = 0x33790008

    def __init__(self, data):
        super().__init__(data)
        for name, parent in (
            (CONTENT_BASE, "UIView"),
            (NOVEL_ENTRANCE, "UIView"),
            ("UIPageControl", "UIView"),
            ("FQReaderSaaSBookStoreSelectView", "UIView"),
        ):
            if name not in self.classes:
                self._class(name, parent)
        content_cls = self.classes["SSShortVideoDistributionContentView"]
        base_cls = self.classes[CONTENT_BASE]
        self.parents[content_cls] = base_cls
        self.parents[self.metaclasses[content_cls]] = self.metaclasses[base_cls]
        self._add(self.classes[NOVEL_ENTRANCE], "layoutSubviews", self.LAYOUT_IMP, "v16@0:8")
        self._add(self.classes["UIView"], "willMoveToSuperview:", self.WILL_MOVE_NATIVE, "v24@0:8@16")
        self._add(self.classes["SSShortVideoBottomDistributionView"], RELATED_SEL,
                  self.RELATED_NATIVE, "v60@0:8@16@24@32@40@48B56")
        self.related_calls = []
        self.move_calls = []

    def handle(self, cpu, pc):
        if pc == self.RELATED_NATIVE:
            self.related_calls.append(tuple(cpu.x[:8]))
            return self.finish(cpu)
        if pc == self.WILL_MOVE_NATIVE:
            self.move_calls.append((cpu.x[0], cpu.x[2]))
            return self.finish(cpu)
        return super().handle(cpu, pc)


def feed_novel_plus_bottom_episode(data, labels, album_bottom=False):
    """Feed player with both original novel above title AND bottom episode pill."""
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    window = rt.view("UIWindow", "portrait window", (0., 0., 440., 956.))
    root = rt.view("FQVShortVideoVPlayerSeriesControlView", "portrait controls", (0., 0., 440., 876.), window)
    insert = rt.view("NativeInsertContainerView", "insert container", (0., 740., 440., 129.), root)
    rt.objects[root].state["insertAboveProgressView"] = insert

    # 1) Original novel entry sitting at the top of insertAboveProgressView (above title).
    novel = rt.view(NOVEL_ENTRANCE, "original novel entrance", (16., 0., 280., 28.), insert,
                    backgroundColor=rt.color("novel tint"))
    # Also test distribution-backed novel card above title (non-primary).
    novel_dist = rt.view("SSShortVideoBottomDistributionView", "related novel banner", (16., 32., 320., 36.), insert)
    novel_content = rt.view("SSShortVideoDistributionContentView", "related novel content",
                            (0., 0., 320., 36.), novel_dist, backgroundColor=rt.color("novel shade"))
    rt.objects[novel_dist].state["defaultContentView"] = novel_content
    send(cpu, rt, novel_dist, RELATED_SEL, novel_content,
         rt.obj("NSArray", "text", items=[]), 1, 0, rt.obj("NSObject", "book"), 1)

    # 2) Title between original novel and bottom episode pill.
    rt.label("drama title", insert, (16., 70., 360., 16.), "Drama Title")

    # 3) Bottom primary episode pill colliding with progress track at y=873.
    if album_bottom:
        entry = rt.view("SSShortVideoAlbumSeriesBottomInsertView", "bottom album pill", (0., 88., 440., 41.), insert,
                        gestureRecognizers=["host series tap"], userInteractionEnabled=True)
        content = rt.view("UIView", "album content", (0., 0., 440., 41.), entry,
                          backgroundColor=rt.color("host episode paint"))
        rt.objects[entry].state.update(containerView=content,
                                       albumDetailInfo=rt.obj("NSObject", "album model"))
    else:
        entry = rt.view("SSShortVideoBottomDistributionView", "bottom episode pill", (0., 88., 440., 41.), insert,
                        gestureRecognizers=["host series tap"], userInteractionEnabled=True)
        content = rt.view("SSShortVideoDistributionContentView", "episode content", (0., 0., 440., 41.), entry,
                          backgroundColor=rt.color("host episode paint"))
        rt.objects[entry].state["defaultContentView"] = content
        bar = rt.obj("NSObject", "episode bar", bottomBarType=rt.text_object("unreal_short_play"))
        model = rt.obj("NSObject", "episode render model", bottomBar=bar)
        send(cpu, rt, entry, "renderWithModel:", model)

    progress = rt.view("FQVShortVideoProgressView", "seek container", (0., 851., 440., 30.), root,
                       userInteractionEnabled=True, gestureRecognizers=["host seek pan"])
    track = rt.view("UIView", "seek track", (16., 22., 408., 2.), progress)
    rt.objects[progress].state["progressBarBackgroundView"] = track
    rt.objects[root].state["progressContainer"] = progress

    anchor = rt.obj("NSLayoutConstraint", "insert bottom anchor", firstItem=insert, secondItem=progress,
                    firstAttribute=4, secondAttribute=4, relation=0, multiplier=1., constant=-12., isActive=1)
    rt.objects[root].state["constraints"] = rt.obj("NSArray", "constraints", items=[anchor])

    def sync_constraint(runtime, view):
        if view == root:
            x, _, w, h = rt.objects[insert].state["frame"]
            rt.objects[insert].state["frame"] = (x, 881. + rt.objects[anchor].state["constant"] - h, w, h)

    rt.layout_mutator = sync_constraint
    send(cpu, rt, novel, "layoutSubviews")
    send(cpu, rt, entry, "layoutSubviews")
    for _ in range(4):
        send(cpu, rt, root, "layoutSubviews")

    episode_glass = glass_rect(rt, content)
    track_rect = global_rect(rt, track)
    gap = track_rect[1] - (episode_glass[1] + episode_glass[3])
    require(gap == 12., f"Bottom episode glass must stay 12pt above progress track when novel exists, got {gap}")

    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
    send(cpu, rt, root, "layoutSubviews")
    require(rt.objects[anchor].state["constant"] == -12., "Disable restores original host anchor constant")
    return {"album_bottom": album_bottom, "gap_pt": gap, "novel_width": global_rect(rt, novel)[2]}


def detail_novel_above_progress(data, labels, variant="entrance"):
    """Detail player with ONLY an original novel pill above the progress bar."""
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    window = rt.view("UIWindow", "portrait window", (0., 0., 440., 956.))
    root = rt.view("FQVShortVideoVPlayerSeriesControlView", "detail controls", (0., 0., 440., 876.), window)
    insert = rt.view("NativeInsertContainerView", "detail insert container", (0., 826., 440., 40.), root)
    rt.objects[root].state["insertAboveProgressView"] = insert

    if variant == "entrance":
        entry = rt.view(NOVEL_ENTRANCE, "detail novel entrance", (0., 0., 280., 40.), insert,
                        backgroundColor=rt.color("novel tint"), userInteractionEnabled=True)
        glass_owner = entry
    else:
        entry = rt.view("SSShortVideoBottomDistributionView", "detail novel distribution",
                        (0., 0., 280., 40.), insert, userInteractionEnabled=True)
        content = rt.view("SSShortVideoDistributionContentView", "detail novel content", (0., 0., 280., 40.), entry,
                          backgroundColor=rt.color("novel shade"))
        rt.objects[entry].state["defaultContentView"] = content
        send(cpu, rt, entry, RELATED_SEL, content,
             rt.obj("NSArray", "text", items=[]), 1, 0, rt.obj("NSObject", "book"), 1)
        glass_owner = content

    progress = rt.view("FQVShortVideoProgressView", "seek container", (0., 851., 440., 30.), root,
                       userInteractionEnabled=True, gestureRecognizers=["host seek pan"])
    track = rt.view("UIView", "seek track", (16., 22., 408., 2.), progress)
    rt.objects[progress].state["progressBarBackgroundView"] = track
    rt.objects[root].state["progressContainer"] = progress

    # secondAttribute=3 means NSLayoutAttributeTop of progressContainer.
    anchor = rt.obj("NSLayoutConstraint", "detail insert to seek top", firstItem=insert, secondItem=progress,
                    firstAttribute=4, secondAttribute=3, relation=0, multiplier=1., constant=15., isActive=1)
    rt.objects[root].state["constraints"] = rt.obj("NSArray", "constraints", items=[anchor])

    def sync_constraint(runtime, view):
        if view == root:
            x, _, w, h = rt.objects[insert].state["frame"]
            rt.objects[insert].state["frame"] = (x, 851. + rt.objects[anchor].state["constant"] - h, w, h)

    rt.layout_mutator = sync_constraint
    send(cpu, rt, entry, "layoutSubviews")
    send(cpu, rt, root, "layoutSubviews")

    novel_glass = glass_rect(rt, glass_owner)
    track_rect = global_rect(rt, track)
    gap = track_rect[1] - (novel_glass[1] + novel_glass[3])
    require(gap == 12., f"Detail novel pill ({variant}) must stay 12pt above track, got {gap}")

    rt.objects[rt.DEFAULTS].state["values"][DISABLED] = True
    send(cpu, rt, root, "layoutSubviews")
    require(rt.objects[anchor].state["constant"] == 15., "Disable restores detail novel host anchor")
    return {"variant": variant, "gap_pt": gap}


def mine_unified_liquid_glass_card(data, labels):
    """Mine shortcut row gets ONE unified liquid glass card spanning white card + page control."""
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    ui_view_cls = rt.classes["UIView"]
    base_layout_imp = rt.methods[rt.get_method(ui_view_cls, rt.sel("layoutSubviews"))]["imp"]
    base_move_imp = rt.methods[rt.get_method(ui_view_cls, rt.sel("willMoveToSuperview:"))]["imp"]

    call(cpu, labels, "LFQH_FQHPageInstall")
    require(rt.methods[rt.get_method(ui_view_cls, rt.sel("layoutSubviews"))]["imp"] == base_layout_imp and
            rt.methods[rt.get_method(ui_view_cls, rt.sel("willMoveToSuperview:"))]["imp"] == base_move_imp,
            "Unified Mine card hooks never mutate base UIView methods")

    results = {}
    for row_class, item_class in (
        ("SSMyUserShortcutCell", "SSMyUser621FunctionEntryItemCell"),
        ("SSMyUserCollectionView1Cell", "SSMyUserCollectionViewFunCell"),
    ):
        row_bg = rt.color(f"{row_class}.rowBg")
        row_cv_bg = rt.color(f"{row_class}.contentBg")
        white_card_bg = rt.color(f"{row_class}.whiteCard")
        scroller_bg = rt.color(f"{row_class}.scrollerBg")
        item_bg = rt.color(f"{row_class}.itemBg")
        clear = rt.color("clearColor")

        row = rt.view(row_class, "Mine shortcut row", (0., 240., 390., 92.), rt.ROOT, backgroundColor=row_bg)
        row_content = rt.view("UIView", "row contentView", (0., 0., 390., 92.), row, backgroundColor=row_cv_bg)
        rt.objects[row].state["contentView"] = row_content
        white_card = rt.view("UIView", "white shortcut card", (12., 6., 366., 68.), row_content,
                             backgroundColor=white_card_bg)
        scroller = rt.view("UIView", "shortcut horizontal scroller", (0., 0., 366., 68.), white_card,
                           backgroundColor=scroller_bg)
        page_control = rt.view("UIPageControl", "shortcut page dots", (155., 76., 80., 10.), row_content)

        items = []
        for idx, title in enumerate(("我的订单", "浏览历史", "我的消息", "创作中心", "游戏中心")):
            is_order = row_class == "SSMyUserShortcutCell" and idx == 0
            cls_name = "SSMyUserCollectionViewOrderFunCell" if is_order else item_class
            cell = rt.view(cls_name, title, (idx * 72., 4., 70., 60.), scroller,
                           backgroundColor=item_bg, userInteractionEnabled=True)
            content = rt.view("UIView", "item content", (0., 0., 70., 60.), cell, backgroundColor=item_bg)
            icon = rt.view("UIImageView", "item icon", (25., 8., 20., 20.), content)
            label = rt.label("item caption", content, (0., 35., 70., 18.), title)
            st = rt.objects[cell].state
            st["contentView"] = content
            if is_order:
                st.update(image=icon, productImage=icon, label=label)
            elif item_class == "SSMyUser621FunctionEntryItemCell":
                st.update(productImage=icon, functionType=label)
            else:
                st.update(image=icon, label=label)
            items.append((cell, content, icon, label))

        for cell, _, _, _ in items:
            send(cpu, rt, cell, "layoutSubviews")
        send(cpu, rt, row, "layoutSubviews")

        card_surface = call(cpu, labels, "LFQH_FQHSurface", row_content)["result"]
        require(card_surface, f"{row_class}: unified liquid glass card installed on row contentView")
        card_state = rt.objects[card_surface].state
        require(card_state["frame"] == (12., 6., 366., 80.),
                f"{row_class}: unified card spans white card + page control, got {card_state['frame']}")
        corner = rt.objects[card_state["cornerConfiguration"]]
        expected_radius = 22 if release_version(data) in ("1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6", "2.0.1beta7", "2.0.1beta8", "2.0.1beta9", "2.0.1beta12") else 18
        require(corner.state.get("max_radius") == expected_radius and card_state["overrideUserInterfaceStyle"] == 0,
                f"{row_class}: unified card uses max_radius {expected_radius} and adaptive interface style")

        for cell, content, _, _ in items:
            if release_version(data) in ("1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6", "2.0.1beta7", "2.0.1beta8", "2.0.1beta9", "2.0.1beta12"):
                item_surface = call(cpu, labels, "LFQH_FQHSurface", content)["result"]
                expected_item = {
                    "1.8R1": (10., 5., 50., 50.),
                    "1.8R2": (10., 5., 50., 50.),
                    "1.8R3": (10., 5., 50., 50.),
                    "1.8R4": (10., 5., 50., 50.),
                    "1.8R5": (10., 5., 50., 50.),
                    "1.8R6": (10., 5., 50., 50.),
        "1.8R7": (10., 5., 50., 50.),
        "1.8R8": (10., 5., 50., 50.),
        "1.8R9": (10., 5., 50., 50.),
        "1.8R10": (10., 5., 50., 50.),
        "1.8R11": (10., 5., 50., 50.),
        "1.8R12": (10., 5., 50., 50.),
        "1.8R13": (10., 5., 50., 50.),
        "1.8R14": (10., 5., 50., 50.),
        "1.8R15": (10., 5., 50., 50.),
        "1.8R16": (10., 5., 50., 50.),
        "1.8R17": (10., 5., 50., 50.),
        "1.8R18": (10., 5., 50., 50.),
        "1.8R19": (10., 5., 50., 50.),
        "1.9.1beta1": (10., 5., 50., 50.),
        "1.9.1beta2": (10., 5., 50., 50.),
        "1.9.1beta3": (10., 5., 50., 50.),
        "1.9.1beta4": (10., 5., 50., 50.),
        "1.9.1beta5": (10., 5., 50., 50.),
        "1.9.1beta6": (10., 5., 50., 50.),
        "1.9.1beta7": (10., 5., 50., 50.),
        "1.9.1beta8": (10., 5., 50., 50.),
        "1.9.1beta9": (10., 5., 50., 50.),
        "1.9.1beta10": (10., 5., 50., 50.),
        "1.9.1beta11": (10., 5., 50., 50.),
        "1.9.1beta12": (10., 5., 50., 50.),
        "1.9.1beta13": (10., 5., 50., 50.),
        "1.9.1beta14": (10., 5., 50., 50.),
        "1.9.1beta15": (10., 5., 50., 50.),
        "1.9.1beta16": (10., 5., 50., 50.),
        "1.9.1beta17": (10., 5., 50., 50.),
        "1.9.1beta18": (10., 5., 50., 50.),
        "1.9.1beta19": (10., 5., 50., 50.),
        "1.9.1beta20": (10., 5., 50., 50.),
        "1.9.1beta21": (10., 5., 50., 50.),
        "1.9.1beta22": (10., 5., 50., 50.),
        "1.9.1beta23": (10., 5., 50., 50.),
        "1.9.1beta24": (10., 5., 50., 50.),
        "1.9.1beta25": (10., 5., 50., 50.),
        "1.9.1beta26": (10., 5., 50., 50.),
        "1.9.5beta1": (10., 5., 50., 50.),
        "1.9.5beta2": (10., 5., 50., 50.),
        "1.9.5beta3": (10., 5., 50., 50.),
        "1.9.5beta4": (10., 5., 50., 50.),
        "1.9.5beta5": (10., 5., 50., 50.),
        "1.9.5beta6": (10., 5., 50., 50.),
        "1.9.5beta7": (10., 5., 50., 50.),
        "1.9.5beta8": (10., 5., 50., 50.),
        "1.9.5beta9": (10., 5., 50., 50.),
        "1.9.6beta1": (10., 5., 50., 50.),
        "1.9.6beta2": (10., 5., 50., 50.),
        "1.9.6beta3": (10., 5., 50., 50.),
        "1.9.6beta4": (10., 5., 50., 50.),
        "1.9.6beta5": (10., 5., 50., 50.),
        "1.9.6beta6": (10., 5., 50., 50.),
        "1.9.6beta7": (10., 5., 50., 50.),
        "1.9.6beta8": (10., 5., 50., 50.),
        "1.9.6beta9": (10., 5., 50., 50.),
        "1.9.7beta1": (10., 5., 50., 50.),
        "1.9.7beta2": (10., 5., 50., 50.),
        "1.9.7beta3": (10., 5., 50., 50.),
        "1.9.7beta4": (10., 5., 50., 50.),
        "1.9.7beta5": (10., 5., 50., 50.),
        "1.9.7beta6": (10., 5., 50., 50.),
        "1.9.7beta7": (10., 5., 50., 50.),
        "1.9.7beta8": (10., 5., 50., 50.),
        "1.9.7beta9": (10., 5., 50., 50.),
        "1.9.7beta10": (10., 5., 50., 50.),
        "1.9.8beta": (10., 5., 50., 50.),
        "1.9.8beta2": (10., 5., 50., 50.),
        "2.0": (10., 5., 50., 50.),
        "2.0.1beta1": (10., 5., 50., 50.),
        "2.0.1beta2": (10., 5., 50., 50.),
        "2.0.1beta3": (10., 5., 50., 50.),
        "2.0.1beta4": (10., 5., 50., 50.),
        "2.0.1beta5": (10., 5., 50., 50.),
        "2.0.1beta6": (10., 5., 50., 50.),
        "2.0.1beta7": (10., 5., 50., 50.),
        "2.0.1beta8": (10., 5., 50., 50.),
        "2.0.1beta9": (10., 5., 50., 50.),
        "2.0.1beta12": (10., 5., 50., 50.),
                    "1.79R5": (2., 1., 66., 58.),
                }.get(release_version(data), (4., 2., 62., 56.))
                require(item_surface and rt.objects[item_surface].state["frame"] == expected_item,
                        f"{row_class}: 1.79R3+ shortcut items get coordinated inner liquid glass buttons")
            else:
                require(not call(cpu, labels, "LFQH_FQHSurface", content)["result"],
                        f"{row_class}: individual shortcut items must not create per-item glass capsules")
            require(rt.objects[cell].state["backgroundColor"] == clear and
                    rt.objects[content].state["backgroundColor"] == clear,
                    f"{row_class}: individual shortcut item paints cleared cleanly")

        require(rt.objects[row].state["backgroundColor"] == clear and
                rt.objects[row_content].state["backgroundColor"] == clear and
                rt.objects[white_card].state["backgroundColor"] == clear and
                rt.objects[scroller].state["backgroundColor"] == clear,
                f"{row_class}: container card paints cleared behind unified liquid glass")

        # Disable restores every cleared background cleanly and removes unified surface.
        rt.objects[rt.DEFAULTS].state["values"][DISABLED] = 1
        for cell, _, _, _ in items:
            send(cpu, rt, cell, "layoutSubviews")
        send(cpu, rt, row, "layoutSubviews")
        require(not call(cpu, labels, "LFQH_FQHSurface", row_content)["result"] and
                rt.objects[white_card].state["backgroundColor"] == white_card_bg and
                rt.objects[scroller].state["backgroundColor"] == scroller_bg and
                rt.objects[row_content].state["backgroundColor"] == row_cv_bg,
                f"{row_class}: disabling glass restores all saved card backgrounds")
        rt.objects[rt.DEFAULTS].state["values"][DISABLED] = 0
        for cell, _, _, _ in items:
            send(cpu, rt, cell, "layoutSubviews")
        send(cpu, rt, row, "layoutSubviews")
        card_surface2 = call(cpu, labels, "LFQH_FQHSurface", row_content)["result"]
        require(card_surface2, f"{row_class}: re-enabling glass restores unified card")

        # Detaching row restores card and clears surface cleanly.
        send(cpu, rt, row, "willMoveToSuperview:", 0)
        require(not call(cpu, labels, "LFQH_FQHSurface", row_content)["result"] and
                rt.objects[white_card].state["backgroundColor"] == white_card_bg and
                rt.objects[scroller].state["backgroundColor"] == scroller_bg,
                f"{row_class}: detaching row removes unified glass and restores card backgrounds")
        results[row_class] = {"card_frame": list(card_state["frame"]), "item_count": len(items),
                              "page_control": page_control > 0}

    if release_version(data) in ("1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6", "2.0.1beta7", "2.0.1beta8", "2.0.1beta9", "2.0.1beta12"):
        # Real 7.4.3 VIP card (SSMyUserCollectionView1Cell with lynxVipView) must never be styled as a shortcut card.
        vip_bg = rt.color("vip.bg")
        vip_row = rt.view("SSMyUserCollectionView1Cell", "Mine VIP card", (16., 120., 408., 72.), rt.ROOT,
                          backgroundColor=vip_bg, lynxVipView=rt.obj("UIView", "lynx vip"))
        send(cpu, rt, vip_row, "layoutSubviews")
        require(not call(cpu, labels, "LFQH_FQHSurface", vip_row)["result"] and
                rt.objects[vip_row].state["backgroundColor"] == vip_bg,
                "Real 7.4.3 VIP card with lynxVipView is excluded from shortcut liquid glass")

        # Real 7.4.3 SSMyUserShortcutCell is already inset to 408pt with clipsToBounds=True and full-bounds funcView.
        full_bg = rt.color("full.rowBg")
        func_bg = rt.color("full.funcBg")
        strip_bg = rt.color("full.bottomStripBg")
        full_row = rt.view("SSMyUserShortcutCell", "7.4.3 shortcut cell", (16., 220., 408., 96.), rt.ROOT,
                           backgroundColor=full_bg, clipsToBounds=True)
        func_view = rt.view("UIView", "SSScrollFoldFuncView", (0., 0., 408., 96.), full_row, backgroundColor=func_bg)
        select_dots = rt.view("FQReaderSaaSBookStoreSelectView", "7.4.3 page dots", (0., 80., 408., 16.), func_view,
                              backgroundColor=strip_bg)
        send(cpu, rt, full_row, "layoutSubviews")
        full_surface = call(cpu, labels, "LFQH_FQHSurface", full_row)["result"]
        require(full_surface and rt.objects[full_surface].state["frame"] == (0., 0., 408., 96.) and
                not rt.objects[full_row].state["clipsToBounds"],
                "Full-bounds 7.4.3 shortcut cell unclips row bounds so 18pt liquid glass corners are unclipped")
        if release_version(data) in ("1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6", "2.0.1beta7", "2.0.1beta8", "2.0.1beta9", "2.0.1beta12"):
            require(rt.objects[select_dots].state["backgroundColor"] == clear,
                    "1.79R3+ clears full-width bottom page-control strip so outer card bottom is never chopped")
        rt.objects[rt.DEFAULTS].state["values"][DISABLED] = 1
        send(cpu, rt, full_row, "layoutSubviews")
        require(not call(cpu, labels, "LFQH_FQHSurface", full_row)["result"] and
                rt.objects[full_row].state["clipsToBounds"] and
                rt.objects[func_view].state["backgroundColor"] == func_bg and
                (release_version(data) not in ("1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6", "2.0.1beta7", "2.0.1beta8", "2.0.1beta9", "2.0.1beta12") or rt.objects[select_dots].state["backgroundColor"] == strip_bg),
                "Disabling glass restores 7.4.3 shortcut cell clipsToBounds and funcView background")
        rt.objects[rt.DEFAULTS].state["values"][DISABLED] = 0
        results["host_743_shortcut"] = {"unclipped_active": True, "select_dots": select_dots > 0}
    return results


def detail_novel_crossfade_zero_alpha(data, labels):
    """During performForegroundCrossfadeWithRenderBlock:, alpha starts at 0.0 before animation."""
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    window = rt.view("UIWindow", "portrait window", (0., 0., 440., 956.))
    root = rt.view("FQVShortVideoVPlayerSeriesControlView", "detail controls", (0., 0., 440., 876.), window)
    insert = rt.view("NativeInsertContainerView", "detail insert container", (0., 826., 440., 40.), root)
    rt.objects[root].state["insertAboveProgressView"] = insert
    entry = rt.view("SSShortVideoBottomDistributionView", "crossfading novel distribution",
                    (0., 0., 280., 40.), insert, userInteractionEnabled=True, alpha=0.0)
    content = rt.view("SSShortVideoDistributionContentView", "crossfading novel content",
                      (0., 0., 280., 40.), entry, backgroundColor=rt.color("novel shade"), alpha=0.0)
    rt.objects[entry].state["defaultContentView"] = content
    progress = rt.view("FQVShortVideoProgressView", "seek container", (0., 851., 440., 30.), root,
                       userInteractionEnabled=True, gestureRecognizers=["host seek pan"])
    track = rt.view("UIView", "seek track", (16., 22., 408., 2.), progress)
    rt.objects[progress].state["progressBarBackgroundView"] = track
    rt.objects[root].state["progressContainer"] = progress
    anchor = rt.obj("NSLayoutConstraint", "detail insert to seek top", firstItem=insert, secondItem=progress,
                    firstAttribute=4, secondAttribute=3, relation=0, multiplier=1., constant=15., isActive=1)
    rt.objects[root].state["constraints"] = rt.obj("NSArray", "constraints", items=[anchor])

    def sync_constraint(runtime, view):
        if view == root:
            x, _, w, h = rt.objects[insert].state["frame"]
            rt.objects[insert].state["frame"] = (x, 851. + rt.objects[anchor].state["constant"] - h, w, h)

    rt.layout_mutator = sync_constraint
    send(cpu, rt, entry, RELATED_SEL, content,
         rt.obj("NSArray", "text", items=[]), 1, 0, rt.obj("NSObject", "book"), 1)
    send(cpu, rt, root, "layoutSubviews")
    novel_glass = glass_rect(rt, content)
    track_rect = global_rect(rt, track)
    gap = track_rect[1] - (novel_glass[1] + novel_glass[3])
    require(gap == 12., f"Crossfading alpha=0 novel pill must already resolve 12pt gap, got {gap}")
    return {"crossfade_gap_pt": gap}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    version = release_version(data)
    require(version in ("1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6", "2.0.1beta7", "2.0.1beta8", "2.0.1beta9", "2.0.1beta12"), f"Expected 1.79R1..1.79R4 candidate, got {version}")
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), EXTRA)
    report = {
        "passed": True,
        "version": version,
        "candidate_sha256": hashlib.sha256(data).hexdigest(),
        "feed_dist_with_novel": feed_novel_plus_bottom_episode(data, labels, album_bottom=False),
        "feed_album_with_novel": feed_novel_plus_bottom_episode(data, labels, album_bottom=True),
        "detail_novel_entrance": detail_novel_above_progress(data, labels, variant="entrance"),
        "detail_novel_distribution": detail_novel_above_progress(data, labels, variant="distribution"),
        "mine_unified_card": mine_unified_liquid_glass_card(data, labels),
        "device_tested": False,
    }
    if version in ("1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13", "1.9.1beta14", "1.9.1beta15", "1.9.1beta16", "1.9.1beta17", "1.9.1beta18", "1.9.1beta19", "1.9.1beta20", "1.9.1beta21", "1.9.1beta22", "1.9.1beta23", "1.9.1beta24", "1.9.1beta25", "1.9.1beta26", "1.9.5beta1", "1.9.5beta2", "1.9.5beta3", "1.9.5beta4", "1.9.5beta5", "1.9.5beta6", "1.9.5beta7", "1.9.5beta8", "1.9.5beta9", "1.9.6beta1", "1.9.6beta2", "1.9.6beta3", "1.9.6beta4", "1.9.6beta5", "1.9.6beta6", "1.9.6beta7", "1.9.6beta8", "1.9.6beta9", "1.9.7beta1", "1.9.7beta2", "1.9.7beta3", "1.9.7beta4", "1.9.7beta5", "1.9.7beta6", "1.9.7beta7", "1.9.7beta8", "1.9.7beta9", "1.9.7beta10", "1.9.8beta", "1.9.8beta2", "2.0", "2.0.1beta1", "2.0.1beta2", "2.0.1beta3", "2.0.1beta4", "2.0.1beta5", "2.0.1beta6", "2.0.1beta7", "2.0.1beta8", "2.0.1beta9", "2.0.1beta12"):
        report["detail_novel_crossfade"] = detail_novel_crossfade_zero_alpha(data, labels)
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
