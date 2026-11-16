#!/usr/bin/env python3
"""Run the emitted bottom-bar appearance code at explicit UIKit boundaries.

Only Foundation/UIKit messages are modeled here. Layout policy, semantic icon
choice, state restoration, and scroll decisions must execute in the candidate
ARM64. This is not a UIKit renderer, gesture simulator, or iPhone acceptance.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import math
import struct
from pathlib import Path

from arm64 import require
from test_feed_viewport import labels_for
from test_tab_appearance175 import Runtime as AppearanceRuntime
from test_native_orchestration162 import make, repair, require_native, require_fallback


ICONS = "FanqieX.BottomIconsOnly.1"
COMPACT = "FanqieX.BottomDramaCompact.1"
LENGTH = "FanqieX.BottomLengthScale.1"
HEIGHT = "FanqieX.BottomHeightScale.1"
BUTTON_WIDTH = "FanqieX.BottomButtonWidthScale.1"
ICON_SIZE = "FanqieX.BottomIconPointSize.1"
ENTRY_LABELS = ["Lrecord_named", "LFQH_FQHBottomPrepare", "LFQH_FQHBottomFinish",
                "LFQH_FQHBottomReset178", "LFQH_FQHBottomPan178",
                "LFQH_FQHBottomOptionChanged178", "LFQH_FQHBottomOptionsReset178"]


class Runtime(AppearanceRuntime):
    """Public symbol, font, button-content, and geometry messages only."""

    def __init__(self, *args, **options):
        self.symbol_nil = False
        self.symbol_calls = []
        self.content_writes = []
        self.new_labels = {}
        super().__init__(*args, **options)
        for cls, parent in (
            ("UIFont", "NSObject"), ("UIImage", "NSObject"),
            ("UIImageSymbolConfiguration", "NSObject"),
            ("UIImageView", "UIView"), ("NSValue", "NSObject"),
            ("UIScreen", "NSObject"),
            ("UICollectionView", "UIScrollView"),
            ("FQFeedListCollectionView", "UICollectionView"),
            ("UISwitch", "UIControl"), ("UISlider", "UIControl"),
        ):
            if cls not in self.classes:
                self._class(cls, parent)
        self.screen = self.obj("UIScreen", "3x display", scale=3.0)
        self.objects[self.WINDOW].state["screen"] = self.screen
        self.page_view = self.view("UIView", "selected page root", (0, 0, 440, 882), self.ROOT)
        self.objects[self.page].state.update(view=self.page_view, viewIfLoaded=self.page_view)
        self.objects[self.owner].state.update(customTabBar=self.BAR, view=self.ROOT,
                                             viewIfLoaded=self.ROOT, presentedViewController=0)
        self.configure_tabs(("书城", "短剧", "书架", "我的"), selected=2)

    def configure_tabs(self, titles, selected=0):
        """Explicit server tab plan; no mapping policy is implemented here."""
        old_buttons = self.buttons[:]
        self.buttons = []
        for index, title in enumerate(titles):
            button = old_buttons[index] if index < len(old_buttons) else self.view(
                "UIButton", "tab_" + str(index), parent=self.PROXY_CONTENT)
            self.buttons.append(button)
            width = (self.objects[self.PROXY].state["bounds"][2] - 8) / len(titles)
            font = self.obj("UIFont", "stock tab font", pointSize=16.0, weight=0.4)
            label = self.view("UILabel", "tab title", (0, 0, 32, 20), button,
                              text=self.text_object(title), font=font)
            glyph = self.view("UIImageView", "tab glyph", (0, 0, 20, 20), button,
                              image=0, contentMode=1)
            state = self.objects[button].state
            state.update(
                frame=(4 + width * index, 4, width, 48), bounds=(0, 0, width, 48),
                title=self.text_object(title), titles={0: self.text_object(title)},
                images={}, attributedTitles={}, titleLabel=label, imageView=glyph,
                accessibilityLabel=self.text_object(title), selected=index == selected,
                enabled=True, userInteractionEnabled=True,
                accessibilityElementsHidden=False, isAccessibilityElement=True,
                titleEdgeInsets=(0., 0., 0., 0.), imageEdgeInsets=(0., 0., 0., 0.),
                contentEdgeInsets=(0., 0., 0., 0.),
                originalTarget=self.BAR, originalAction="fqab_homeTabPressed:",
            )
        for button in old_buttons[len(titles):]:
            self.reparent(button, 0)
        self.items = [self.obj("UITabBarItem", "host item " + title,
                               title=self.text_object(title), enabled=True)
                      for title in titles]
        self.items_array = self.obj("NSMutableArray", "host tab plan", items=self.items[:])
        self.buttons_array = self.obj("NSMutableArray", "plugin buttons", items=self.buttons[:])
        self.objects[self.BAR].state.update(items=self.items_array,
                                            selectedItem=self.items[selected])
        self.associations[(self.PROXY, self.slide + 0xeb85)] = self.buttons_array
        type_by_title = {"书城": 0, "短剧": 7, "书架": 3, "我的": 4, "商城": 9}
        types = [self.box(type_by_title.get(title, 99)) for title in titles]
        self.objects[self.owner].state.update(
            typeArray=self.obj("NSArray", "tab types", items=types),
            selectedIndex=selected,
            viewControllers=self.obj("NSArray", "tab controllers", items=[
                self.page if index == selected else self.obj(
                    "UIViewController", "other tab", viewIfLoaded=0)
                for index in range(len(titles))]),
        )

    def add_feed(self):
        feed = self.view("FQFeedListCollectionView", "active drama feed", (0, 0, 440, 882), self.page_view,
                         contentSize=(440., 4000.), contentOffset=(0., 882.),
                         contentInset=(0., 0., 0., 0.), clipsToBounds=True,
                         dragging=False, tracking=False, decelerating=False)
        host_target = self.obj("NSObject", "host scroll target")
        pan = self.obj("UIPanGestureRecognizer", "host scroll pan", view=feed, state=0,
                       translation=(0., 0.), velocity=(0., 0.), numberOfTouches=1,
                       target=host_target, action=self.sel("hostPan:"),
                       extra_targets=[], delegate=host_target, enabled=True)
        self.objects[feed].state["panGestureRecognizer"] = pan
        return feed, pan, host_target

    def defaults(self, **values):
        self.objects[self.DEFAULTS].state["values"].update(values)

    def responds(self, receiver, name):
        if receiver in self.objects:
            state = self.objects[receiver].state
            if name in state:
                return True
            if self.is_kind(receiver, self.classes["UIButton"]) and name in (
                "imageForState:", "titleForState:", "attributedTitleForState:",
                "setImage:forState:", "setTitle:forState:", "setAttributedTitle:forState:",
                "currentImage", "currentTitle", "imageView", "titleLabel", "isSelected",
                "setPreferredSymbolConfiguration:forImageInState:",
            ):
                return True
            if self.is_kind(receiver, self.classes["UIImage"]) and name in (
                "imageWithRenderingMode:", "imageByApplyingSymbolConfiguration:", "size",
            ):
                return True
            if self.is_kind(receiver, self.classes["UISegmentedControl"]) and name == "titleTextAttributesForState:":
                return True
            if self.is_kind(receiver, self.classes["UIFont"]) and name in (
                "pointSize", "fontWithSize:",
            ):
                return True
            if self.is_kind(receiver, self.classes["UIGestureRecognizer"]) and name in (
                "addTarget:action:", "removeTarget:action:", "translationInView:",
                "velocityInView:", "view", "state", "numberOfTouches",
            ):
                return True
            if self.is_kind(receiver, self.classes["NSHashTable"]) and name in ("anyObject", "allObjects"):
                return True
            if self.is_kind(receiver, self.classes["NSNumber"]) and name == "stringValue":
                return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        local = pc - self.slide
        if local != 0xa5d4:
            return super().handle(cpu, pc)
        args = cpu.x[:8]
        receiver = args[0]
        name = self.selector_names.get(args[1])
        if receiver in self.classes.values():
            cls = self.class_names[receiver]
            symbol_factories = {
                "UIImage": ("systemImageNamed:", "systemImageNamed:withConfiguration:"),
                "UIImageSymbolConfiguration": (
                    "configurationWithPointSize:weight:scale:",
                    "configurationWithPointSize:weight:", "configurationWithPointSize:",
                ),
            }
            if name == "respondsToSelector:" and self.selector_names[args[2]] in symbol_factories.get(cls, ()):
                return self.finish(cpu, 1)
            if cls == "UIImageSymbolConfiguration" and name.startswith("configurationWithPointSize:"):
                return self.finish(cpu, self.obj(cls, "symbol configuration", pointSize=cpu.fp(0),
                                                weight=args[2] if "weight:" in name else 0,
                                                scale=args[3] if "scale:" in name else 0))
            if cls == "UIImage" and name in symbol_factories["UIImage"]:
                symbol = self.string_value(args[2])
                config = args[3] if name.endswith("withConfiguration:") else 0
                self.symbol_calls.append((symbol, config))
                return self.finish(cpu, 0 if self.symbol_nil else self.obj(
                    cls, "symbol:" + symbol, symbol=symbol, configuration=config,
                    size=(20., 20.), renderingMode=2))
            if cls == "UIFont" and name in ("systemFontOfSize:", "systemFontOfSize:weight:"):
                return self.finish(cpu, self.obj(cls, "system font", pointSize=cpu.fp(0),
                                                weight=cpu.fp(1) if name.endswith("weight:") else 0))
            if cls == "UIScreen" and name == "mainScreen":
                return self.finish(cpu, self.screen)
            if cls == "NSValue" and name in ("valueWithCGRect:", "valueWithCGPoint:"):
                count = 4 if "CGRect" in name else 2
                return self.finish(cpu, self.obj(cls, "geometry", value=tuple(cpu.fp(i) for i in range(count))))
            if cls == "UIImageView" and name in ("alloc", "new"):
                view = self.view(cls, "owned symbol overlay", userInteractionEnabled=False,
                                 isAccessibilityElement=False)
                self.retain_balance[view] = 1
                return self.finish(cpu, view)
        if receiver in self.objects:
            state = self.objects[receiver].state
            cls = self.class_names[self.objects[receiver].cls]
            if name == "isEqual:" and not self.is_kind(receiver, self.classes["UIColor"]):
                return self.finish(cpu, int(self.object_equal(receiver, args[2])))
            if name == "titleTextAttributesForState:" and cls == "UISegmentedControl":
                attributes=state.get("titleTextAttributes", {}).get(args[2])
                return self.finish(cpu, self.dict_pointer(attributes) if attributes is not None else 0)
            if name == "setTitle:forSegmentAtIndex:" and cls == "UISegmentedControl":
                require(args[3] < len(state["segments"]), "Native title segment index is in range")
                state["segments"][args[3]] = args[2]
                return self.finish(cpu)
            if name in ("imageForState:", "titleForState:", "attributedTitleForState:"):
                field = {"imageForState:": "images", "titleForState:": "titles",
                         "attributedTitleForState:": "attributedTitles"}[name]
                values=state.get(field, {})
                return self.finish(cpu, values.get(args[2], values.get(0, 0)))
            if name in ("setImage:forState:", "setTitle:forState:", "setAttributedTitle:forState:"):
                field = {"setImage:forState:": "images", "setTitle:forState:": "titles",
                         "setAttributedTitle:forState:": "attributedTitles"}[name]
                if args[2]:
                    state.setdefault(field, {})[args[3]] = args[2]
                else:
                    state.setdefault(field, {}).pop(args[3], None)
                if field == "titles" and args[3] == 0:
                    state["title"] = args[2]
                self.content_writes.append((receiver, name, args[3], args[2]))
                return self.finish(cpu)
            if name == "isSelected":
                return self.finish(cpu, int(state.get("selected", False)))
            if name in ("tag", "isOn"):
                return self.finish(cpu, state.get(name, 0))
            if name == "value" and cls == "UISlider":
                return self.finish(cpu, float_value=state.get("value", 0.0))
            if name == "stringValue" and cls == "NSNumber":
                return self.finish(cpu, self.text_object(str(state["value"])))
            if name == "stringByAppendingString:" and cls == "NSString":
                return self.finish(cpu, self.text_object(state["value"] + self.string_value(args[2])))
            if name in ("typeArray", "selectedIndex", "viewIfLoaded", "viewControllers", "view", "screen",
                        "customTabBar", "presentedViewController", "panGestureRecognizer"):
                return self.finish(cpu, state.get(name, 0))
            if name == "intValue":
                return self.finish(cpu, int(state.get("value", 0)))
            if name in ("isDragging", "isDecelerating", "isTracking") and self.is_kind(
                    receiver, self.classes["UIScrollView"]):
                return self.finish(cpu, int(state.get(name[2].lower() + name[3:], False)))
            if name in ("contentOffset", "contentInset"):
                return self.finish(cpu, fp=state[name])
            if name == "clipsToBounds":
                return self.finish(cpu, int(state.get("clipsToBounds", False)))
            if name == "setClipsToBounds:":
                state["clipsToBounds"] = bool(args[2])
                return self.finish(cpu)
            if name in ("setContentOffset:", "setContentInset:"):
                count = 2 if name == "setContentOffset:" else 4
                state[name[3].lower() + name[4:-1]] = tuple(cpu.fp(i) for i in range(count))
                return self.finish(cpu)
            if name == "initWithFrame:":
                frame = tuple(cpu.fp(i) for i in range(4))
                state.update(frame=frame, bounds=(0., 0., *frame[2:]))
                return self.finish(cpu, receiver)
            if name == "initWithImage:":
                state["image"] = args[2]
                return self.finish(cpu, receiver)
            if name in ("font", "imageView", "accessibilityLabel", "currentTitle", "currentImage"):
                field = {"currentTitle": "title", "currentImage": "image"}.get(name, name)
                if name == "currentImage":
                    return self.finish(cpu, state.get("images", {}).get(4 if state.get("selected") else 0,
                                                                       state.get("images", {}).get(0, 0)))
                return self.finish(cpu, state.get(field, 0))
            if name in ("setFont:", "setAccessibilityLabel:", "setAccessibilityIdentifier:",
                        "setText:", "setImage:", "setContentMode:", "setContentHorizontalAlignment:",
                        "setContentVerticalAlignment:", "setNumberOfLines:",
                        "setAdjustsFontSizeToFitWidth:"):
                state[name[3].lower() + name[4:-1]] = args[2]
                return self.finish(cpu)
            if name in ("pointSize", "scale", "displayScale"):
                return self.finish(cpu, fp=(state.get(name, 0.0),))
            if name == "cornerRadius":
                return self.finish(cpu, fp=(state.get("cornerRadius", 0.0),))
            if name == "transform":
                transform = state.get("transform", (1., 0., 0., 1., 0., 0.))
                cpu.write(cpu.x[8], 48, int.from_bytes(struct.pack("<6d", *transform), "little"))
                return self.finish(cpu)
            if name == "fontWithSize:":
                return self.finish(cpu, self.obj("UIFont", "resized font", **dict(state, pointSize=cpu.fp(0))))
            if name in ("CGRectValue", "CGPointValue"):
                return self.finish(cpu, fp=state["value"])
            if name in ("imageEdgeInsets", "titleEdgeInsets", "contentEdgeInsets"):
                return self.finish(cpu, fp=state.get(name, (0., 0., 0., 0.)))
            if name in ("setImageEdgeInsets:", "setTitleEdgeInsets:", "setContentEdgeInsets:"):
                state[name[3].lower() + name[4:-1]] = tuple(cpu.fp(i) for i in range(4))
                return self.finish(cpu)
            if name == "imageWithRenderingMode:":
                return self.finish(cpu, self.obj("UIImage", "template image", **dict(state, renderingMode=args[2])))
            if name == "imageByApplyingSymbolConfiguration:":
                return self.finish(cpu, self.obj("UIImage", "configured symbol", **dict(state, configuration=args[2])))
            if name == "setPreferredSymbolConfiguration:forImageInState:":
                state.setdefault("symbolConfigurations", {})[args[3]] = args[2]
                return self.finish(cpu)
            if cls == "NSUserDefaults":
                if name == "setDouble:forKey:":
                    state["values"][self.string_value(args[2])] = cpu.fp(0)
                    return self.finish(cpu)
                if name == "doubleForKey:":
                    return self.finish(cpu, fp=(float(state["values"].get(self.string_value(args[2]), 0)),))
                if name == "setObject:forKey:":
                    state["values"][self.string_value(args[3])] = self.native(args[2])
                    return self.finish(cpu)
                if name == "removeObjectForKey:":
                    state["values"].pop(self.string_value(args[2]), None)
                    return self.finish(cpu)
            if name == "layoutIfNeeded":
                if receiver == self.PROXY:
                    self.objects[self.PROXY_CONTENT].state["frame"] = state["bounds"]
                    self.objects[self.PROXY_CONTENT].state["bounds"] = state["bounds"]
                return self.finish(cpu)
            if name in ("translationInView:", "velocityInView:") and self.is_kind(
                    receiver, self.classes["UIGestureRecognizer"]):
                return self.finish(cpu, fp=state["translation" if name.startswith("translation") else "velocity"])
            if name in ("addTarget:action:", "removeTarget:action:") and self.is_kind(
                    receiver, self.classes["UIGestureRecognizer"]):
                row = (args[2], args[3])
                targets = state.setdefault("extra_targets", [])
                if name.startswith("add") and row not in targets:
                    targets.append(row)
                elif name.startswith("remove") and row in targets:
                    targets.remove(row)
                return self.finish(cpu)
        return super().handle(cpu, pc)


def fixture(data, labels, *, titles=("书城", "短剧", "书架", "我的"), selected=0,
            fallback=False, slide=0):
    cpu, runtime, entries = make(data, runtime_class=Runtime, slide=slide,
                                 missing_segment_class=fallback)
    runtime.labels = labels
    runtime.new_labels = labels
    runtime.configure_tabs(titles, selected)
    return cpu, runtime, entries


def call(cpu, labels, name, *args):
    return cpu.run(labels["LFQH_" + name], args=args, max_steps=3000000)


def host_geometry(runtime, extra=()):
    return {obj: {key: copy.deepcopy(runtime.objects[obj].state.get(key))
                  for key in ("frame", "bounds", "contentOffset", "contentInset", "clipsToBounds")}
            for obj in (runtime.WINDOW, runtime.ROOT, runtime.SCROLL, runtime.BAR, *extra)}


def button_contents(runtime):
    return {button: {key: copy.deepcopy(runtime.objects[button].state.get(key))
                     for key in ("titles", "images", "attributedTitles", "originalTarget", "originalAction")}
            for button in runtime.buttons}


def route_and_images(contents):
    return {button: {key: value for key, value in state.items()
                     if key not in ("titles", "attributedTitles")}
            for button, state in contents.items()}


def overlays(runtime, button):
    return [child for child in runtime.objects[button].state["subviews"]
            if runtime.objects[child].name == "owned symbol overlay"]


def overlay_image(runtime, button):
    owned = overlays(runtime, button)
    require(len(owned) == 1, "One noninteractive symbol overlay per recognized tab")
    state = runtime.objects[owned[0]].state
    require(not state.get("userInteractionEnabled", False), "Symbol overlays never intercept tab taps")
    require(not state.get("isAccessibilityElement", False), "Symbol overlays do not duplicate VoiceOver items")
    image = state.get("image")
    require(image in runtime.objects, "Symbol overlay contains a real UIImage boundary result")
    return runtime.objects[image].state


def check_input(runtime, cpu, fallback, expected):
    previous_count = len(runtime.route_calls)
    if fallback:
        require_fallback(runtime)
        # The unchanged original button IMP maps the current array identity.
        cpu.run(0x56c0, runtime.BAR, runtime.sel("fqab_homeTabPressed:"),
                runtime.buttons[expected], max_steps=3000000)
    else:
        require_native(runtime)
        runtime.fire(cpu, index=expected)
    require(runtime.route_calls[previous_count:] == [expected],
            "A single user action invokes the original tab route exactly once")


def default_and_geometry(data, labels):
    cases = []
    for fallback in (False, True):
        for titles in (("书城", "书架", "我的"), ("书城", "短剧", "书架", "我的"),
                       ("书城", "短剧", "商城", "书架", "我的")):
            cpu, runtime, entries = fixture(data, labels, titles=titles, fallback=fallback)
            original = host_geometry(runtime)
            content = button_contents(runtime)
            stock_frame = runtime.objects[runtime.PROXY].state["frame"]
            repair(cpu, runtime, entries)
            require(runtime.objects[runtime.PROXY].state["frame"] == stock_frame,
                    "Unset dimensions preserve the existing 56pt capsule")
            require(all(not overlays(runtime, button) for button in runtime.buttons),
                    "Pure-icon mode starts disabled")
            require(button_contents(runtime) == content, "Default mode preserves all button states and actions")
            for length, height, width in ((80, 90, 75), (50, 80, 70), (100, 125, 100)):
                runtime.defaults(**{LENGTH: length, HEIGHT: height, BUTTON_WIDTH: width})
                repair(cpu, runtime, entries)
                proxy = runtime.objects[runtime.PROXY].state["frame"]
                require(all(math.isfinite(value) for value in proxy), "Custom geometry remains finite")
                require(48 <= proxy[3] <= 70, "Capsule height respects its safe visual range")
                require(proxy[2] <= stock_frame[2] + 0.5, "Custom length stays within the accepted dock")
                require(abs((proxy[0] + proxy[2]/2) - (stock_frame[0] + stock_frame[2]/2)) <= 0.5,
                        "Custom dock keeps its original horizontal center")
                for button in runtime.buttons:
                    rect = runtime.objects[button].state["frame"]
                    require(rect[2] >= 44 and rect[3] >= 44,
                            "Each visible navigation target remains at least 44pt")
                    require(rect[0] >= -0.5 and rect[1] >= -0.5 and
                            rect[0] + rect[2] <= proxy[2] + 0.5 and
                            rect[1] + rect[3] <= proxy[3] + 0.5,
                            "Buttons stay inside the resized capsule")
                if fallback:
                    lens = runtime.associated(runtime.PROXY, "lens")
                    require(runtime.objects[lens].state["frame"] == runtime.objects[
                        runtime.buttons[runtime.selected_index()]].state["frame"],
                        "Fallback selected pill follows the resized selected button exactly")
                elif width != 100:
                    native = runtime.control()
                    native_frame = runtime.objects[native].state["frame"]
                    first = runtime.objects[runtime.buttons[0]].state["frame"]
                    last = runtime.objects[runtime.buttons[-1]].state["frame"]
                    require(abs(native_frame[0] + 4 - first[0]) < 0.001 and
                            abs(native_frame[0] + native_frame[2] - 4 - last[0] - last[2]) < 0.001,
                            "Native selection and visible button group share their inner track")
                current = {v: runtime.objects[v].state["frame"] for v in (runtime.PROXY, *runtime.buttons)}
                for _ in range(4):
                    repair(cpu, runtime, entries)
                require(current == {v: runtime.objects[v].state["frame"] for v in current},
                        "Repeated layout cannot compound size scaling")
                require(host_geometry(runtime) == original, "Dock customization does not resize host views")
            runtime.defaults(**{LENGTH: 100, HEIGHT: 100, BUTTON_WIDTH: 100})
            repair(cpu, runtime, entries)
            require(runtime.objects[runtime.PROXY].state["frame"] == stock_frame,
                    "Restoring dimension defaults returns the exact stock capsule")
            require(button_contents(runtime) == content, "Resizing never rewrites native button content")
            check_input(runtime, cpu, fallback, len(titles)-1)
            cases.append({"renderer": "fallback" if fallback else "native", "tabs": len(titles),
                          "sizes_restored": True, "host_geometry_unchanged": True})
    return cases


def icon_lifecycle(data, labels):
    cases = []
    title_groups = (("书城", "短剧", "书架", "我的"), ("我的", "书架", "书城"),
                    ("商城", "我的", "短剧", "书架", "书城"))
    symbols_by_title = {}
    for fallback in (False, True):
        for titles in title_groups:
            cpu, runtime, entries = fixture(data, labels, titles=titles, fallback=fallback)
            original = button_contents(runtime)
            stock_visibility = {runtime.objects[b].state[field]: runtime.objects[
                runtime.objects[b].state[field]].state["hidden"]
                for b in runtime.buttons for field in ("titleLabel", "imageView")}
            runtime.defaults(**{ICONS: True})
            repair(cpu, runtime, entries)
            for title, button in zip(titles, runtime.buttons):
                image = overlay_image(runtime, button)
                require(bool(image.get("symbol")), "Known tabs use vector system symbols")
                semantic_symbol = image["symbol"].removesuffix(".fill")
                if title in symbols_by_title:
                    require(symbols_by_title[title] == semantic_symbol,
                            "The same semantic tab keeps its icon after server reordering")
                else:
                    symbols_by_title[title] = semantic_symbol
                state = runtime.objects[button].state
                require(runtime.objects[state["titleLabel"]].state["hidden"] and
                        runtime.objects[state["imageView"]].state["hidden"],
                        "Pure-icon mode hides both original visual content views")
            require(route_and_images(button_contents(runtime)) == route_and_images(original),
                    "Pure-icon mode preserves original state artwork and target/action")
            control = runtime.control()
            if control:
                require([runtime.string_value(value) for value in runtime.objects[control].state["segments"]] == list(titles),
                        "Native transparent titles retain exact VoiceOver tab names")
            else:
                require([runtime.string_value(runtime.objects[b].state["accessibilityLabel"]) for b in runtime.buttons] == list(titles),
                        "Fallback buttons retain exact VoiceOver tab names")
            owned = [overlays(runtime, button)[0] for button in runtime.buttons]
            for _ in range(5):
                repair(cpu, runtime, entries)
            require(owned == [overlays(runtime, button)[0] for button in runtime.buttons],
                    "Stable layout reuses symbol views")
            check_input(runtime, cpu, fallback, len(titles)-1)
            runtime.defaults(**{ICONS: False})
            repair(cpu, runtime, entries)
            require(all(not overlays(runtime, b) for b in runtime.buttons),
                    "Turning pure-icon mode off removes every owned overlay")
            require(all(runtime.objects[obj].state["hidden"] == hidden for obj, hidden in stock_visibility.items()),
                    "Turning pure-icon mode off restores original hidden flags")
            require(button_contents(runtime) == original, "Disable restores content without losing alternate states")
            cases.append({"renderer": "fallback" if fallback else "native", "tabs": list(titles),
                          "icons_reversible": True, "voiceover_titles_preserved": True})
    require(len(set(symbols_by_title.values())) == len(symbols_by_title),
            "Different navigation roles have distinguishable icons")
    require(symbols_by_title == {"书城": "house", "短剧": "play.rectangle", "书架": "books.vertical",
                                 "我的": "person", "商城": "bag"},
            "System symbols match the intended navigation semantics")
    return {"cases": cases, "symbols_by_title": symbols_by_title}


def unknown_and_failure(data, labels):
    cases = []
    for fallback in (False, True):
        for original_image in (False, True):
            cpu, runtime, entries = fixture(data, labels, titles=("书城", "自定义", "我的"), fallback=fallback)
            unknown = runtime.buttons[1]
            if original_image:
                image = runtime.obj("UIImage", "host custom glyph", size=(22., 22.), renderingMode=0)
                runtime.objects[unknown].state["images"][0] = image
            runtime.defaults(**{ICONS: True})
            content = button_contents(runtime)
            repair(cpu, runtime, entries)
            if original_image:
                require(overlay_image(runtime, unknown).get("renderingMode") == 2,
                        "An unknown tab can use its original glyph as a template")
            else:
                label = runtime.objects[unknown].state["titleLabel"]
                require(not runtime.objects[label].state["hidden"] and not overlays(runtime, unknown),
                        "An unrecognized tab without artwork stays identifiable by text")
            require(route_and_images(button_contents(runtime)) == route_and_images(content),
                    "Unknown-tab fallback preserves original artwork and routes")
            runtime.defaults(**{ICONS: False})
            repair(cpu, runtime, entries)
            require(button_contents(runtime) == content, "Disabling icons restores all original title states")
            cases.append({"renderer": "fallback" if fallback else "native", "host_image": original_image})
        cpu, runtime, entries = fixture(data, labels, fallback=fallback)
        runtime.symbol_nil = True
        runtime.defaults(**{ICONS: True})
        repair(cpu, runtime, entries)
        require(all(not runtime.objects[runtime.objects[b].state["titleLabel"]].state["hidden"]
                    for b in runtime.buttons), "Failed symbol allocation leaves readable titles")
    return cases


def send_pan(cpu, runtime, pan, state, translation=(0., 0.)):
    fixture_state = runtime.objects[pan].state
    fixture_state.update(state=state, translation=translation)
    targets = fixture_state.get("extra_targets", [])[:]
    require(len(targets) == 1, "The plugin adds only one observer to the host pan recognizer")
    target, selector = targets[0]
    cpu.run(0xa5d4, args=(target, selector, pan), max_steps=3000000)


def scroll_lifecycle(data, labels):
    cases = []
    for fallback in (False, True):
        cpu, runtime, entries = fixture(data, labels, selected=1, fallback=fallback)
        feed, pan, host_target = runtime.add_feed()
        before = host_geometry(runtime, (feed,))
        stock = runtime.objects[runtime.PROXY].state["frame"]
        repair(cpu, runtime, entries)
        require(not runtime.objects[pan].state["extra_targets"], "Scroll compact mode starts disabled")
        runtime.defaults(**{COMPACT: True})
        repair(cpu, runtime, entries)
        require(len(runtime.objects[pan].state["extra_targets"]) == 1,
                "Only the currently visible drama feed receives an observer")
        pan_before = {key: runtime.objects[pan].state[key] for key in ("target", "action", "delegate")}
        for _ in range(4):
            repair(cpu, runtime, entries)
        require(len(runtime.objects[pan].state["extra_targets"]) == 1,
                "Repeated layout does not add duplicate pan callbacks")
        send_pan(cpu, runtime, pan, 1)
        for translation in ((0., -12.), (60., -30.)):
            send_pan(cpu, runtime, pan, 2, translation)
            repair(cpu, runtime, entries)
            require(runtime.objects[runtime.PROXY].state["frame"] == stock,
                    "Minor movement and horizontal tab swipes cannot shrink the bar")
        send_pan(cpu, runtime, pan, 2, (0., -48.))
        repair(cpu, runtime, entries)
        compact = runtime.objects[runtime.PROXY].state["frame"]
        require(compact[2] < stock[2] and compact[3] < stock[3],
                "Scrolling down through the drama feed compacts the bar")
        send_pan(cpu, runtime, pan, 2, (0., -600.))
        repair(cpu, runtime, entries)
        send_pan(cpu, runtime, pan, 2, (0., -567.))
        repair(cpu, runtime, entries)
        require(runtime.objects[runtime.PROXY].state["frame"] == stock,
                "A 33pt reversal expands after a long drag, without retracing its full distance")
        send_pan(cpu, runtime, pan, 3, (0., -567.))
        send_pan(cpu, runtime, pan, 1)
        send_pan(cpu, runtime, pan, 2, (0., -48.))
        repair(cpu, runtime, entries)
        send_pan(cpu, runtime, pan, 2, (0., -16.))
        repair(cpu, runtime, entries)
        require(runtime.objects[runtime.PROXY].state["frame"] == stock,
                "A reversal crossing the initial dead zone can still expand")
        send_pan(cpu, runtime, pan, 2, (0., -80.))
        repair(cpu, runtime, entries)
        require(runtime.objects[runtime.PROXY].state["frame"][2] < stock[2], "A later down-scroll can compact again")
        send_pan(cpu, runtime, pan, 4, (0., -80.))
        repair(cpu, runtime, entries)
        require(runtime.objects[runtime.PROXY].state["frame"] == stock, "Cancelled pans restore expanded layout")
        send_pan(cpu, runtime, pan, 1)
        send_pan(cpu, runtime, pan, 2, (0., -60.))
        repair(cpu, runtime, entries)
        runtime.defaults(**{COMPACT: False})
        repair(cpu, runtime, entries)
        require(not runtime.objects[pan].state["extra_targets"] and
                runtime.objects[runtime.PROXY].state["frame"] == stock,
                "Disabling auto compact detaches its callback and expands immediately")
        require({key: runtime.objects[pan].state[key] for key in pan_before} == pan_before,
                "Original pan target, action, and delegate are untouched")
        require(runtime.objects[pan].state["delegate"] == host_target,
                "The host keeps gesture arbitration")
        require(host_geometry(runtime, (feed,)) == before, "No scroll or video geometry/insets are changed")
        cases.append({"renderer": "fallback" if fallback else "native", "long_drag_reversal": True,
                      "cancel_and_disable_expand": True, "host_gesture_and_geometry_preserved": True})
    return cases


def scroll_rejections(data, labels):
    cases = []
    for reason in ("wrong_tab", "offscreen", "horizontal_transition", "modal", "hidden", "different_window"):
        cpu, runtime, entries = fixture(data, labels, selected=1)
        feed, pan, _ = runtime.add_feed()
        runtime.defaults(**{COMPACT: True})
        if reason == "wrong_tab":
            runtime.objects[runtime.owner].state["selectedIndex"] = 0
        elif reason == "offscreen":
            runtime.objects[feed].state["frame"] = (0., 1200., 440., 882.)
        elif reason == "horizontal_transition":
            runtime.objects[feed].state["frame"] = (-321.6, 0., 440., 882.)
        elif reason == "modal":
            runtime.objects[runtime.owner].state["presentedViewController"] = runtime.obj(
                "UIViewController", "settings modal")
        elif reason == "hidden":
            runtime.objects[feed].state["hidden"] = True
        elif reason == "different_window":
            second_window = runtime.view("UIWindow", "other scene", (0., 0., 440., 956.))
            runtime.reparent(feed, second_window)
        before = host_geometry(runtime, (feed,))
        repair(cpu, runtime, entries)
        require(not runtime.objects[pan].state["extra_targets"], "Unsafe scroll rejected: " + reason)
        require(host_geometry(runtime, (feed,)) == before, "Rejected scroll leaves host geometry intact")
        cases.append(reason)
    return cases


def bounded_preferences_and_reset(data, labels):
    cases = []
    for value in (float("nan"), float("inf"), float("-inf"), -1000, 10000):
        cpu, runtime, entries = fixture(data, labels)
        runtime.defaults(**{LENGTH: value, HEIGHT: value, BUTTON_WIDTH: value, ICON_SIZE: value})
        original = host_geometry(runtime)
        repair(cpu, runtime, entries)
        frame = runtime.objects[runtime.PROXY].state["frame"]
        require(all(math.isfinite(n) for n in frame) and frame[2] > 0 and frame[3] >= 48,
                "Corrupted preferences cannot produce nonfinite or untappable layout")
        require(host_geometry(runtime) == original, "Bounded preference handling is local to owned views")
        cases.append(str(value))
    cpu, runtime, entries = fixture(data, labels)
    stock = runtime.objects[runtime.PROXY].state["frame"]
    runtime.defaults(**{ICONS: True, LENGTH: 80, HEIGHT: 90, BUTTON_WIDTH: 75})
    repair(cpu, runtime, entries)
    call(cpu, labels, "FQHBottomReset178", runtime.BAR, runtime.PROXY)
    require(runtime.objects[runtime.PROXY].state["frame"] == stock,
            "Explicit teardown restores the frame owned by this customization")
    require(all(not overlays(runtime, button) for button in runtime.buttons),
            "Explicit teardown removes only plugin symbol views")
    repair(cpu, runtime, entries)
    # The host can adopt a different frame after plugin layout. Restore must
    # honor that subsequent writer instead of imposing a stale baseline.
    host_frame = (18., 1., 390., 54.)
    runtime.objects[runtime.PROXY].state.update(frame=host_frame, bounds=(0., 0., 390., 54.))
    call(cpu, labels, "FQHBottomReset178", runtime.BAR, runtime.PROXY)
    require(runtime.objects[runtime.PROXY].state["frame"] == host_frame,
            "Teardown does not overwrite a newer host-owned frame")
    return {"corrupt_values": cases, "teardown_restores_only_owned_values": True}


def setting_callbacks(data, labels):
    cpu, runtime, entries = fixture(data, labels)
    repair(cpu, runtime, entries)
    controller = runtime.obj("NSObject", "settings owner")
    switch = runtime.view("UISwitch", "icon switch", tag=1, isOn=True)
    callback_sel = runtime.sel("fqx178_bottomOptionChanged:")
    call(cpu, labels, "FQHBottomOptionChanged178", controller, callback_sel, switch)
    values = runtime.objects[runtime.DEFAULTS].state["values"]
    require(values.get(ICONS) is True, "The icon switch persists its own preference")
    runtime.objects[switch].state.update(tag=2, isOn=True)
    call(cpu, labels, "FQHBottomOptionChanged178", controller, callback_sel, switch)
    require(values.get(COMPACT) is True, "The compact switch persists independently")
    for tag, key, raw, expected in ((11, LENGTH, 79.6, 80), (12, HEIGHT, 3., 80),
                                    (13, BUTTON_WIDTH, 500., 100), (14, ICON_SIZE, 22.3, 22)):
        slider = runtime.view("UISlider", "dimension slider", tag=tag, value=raw)
        call(cpu, labels, "FQHBottomOptionChanged178", controller, callback_sel, slider)
        require(values.get(key) == expected, "Slider rounds/clamps and stores its canonical value")
    bad = runtime.view("UISlider", "invalid slider sample", tag=11, value=float("nan"))
    call(cpu, labels, "FQHBottomOptionChanged178", controller, callback_sel, bad)
    require(values[LENGTH] == 80, "A nonfinite slider value cannot corrupt stored preferences")
    preserved = {"FanqieX.ReaderThemePreset.1": "custom-reading-color", "SomeHostPreference": 17}
    values.update(preserved)
    call(cpu, labels, "FQHBottomOptionsReset178", controller, runtime.sel("fqx178_resetBottom:"), 0)
    require(not any(key in values for key in (ICONS, COMPACT, LENGTH, HEIGHT, BUTTON_WIDTH, ICON_SIZE)),
            "Reset removes all six bottom preferences")
    require(all(values[key] == value for key, value in preserved.items()),
            "Reset leaves host and reading settings unchanged")
    repair(cpu, runtime, entries)
    require(all(not overlays(runtime, button) for button in runtime.buttons),
            "Persisted reset returns to readable default labels")
    return {"switches_persisted_independently": True, "sliders_clamped": True,
            "unrelated_preferences_preserved": True}


def layout_direction_and_disable(data, labels):
    cases = []
    for fallback in (False, True):
        cpu, runtime, entries = fixture(data, labels, selected=1, fallback=fallback)
        feed, pan, _ = runtime.add_feed()
        stock = runtime.objects[runtime.PROXY].state["frame"]
        for index, button in enumerate(runtime.buttons):
            frame = runtime.objects[button].state["frame"]
            runtime.objects[button].state["frame"] = (
                4 + frame[2] * (len(runtime.buttons) - 1 - index), *frame[1:])
        runtime.defaults(**{ICONS: True, LENGTH: 80, HEIGHT: 90,
                            BUTTON_WIDTH: 75, COMPACT: True})
        repair(cpu, runtime, entries)
        centers = [runtime.objects[button].state["frame"][0] +
                   runtime.objects[button].state["frame"][2] / 2
                   for button in runtime.buttons]
        require(centers == sorted(centers, reverse=True),
                "Custom sizing preserves the host's reversed visual tab order")
        for title, button in zip(("书城", "短剧", "书架", "我的"), runtime.buttons):
            image = overlay_image(runtime, button)
            expected = {"书城": "house", "短剧": "play.rectangle",
                        "书架": "books.vertical", "我的": "person"}[title]
            require(image["symbol"].removesuffix(".fill") == expected,
                    "Reversed layout does not alter logical icon identity")
        send_pan(cpu, runtime, pan, 1)
        send_pan(cpu, runtime, pan, 2, (0., -60.))
        repair(cpu, runtime, entries)
        runtime.objects[runtime.owner].state["selectedIndex"] = 0
        repair(cpu, runtime, entries)
        require(not runtime.objects[pan].state["extra_targets"],
                "Leaving the drama tab removes its scroll observer")
        before_disable = host_geometry(runtime, (feed,))
        runtime.defaults(**{"FanqieAdBlock.GlassDisabled.1": 1})
        # Exercise both exported lifecycle boundaries even if the host invokes
        # them after global disable; neither may reapply customization.
        call(cpu, labels, "FQHBottomPrepare", runtime.BAR, runtime.PROXY, runtime.buttons_array)
        call(cpu, labels, "FQHBottomFinish", runtime.BAR, runtime.PROXY,
             runtime.buttons_array, runtime.control())
        require(runtime.objects[runtime.PROXY].state["frame"] == stock,
                "Global glass disable restores owned custom dimensions")
        require(runtime.objects[runtime.PROXY_CONTENT].state["frame"] ==
                runtime.objects[runtime.PROXY].state["bounds"],
                "Global disable keeps the public content view aligned with restored bounds")
        require(not any(overlays(runtime, button) for button in runtime.buttons),
                "Global glass disable restores original button presentation")
        require(host_geometry(runtime, (feed,)) == before_disable,
                "Global disable cannot rewrite host viewport or feed geometry")
        cases.append({"renderer": "fallback" if fallback else "native",
                      "reversed_order_preserved": True, "page_change_detaches": True,
                      "global_disable_restores": True})
    return cases


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), ENTRY_LABELS)
    report = {
        "passed": True, "sha256": hashlib.sha256(data).hexdigest(),
        "geometry": default_and_geometry(data, labels),
        "icons": icon_lifecycle(data, labels),
        "unknown_tabs": unknown_and_failure(data, labels),
        "scroll": scroll_lifecycle(data, labels),
        "scroll_rejections": scroll_rejections(data, labels),
        "preferences_and_reset": bounded_preferences_and_reset(data, labels),
        "settings_callbacks": setting_callbacks(data, labels),
        "direction_and_disable": layout_direction_and_disable(data, labels),
        "device_tested": False, "pixel_rendering_tested": False,
        "boundary": "Candidate ARM64; explicit Foundation/UIKit fixtures",
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
