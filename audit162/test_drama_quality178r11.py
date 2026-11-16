#!/usr/bin/env python3
"""Execute R11 default quality selection in ARM64; engine/network stay host boundaries."""
import argparse
import hashlib
import json
from pathlib import Path

from arm64 import require
from test_control_glass166 import send
from test_controls171 import call
from test_feed_viewport import labels_for
from test_page_glass174 import EXTRA, Runtime as BaseRuntime, make

OWNER = "FQVShortVideoListVCPlayerComponent"
DATA = "FQVShortVideoDataModel"
ITEM = "FQVPlayerEngineDataResolutionItem"
VIDEO = "TTVideoEngineModel"
VARIANT = "TTVideoEngineURLInfo"
CONFIG = "FQVShortVideoListConfig"
KEY = "FanqieX.DramaHighestQuality.1"


class Runtime(BaseRuntime):
    QUALITY_HOST = 0x33252000

    def __init__(self, data):
        super().__init__(data)
        for cls in (OWNER, DATA, ITEM, VIDEO, VARIANT, CONFIG):
            self._class(cls, "NSObject")
        for cls, selector, signature in (
            (OWNER, "resolutionItemWithModel:", "@24@0:8@16"),
            (OWNER, "historyResolutionWithModel:", "@24@0:8@16"),
            (OWNER, "feedResolutionWithVideoId:", "@24@0:8@16"),
            (OWNER, "updatePlayer:resolution:model:finish:", "v48@0:8@16@24@32@?40"),
            (VIDEO, "videoInfoForType:", "@24@0:8Q16"),
            (VARIANT, "bitrate", "q16@0:8"),
            (ITEM, "setForceResolutionTypeNumber:", "v24@0:8@16"),
            (CONFIG, "feedType", "q16@0:8"),
        ):
            self._add(self.classes[cls], selector, self.QUALITY_HOST, signature)
        self.variant_queries = []
        self.manual_calls = []
        self.native_item_calls = 0

    def responds(self, receiver, name):
        if receiver in self.objects and name in self.objects[receiver].state:
            return True
        return super().responds(receiver, name)

    def handle(self, cpu, pc):
        receiver, selector, argument = cpu.x[:3]
        name = self.selector_names.get(selector)
        if pc == self.QUALITY_HOST:
            state = self.objects[receiver].state
            if name == "resolutionItemWithModel:":
                self.native_item_calls += 1
                model = self.objects[argument].state
                return self.finish(cpu, self.obj(ITEM, "fresh native default", videoModel=model.get("itemVideo", 0),
                                   forceResolutionTypeNumber=model.get("nativeForce", 0)))
            if name == "historyResolutionWithModel:":
                return self.finish(cpu, self.objects[argument].state.get("historyResolution", 0))
            if name == "feedResolutionWithVideoId:":
                return self.finish(cpu, state.get("feedResolution", 0))
            if name == "videoInfoForType:":
                self.variant_queries.append(argument)
                return self.finish(cpu, state["variants"].get(argument, 0))
            if name == "setForceResolutionTypeNumber:":
                state["forceResolutionTypeNumber"] = argument
                return self.finish(cpu)
            if name == "bitrate":
                return self.finish(cpu, state["bitrate"])
            if name == "feedType":
                return self.finish(cpu, state["feedType"])
            if name == "updatePlayer:resolution:model:finish:":
                self.manual_calls.append(tuple(cpu.x[2:6]))
                return self.finish(cpu)
        if pc - self.slide == 0xa5d4 and receiver in self.objects:
            state = self.objects[receiver].state
            if name in ("listVCContext", "config", "shortVideoModel", "videoData", "vid", "isVideoLocked", "videoModelDisabled",
                        "useDownloadedEngineData", "videoInfo", "videoModel", "supportedResolutionTypes",
                        "vWidth", "vHeight"):
                return self.finish(cpu, int(state.get(name, 0)))
        return super().handle(cpu, pc)


def exercise(data, labels):
    cpu, rt = make(data, Runtime)
    rt.labels = labels
    call(cpu, labels, "LFQH_FQHPageInstall")
    prefs = rt.objects[rt.DEFAULTS].state["values"]
    config = rt.obj(CONFIG, "root short-drama feed", feedType=4)
    context = rt.obj("NSObject", "native list context", config=config)
    owner = rt.obj(OWNER, "short-video native player component", listVCContext=context)
    low, high, same_pixels_low_bitrate = [rt.box(v) for v in (15, 2, 40)]
    absent = 90
    variants = {}
    for token, width, height, bitrate in ((15, 1280, 720, 1200000), (2, 1920, 1080, 5000000),
                                         (40, 1920, 1080, 3200000), (absent, 3840, 2160, 10000000)):
        variants[token] = rt.obj(VARIANT, str(token), vWidth=rt.box(width), vHeight=rt.box(height), bitrate=bitrate)
    allowed = rt.obj("NSArray", "current authorized available types", items=[same_pixels_low_bitrate, low, high])
    video = rt.obj(VIDEO, "current authorized video response", supportedResolutionTypes=allowed, variants=variants)
    info = rt.obj("NSObject", "current video info", videoModel=video)
    episode = rt.obj("NSObject", "episode data", vid=rt.box("video-one"))
    short_video = rt.obj("NSObject", "short-video host model", videoData=episode, isVideoLocked=False,
                         videoModelDisabled=False)
    model = rt.obj(DATA, "current model", shortVideoModel=short_video, videoInfo=info,
                   itemVideo=video, nativeForce=low, useDownloadedEngineData=False)

    def resolve(target=model):
        item = send(cpu, rt, owner, "resolutionItemWithModel:", target)["result"]
        return rt.objects[item].state["forceResolutionTypeNumber"]

    require(resolve() == low and not rt.variant_queries, "Unset preference leaves native quality and request work untouched")
    prefs[KEY] = True
    require(resolve() == high, "Pixel dimensions select the best available quality, not numeric enum order")
    require(absent not in rt.variant_queries and rt.objects[allowed].state["items"] == [same_pixels_low_bitrate, low, high],
            "Selection never probes an unavailable representation or changes the native supported list")
    require(rt.objects[model].state["videoInfo"] == info and rt.objects[info].state["videoModel"] == video,
            "The host video response and request object are preserved")
    for feed_type in (0, 5):
        rt.objects[config].state["feedType"] = feed_type
        query_count = len(rt.variant_queries)
        require(resolve() == low and len(rt.variant_queries) == query_count,
                "The same FQVShortVideoDataModel on a non-root feed keeps its native quality")
    rt.objects[config].state["feedType"] = 4
    rt.objects[context].state["config"] = rt.obj("NSObject", "unrelated config with matching number", feedType=4)
    require(resolve() == low, "A matching integer on an unrelated config class does not broaden the page scope")
    rt.objects[context].state["config"] = config

    rt.objects[model].state["historyResolution"] = low
    require(resolve() == low, "An existing native manual history choice takes precedence")
    rt.objects[model].state["historyResolution"] = 0
    rt.objects[owner].state["feedResolution"] = low
    require(resolve() == low, "The feed's explicit per-video selection takes precedence")
    rt.objects[owner].state["feedResolution"] = 0
    player = rt.obj("NSObject", "native player")
    finish = rt.obj("NSObject", "native completion block")
    send(cpu, rt, owner, "updatePlayer:resolution:model:finish:", player, 0, model, finish)
    require(rt.manual_calls == [(player, 0, model, finish)] and resolve() == low,
            "A manual Automatic choice is forwarded unchanged and is not overwritten later")
    rt.objects[episode].state["vid"] = rt.box("video-two")
    require(resolve() == high, "A reused model with a different video ID can use the default again")
    send(cpu, rt, owner, "updatePlayer:resolution:model:finish:", player, low, model, finish)
    require(rt.manual_calls[-1] == (player, low, model, finish) and resolve() == low,
            "An explicit manual resolution retains its native request and wins subsequent preparation")
    rt.objects[episode].state["vid"] = rt.box("video-three")

    for field in ("isVideoLocked", "videoModelDisabled"):
        rt.objects[short_video].state[field] = True
        require(resolve() == low, "Locked or unavailable video remains on the host path")
        rt.objects[short_video].state[field] = False
    rt.objects[model].state["useDownloadedEngineData"] = True
    require(resolve() == low, "Downloaded playback is not changed into a different network quality")
    rt.objects[model].state["useDownloadedEngineData"] = False
    rt.objects[model].state["itemVideo"] = rt.obj(VIDEO, "stale preload response")
    require(resolve() == low, "A stale preload response cannot determine current-video quality")
    rt.objects[model].state["itemVideo"] = video
    normal = rt.obj("NSObject", "non-short-video model", itemVideo=video, nativeForce=low)
    require(resolve(normal) == low, "A non-short-video model is left unchanged")

    rt.objects[allowed].state["items"] = []
    require(resolve() == low, "An absent available list preserves native resolution")
    rt.objects[allowed].state["items"] = [rt.box("invalid"), high]
    rt.objects[variants[2]].state["vWidth"] = rt.box(float("nan"))
    require(resolve() == low, "Invalid response dimensions do not create a guessed quality")
    prefs[KEY] = False
    require(resolve() == low, "Turning the option off immediately restores default selection for new preparation")
    return {"default_off": True, "highest_available_dimensions_and_bitrate": True,
            "native_requests_and_available_list_preserved": True, "manual_selection_preserved": True,
            "only_root_short_drama_feed": True,
            "stale_locked_downloaded_and_non_drama_unchanged": True,
            "invalid_metadata_uses_host_default": True}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    data = args.candidate.read_bytes()
    labels = labels_for(data, args.candidate.with_suffix(".composed.s"), EXTRA)
    report = {"passed": True, "candidate_sha256": hashlib.sha256(data).hexdigest(),
              **exercise(data, labels), "device_tested": False}
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf8")
    print(json.dumps(report, indent=2))
