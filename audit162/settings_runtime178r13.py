"""Exercise the R13 settings UI and local reward action in the ARM64 fixture."""
from arm64 import require
from test_control_glass166 import send
from test_controls171 import call

EXTRA_SETTINGS_LABELS = ["LFQD_FQDInitDiagnosticsPolicy", "LFQD_DiagnosticsEnabledKey"]


class SettingsBoundary178R13:
    def responds(self, receiver, name):
        if getattr(self, "settings_boundary", False):
            obj = self.objects[receiver]
            if name == "anyObject" and obj.cls == self.classes.get("NSHashTable"):
                return True
            if name == "lowercaseString" and obj.cls == self.classes.get("NSString"):
                return True
            if name in ("accessibilityIdentifier", "navigationItem") and name in obj.state:
                return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        if pc - self.slide != 0xa5d4 or not getattr(self, "settings_boundary", False):
            return super().handle(cpu, pc)
        receiver, selector, value = cpu.x[:3]
        name = self.selector_names.get(selector)
        classes = self.classes
        if receiver == classes["NSCharacterSet"] and name == "whitespaceAndNewlineCharacterSet":
            return self.finish(cpu, self.obj("NSCharacterSet", "whitespace"))
        if receiver == classes["UIImage"] and name == "systemImageNamed:":
            return self.finish(cpu, self.obj("UIImage", "settings search icon"))
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
        if receiver in self.objects:
            state = self.objects[receiver].state
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
            if name in ("navigationItem", "rightBarButtonItem", "accessibilityIdentifier"):
                return self.finish(cpu, state.get(name, 0))
            if name == "setSearchBarStyle:":
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
    runtime.objects[runtime.DEFAULTS].state["values"].pop("FanqieX.DiagnosticsEnabled", None)
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
    reward = next(v for v in descendants(footer)
                  if runtime.string_value(state(v).get("accessibilityLabel", 0)) == "模拟立即领取")
    reward_switch = next(v for v in descendants(footer)
                         if runtime.string_value(state(v).get("accessibilityLabel", 0)) == "听书奖励本地测试"
                         and runtime.is_kind(v, runtime.classes["UISwitch"]))
    diagnostic_switch = next(v for v in descendants(footer)
                             if runtime.string_value(state(v).get("accessibilityLabel", 0)) == "开启诊断"
                             and runtime.is_kind(v, runtime.classes["UISwitch"]))
    require(not state(diagnostic_switch)["isOn"], "Fresh installs must opt in to diagnostics")
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
                                   ("滚 收缩", "短剧滚动自动收缩", "默认最高画质"),
                                   ("听书奖励", "听书奖励本地测试", "默认清屏播放")):
        send(cpu, runtime, state(search)["delegate"], "searchBar:textDidChange:", search, runtime.text_object(query))
        require(shown(present) and not shown(absent), f"Search filters groups by fuzzy setting title: {query!r}")
    send(cpu, runtime, state(search)["delegate"], "searchBar:textDidChange:", search, runtime.text_object(""))
    require(shown("暂停时显示界面") and shown("短剧右侧互动按钮"), "Clearing search restores groups")
    runtime.objects[runtime.DEFAULTS].state["values"]["FanqieX.DiagnosticsEnabled"] = True
    diagnostic_owner = runtime.classes["SSReaderParagraphCommentAdapter"]
    cache_key = runtime.slide + labels["LFQD_DiagnosticsEnabledKey"]
    runtime.associations.pop((diagnostic_owner, cache_key), None)
    call(cpu, labels, "LFQD_FQDInitDiagnosticsPolicy")
    return [by_title[title] for title in [f"底栏显示：{title}" for title in titles] + [
        "书架显示今日看听读时长", "我的显示金币与福利卡片", "阅读菜单显示上下栏背景",
        "横屏画面铺满（等比裁切）", "书架显示筛选按钮", "书外主题跟随系统"]]
