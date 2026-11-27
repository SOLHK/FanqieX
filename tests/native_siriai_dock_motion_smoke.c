#include "../native/FQXSiriaiDockMotion.h"
#include <assert.h>
#include <stdio.h>

// 1. Complete DYe siriai_dock_motion_test.c verification suite
static void check_centered_dock(double screen, double capsule, double capsuleHeight, double camera, double bottomLimit) {
    double gap = camera > 0.0 ? 8.0 : 0.0;
    double width = capsule + gap + camera;
    double left = (screen - width) / 2.0;
    double previous = width;
    double previousGlyph = 1.0;
    for (int sample = 0; sample <= 1000; sample++) {
        double p = sample / 1000.0;
        DKSiriaiDockGeometry shape = DKSiriaiDockShape(capsule, capsuleHeight, camera, gap, bottomLimit, p);
        double groupLeft = left + shape.centerX - shape.width / 2.0;
        double groupRight = camera > 0.0 ? left + shape.cameraX + camera * shape.cameraScale / 2.0
                                         : groupLeft + shape.width;
        assert(fabs((groupLeft + groupRight) / 2.0 - screen / 2.0) < 1e-9);
        assert(shape.width > 0.0 && shape.height > 0.0 && shape.surfaceAlpha == 1.0);
        assert(shape.whiteAmount == 0.0);
        assert(groupRight - groupLeft <= previous + 1e-9);
        assert(shape.centerY + shape.height / 2.0 <= bottomLimit + 1e-9);
        assert(shape.cameraY + camera * shape.cameraScale / 2.0 <= bottomLimit + 1e-9);
        assert(shape.glyphScale >= 0.0 && shape.glyphScale <= previousGlyph + 1e-9);
        if (p >= 0.48) assert(shape.captionAmount == 0.0);
        previousGlyph = shape.glyphScale;
        previous = groupRight - groupLeft;
    }
    DKSiriaiDockGeometry line = DKSiriaiDockShape(capsule, capsuleHeight, camera, gap, bottomLimit, 1.0);
    DKSiriaiDockGeometry tint = DKSiriaiDockShape(capsule, capsuleHeight, camera, gap, bottomLimit, 1.08);
    DKSiriaiDockGeometry white = DKSiriaiDockShape(capsule, capsuleHeight, camera, gap, bottomLimit, DKSiriaiWhiteProgress);
    DKSiriaiDockGeometry fade = DKSiriaiDockShape(capsule, capsuleHeight, camera, gap, bottomLimit, 1.25);
    DKSiriaiDockGeometry hidden = DKSiriaiDockShape(capsule, capsuleHeight, camera, gap, bottomLimit, DKSiriaiHiddenProgress);
    DKSiriaiDockGeometry almost = DKSiriaiDockShape(capsule, capsuleHeight, camera, gap, bottomLimit, nextafter(1.0, 0.0));
    assert(almost.whiteAmount == 0.0 && almost.surfaceAlpha == 1.0);
    assert(line.contentAlpha == 0.0 && line.whiteAmount == 0.0 && line.surfaceAlpha == 1.0);
    assert(fabs(tint.whiteAmount - 0.5) < 1e-9 && tint.surfaceAlpha == 1.0);
    assert(white.whiteAmount == 1.0 && white.surfaceAlpha == 1.0);
    assert(fade.whiteAmount == 1.0 && hidden.whiteAmount == 1.0);
    assert(fabs(left + line.centerX - screen / 2.0) < 1e-9 && fabs(line.width - width * 0.141) < 1e-9);
    assert(fade.surfaceAlpha > 0.0 && fade.surfaceAlpha < 1.0 && hidden.surfaceAlpha == 0.0);
    assert(line.centerX == tint.centerX && line.centerY == tint.centerY && line.width == tint.width && line.height == tint.height);
    assert(line.centerX == hidden.centerX && line.centerY == hidden.centerY && line.width == hidden.width);

    double firstOpening = 1.0 - DKSiriaiGeometryProgress(0.99);
    assert(firstOpening > 0.0 && firstOpening < 0.005);
    assert(DKSiriaiGeometryProgress(0.01) > 0.0 && DKSiriaiGeometryProgress(0.01) < 0.007);
    DKSiriaiDockGeometry compact = DKSiriaiDockShape(capsule, capsuleHeight, camera, gap, bottomLimit, 0.48);
    double rowRatio = (compact.width + (camera + gap) * compact.cameraScale) / width;
    assert(rowRatio > 0.79 && rowRatio < 0.82);
    assert(compact.height / capsuleHeight > 0.78 && compact.height / capsuleHeight < 0.82);
    assert(compact.glyphScale > 0.89 && compact.glyphScale < 0.93);
    assert(compact.captionAmount == 0.0 && compact.contentAlpha == 1.0);
    if (!camera) assert(fabs(compact.centerY - capsuleHeight * 0.5) < 2.5);

    for (int i = 0; i < 3; i++) {
        const double start = (double[]){1.08, DKSiriaiWhiteProgress, DKSiriaiHiddenProgress}[i];
        DKSiriaiDockGeometry initial = DKSiriaiDockShape(capsule, capsuleHeight, camera, gap, bottomLimit, start);
        double material = DKSiriaiMaterialAfterTravel(start, 1.0, 1.0);
        DKSiriaiDockGeometry pickedUp = line;
        DKSiriaiSetDockMaterial(&pickedUp, material);
        assert(pickedUp.width == initial.width && pickedUp.whiteAmount == initial.whiteAmount);
        assert(pickedUp.surfaceAlpha == initial.surfaceAlpha);

        material = DKSiriaiMaterialAfterTravel(material, 1.0, 0.99);
        DKSiriaiDockGeometry reopening = DKSiriaiDockShape(capsule, capsuleHeight, camera, gap, bottomLimit, 0.99);
        DKSiriaiSetDockMaterial(&reopening, material);
        assert(reopening.width > line.width);
        if (start <= DKSiriaiWhiteProgress) {
            assert(reopening.whiteAmount > 0.0 && reopening.whiteAmount < initial.whiteAmount);
        } else {
            assert(reopening.surfaceAlpha > 0.0);
        }

        double reversing = DKSiriaiMaterialAfterTravel(material, 0.99, 1.0);
        assert(reversing <= material);
        DKSiriaiDockGeometry shrunkAgain = DKSiriaiDockShape(capsule, capsuleHeight, camera, gap, bottomLimit, 1.0);
        DKSiriaiSetDockMaterial(&shrunkAgain, reversing);
        assert(shrunkAgain.width == line.width && shrunkAgain.whiteAmount <= reopening.whiteAmount);
        assert(DKSiriaiMaterialAfterTravel(reversing, 1.0, 0.90) == 1.0);
    }
}

static void check_follow(double hz) {
    double dt = 1.0 / hz;
    double shown = 0.0, velocity = 0.0;
    for (int i = 0; i < hz / 2; i++) {
        double next = DKFeedFollowStep(shown, 0.55, &velocity, dt, 1);
        assert(next >= shown && next <= 0.55 && next - shown <= 6.0 * dt + 1e-9);
        if (!i) assert(next > 0.0 && next < 0.55);
        shown = next;
    }
    assert(shown == 0.55 && velocity == 0.0);
    shown = DKFeedFollowStep(shown, 1.0, &velocity, dt, 1);
    assert(velocity > 0.0);
    double back = DKFeedFollowStep(shown, shown - 0.01, &velocity, dt, 1);
    assert(back < shown && back > shown - 0.01 && velocity < 0.0);
    shown = velocity = 0.0;
    for (int i = 1; i <= hz; i++) {
        double target = 0.5 * i * dt;
        shown = DKFeedFollowStep(shown, target, &velocity, dt, 1);
        assert(shown <= target && target - shown < 0.02);
    }
}

static void check_fast_tracking(double hz) {
    double dt = 1.0 / hz;
    double speed = 0.0;
    double inputTimeLeft = 0.0;
    if (hz >= 60.0) {
        int ticks = (int)(hz / 30.0);
        double seen = 0.4;
        inputTimeLeft = ticks * dt;
        for (int i = 1; i <= ticks; i++) {
            seen = DKFeedSampleInput(seen, 0.42, dt, &inputTimeLeft);
            assert(fabs(seen - (0.4 + 0.02 * i / ticks)) < 1e-12);
        }
        assert(fabs(DKFeedSampleInput(seen, 0.42, dt, &inputTimeLeft) - 0.42) < 1e-12);
    }
    for (int sign = -1; sign <= 1; sign += 2) {
        double previous = 0.0;
        for (int i = 1; i <= 240; i++) {
            double input = i * 0.05 * dt;
            double target = 0.5 + sign * input;
            double shown = DKFeedDirectStep(0.5, target, &speed, dt);
            double movement = sign * (shown - 0.5);
            if (i <= 108) assert(movement >= 0.70 * input && movement < input);
            assert(movement >= previous && movement <= 6.0 * dt + 1e-12);
            assert(fabs(speed * dt - sign * movement) < 1e-12);
            previous = movement;
        }
    }
    double shown = 0.5;
    for (int i = 0; i < 8; i++) {
        double direction = i % 2 ? -1.0 : 1.0;
        double input = (i % 3 == 0 ? 6.1 : 5.9) * dt;
        double next = DKFeedDirectStep(shown, shown + direction * input, &speed, dt);
        assert(direction * (next - shown) > 0.90 * input);
        shown = next;
    }
    double target = shown + 0.003;
    for (int i = 0; i < 16; i++) shown = DKFeedDirectStep(shown, target, &speed, dt);
    assert(shown == target);
}

static void check_release(double hz) {
    const double dt = 1.0 / hz;
    const double splice = 1.0 / 30.0;
    const double h = 1e-6;
    for (int end = 0; end <= 1; end++) {
        double sign = end == 1 ? 1.0 : -1.0;
        DKFeedReleaseMotion aligned = DKFeedMakeReleaseMotion(0.5, end, sign * 0.12, 0.0);
        double lastCoastStep = DKFeedReleaseSample(aligned, end, splice)
            - DKFeedReleaseSample(aligned, end, splice - dt);
        assert(lastCoastStep * sign > 0.85 * 0.12 * dt);
        double extent = sign * 0.02;
        double lower = fmin(0.0, extent), upper = 1.0 + fmax(0.0, extent);
        double from = end + sign * 0.008;
        assert(DKFeedMakeReleaseMotion(from, end, 0.0, extent).duration == 0.0);
        DKFeedReleaseMotion blocked = DKFeedMakeReleaseMotion(end + extent, end, sign, extent);
        assert(blocked.duration == 0.0 && DKFeedReleaseSample(blocked, end, dt) == end);
        for (int i = 0; i < 4; i++) {
            double velocity = sign * (double[]){0.005, -0.005, 12.0, -12.0}[i];
            DKFeedReleaseMotion motion = DKFeedMakeReleaseMotion(from, end, velocity, extent);
            assert(motion.duration > splice && motion.coastTime > 0.0);
            assert(fabs(motion.velocity) == fmin(6.0, fabs(velocity)));
            assert(DKFeedReleaseSample(motion, end, 0.0) == from);
            double first = DKFeedReleaseSample(motion, end, dt);
            assert((first - from) * velocity > 0.0);
            double expected = from - motion.velocity * motion.coastTime * expm1(-dt / motion.coastTime);
            assert(fabs(first - expected) <= 1e-12);
            for (int frame = 1; frame <= (int)ceil(motion.duration * hz); frame++) {
                double shown = DKFeedReleaseSample(motion, end, frame * dt);
                assert(shown >= lower - 1e-12 && shown <= upper + 1e-12);
                if (sign * velocity < 0.0) assert(sign * (shown - end) >= -1e-12);
            }
            double at = DKFeedReleaseSample(motion, end, splice);
            double before = DKFeedReleaseSample(motion, end, splice - h);
            double after = DKFeedReleaseSample(motion, end, splice + h);
            assert(fabs((after - at) / h - (at - before) / h) < 0.001);
            assert(fabs(DKFeedReleaseSample(motion, end, motion.duration - h) - end) / h < 1e-6);
            assert(DKFeedReleaseSample(motion, end, motion.duration) == end);
        }
    }
}

static void check_landing(double end, double hz) {
    const double direction = end == 1.0 ? 1.0 : -1.0;
    const double peakTime = 1.0 / 12.0;
    const double peak = end + direction * 0.04;
    const double dt = 1.0 / hz;
    for (int start = 0; start < 3; start++) {
        double from = end - direction * (double[]){0.12, 0.035, 0.0}[start];
        for (int v = 0; v < 4; v++) {
            double velocity = direction * (double[]){-1.0, 0.0, 0.6, 6.0}[v];
            assert(DKFeedLandingSample(from, end, velocity, 0.0) == from);
            assert(DKFeedLandingSample(from, end, velocity, peakTime) == peak);
            assert(DKFeedLandingSample(from, end, velocity, DKFeedLandingDuration) == end);
            const double h = 1e-5;
            double before = DKFeedLandingSample(from, end, velocity, peakTime - h);
            double after = DKFeedLandingSample(from, end, velocity, peakTime + h);
            double curvatureBefore = (peak - 2.0 * before
                + DKFeedLandingSample(from, end, velocity, peakTime - 2.0 * h)) / (h * h);
            double curvatureAfter = (peak - 2.0 * after
                + DKFeedLandingSample(from, end, velocity, peakTime + 2.0 * h)) / (h * h);
            assert(fabs(before - peak) / h < 0.0002 && fabs(after - peak) / h < 0.0002);
            assert(fabs(curvatureBefore + direction * 12.0) < 0.1);
            assert(fabs(curvatureAfter - curvatureBefore) < 0.1);
            if (direction * velocity < 1.0) {
                double entrySpeed = (DKFeedLandingSample(from, end, velocity, h) - from) / h;
                assert(fabs(entrySpeed - direction * fmax(0.0, direction * velocity)) < 0.002);
            }
            double last = from, sampledPeak = 0.0;
            int returning = 0;
            for (int i = 1; i <= (int)ceil(DKFeedLandingDuration * hz); i++) {
                double sample = DKFeedLandingSample(from, end, velocity, i * dt);
                double outward = direction * (sample - end);
                assert(outward <= 0.04 + 1e-10 && direction * (sample - from) >= -1e-10);
                if (direction * (sample - last) < 0.0) returning = 1;
                if (returning) assert(direction * (sample - last) <= 1e-10);
                sampledPeak = fmax(sampledPeak, outward);
                last = sample;
            }
            assert(returning && sampledPeak > 0.035 && last == end);
            double backAt4 = (peak - DKFeedLandingSample(from, end, velocity, peakTime + 4.0 / 60.0)) / (peak - end);
            double backAt6 = (peak - DKFeedLandingSample(from, end, velocity, peakTime + 6.0 / 60.0)) / (peak - end);
            assert(backAt4 >= 0.39 && backAt4 <= 0.50);
            assert(backAt6 >= 0.63 && backAt6 <= 0.75);
            double nextVelocity = 0.0;
            double next = DKFeedFollowStep(peak, end - direction * 0.01, &nextVelocity, dt, 1);
            assert(direction * (next - peak) < 0.0 && direction * (nextVelocity) < 0.0);
            assert(direction * (next - end) > -0.01);
        }
    }
}

static void check_landing_tail(double end) {
    const double peakTime = 1.0 / 12.0;
    double amplitude = end == 1.0 ? 0.04 : -0.04;
    double from = end - 2.0 * amplitude;
    for (int i = 0; i <= 6; i++) {
        double t = i * 0.01;
        double u = t / 0.20;
        double remaining = 1.0 - u;
        double expected = end + amplitude * remaining * remaining * remaining * (1.0 + 3.0 * u);
        assert(fabs(DKFeedLandingSample(from, end, 0.0, peakTime + t) - expected) < 1e-12);
    }
    const double low[] = {0.118, 0.050, 0.024, 0.014};
    const double high[] = {0.180, 0.130, 0.085, 0.043};
    for (int i = 0; i < 4; i++) {
        double pose = DKFeedLandingSample(from, end, 0.0, peakTime + (8 + i) / 60.0);
        double fraction = (pose - end) / amplitude;
        assert(fraction >= low[i] && fraction <= high[i]);
    }
    double at12 = (DKFeedLandingSample(from, end, 0.0, peakTime + 12.0 / 60.0) - end) / amplitude;
    double at13 = (DKFeedLandingSample(from, end, 0.0, peakTime + 13.0 / 60.0) - end) / amplitude;
    assert(at12 > 0.0 && at12 < 0.007 && at13 > 0.0 && at13 < at12 * 0.01);
    double fourMs = (DKFeedLandingSample(from, end, 0.0, DKFeedLandingDuration - 0.004) - end) / amplitude;
    double twoMs = (DKFeedLandingSample(from, end, 0.0, DKFeedLandingDuration - 0.002) - end) / amplitude;
    assert(twoMs > 0.0 && twoMs < fourMs / 32.0);
    assert(DKFeedLandingSample(from, end, 0.0, peakTime + 0.22) == end);
}

static void check_rebound_shape(double capsule, double camera, double bottomLimit) {
    double gap = camera > 0.0 ? 8.0 : 0.0;
    double width = capsule + gap + camera;
    for (int end = 0; end <= 1; end++) {
        DKSiriaiDockGeometry rest = DKSiriaiDockShape(capsule, 62.0, camera, gap, bottomLimit, end);
        DKSiriaiDockGeometry shape = rest;
        DKSiriaiApplyRebound(&shape, end == 1 ? 0.04 : -0.04, width, camera, bottomLimit);
        double left = shape.centerX - shape.width * 0.5;
        double right = camera > 0.0 ? shape.cameraX + camera * shape.cameraScale * 0.5 : left + shape.width;
        double restGroup = rest.width + (camera + gap) * rest.cameraScale;
        double outward = end == 1 ? 1e-6 : -1e-6;
        DKSiriaiDockGeometry inside = DKSiriaiDockShape(capsule, 62.0, camera, gap, bottomLimit, end - outward);
        DKSiriaiDockGeometry outside = rest;
        DKSiriaiApplyRebound(&outside, outward, width, camera, bottomLimit);
        double insideSpan = inside.width;
        double outsideSpan = outside.width;
        if (camera > 0.0) {
            insideSpan = inside.cameraX + camera * inside.cameraScale * 0.5 - (inside.centerX - inside.width * 0.5);
            outsideSpan = outside.cameraX + camera * outside.cameraScale * 0.5 - (outside.centerX - outside.width * 0.5);
        }
        double approachSlope = (restGroup - insideSpan) / outward;
        double reboundSlope = (outsideSpan - restGroup) / outward;
        assert(approachSlope < 0.0 && fabs(approachSlope - reboundSlope) < 0.01);
        assert(fabs((left + right) * 0.5 - width * 0.5) < 1e-9);
        assert(fabs((right - left) / restGroup - (end == 1 ? 0.988 : 1.0076)) < 1e-9);
        assert(shape.glyphScale == rest.glyphScale && shape.captionAmount == rest.captionAmount);
        assert(shape.whiteAmount == 0.0 && shape.surfaceAlpha == 1.0 && shape.height > 0.0);
        assert(shape.centerY - shape.height * 0.5 >= -1e-9);
        assert(shape.centerY + shape.height * 0.5 <= bottomLimit + 1e-9);
        if (camera > 0.0) {
            double r = camera * shape.cameraScale * 0.5;
            assert(shape.cameraY - r >= -1e-9 && shape.cameraY + r <= bottomLimit + 1e-9);
            assert(shape.cameraX - r >= shape.centerX + shape.width * 0.5 - 1e-9);
        }
    }
}

// 2. FanqieX TikTok + DetachedDock + Pan + Spring + Mode Mutual Exclusion
static void check_fanqiex_modes_and_motion(void) {
    // Mode migration & mutual exclusion helper
    assert(FQXResolveDockCollapseMode(-1, 0, 0) == FQXDockCollapseModeOff);
    assert(FQXResolveDockCollapseMode(-1, 1, 0) == FQXDockCollapseModeLegacy);
    assert(FQXResolveDockCollapseMode(-1, 0, 1) == FQXDockCollapseModeTikTok);
    assert(FQXResolveDockCollapseMode(FQXDockCollapseModeSiriai, 1, 1) == FQXDockCollapseModeSiriai);

    // 3-tab capsule + FQXDetachedDockButtonView (circleD = 62, gap = 10 on 390pt screen)
    double capsuleX = 16.0, capsuleY = 10.0, capsuleW = 286.0, capsuleH = 62.0;
    double circleD = 62.0, gap = 10.0, circleMidY = 41.0;
    double groupW = capsuleW + gap + circleD;
    double groupMidX = capsuleX + groupW * 0.5;

    DKSiriaiDockGeometry compact = DKTikTokDockShape(capsuleX, capsuleY, capsuleW, capsuleH,
                                                     circleMidY, circleD, gap, 3, 1.0);
    double left = compact.centerX - compact.width * 0.5;
    double right = compact.cameraX + circleD * compact.cameraScale * 0.5;
    assert(fabs((right - left) - groupW * 0.81) < 1e-9);
    assert(fabs((left + right) * 0.5 - groupMidX) < 1e-9);
    assert(fabs(compact.height - capsuleH * 0.80) < 1e-9);
    assert(fabs(compact.glyphScale - 0.91) < 1e-9);
    assert(compact.captionAmount == 0.0);
    assert(fabs(compact.cameraScale - 0.80) < 1e-9);

    // Minimum hit-width protection (itemCount * 44pt) when capsule is narrow
    double narrowCompactW = DKFeedCompactCapsuleWidth(180.0, 62.0, 10.0, 4);
    assert(fabs(narrowCompactW - 176.0) < 1e-9);

    // Hit-test pass-through for shrunk TikTok Dock and compressed/hidden Siri AI Dock
    double shrunkCapX = left, shrunkCapY = compact.centerY - compact.height * 0.5;
    double shrunkCamR = circleD * compact.cameraScale * 0.5;
    double shrunkCamX = compact.cameraX - shrunkCamR, shrunkCamY = compact.cameraY - shrunkCamR;
    double shrunkCamD = circleD * compact.cameraScale;
    assert(DKFeedAllowsHit(1.0, 0, 0, compact.centerX, compact.centerY,
                           shrunkCapX, shrunkCapY, compact.width, compact.height,
                           1, shrunkCamX, shrunkCamY, shrunkCamD, shrunkCamD) == 1);
    assert(DKFeedAllowsHit(1.0, 0, 0, compact.cameraX, compact.cameraY,
                           shrunkCapX, shrunkCapY, compact.width, compact.height,
                           1, shrunkCamX, shrunkCamY, shrunkCamD, shrunkCamD) == 1);
    // Shrunk left margin & capsule-circle gap pass through to video / progress bar
    assert(DKFeedAllowsHit(1.0, 0, 0, capsuleX + 2.0, compact.centerY,
                           shrunkCapX, shrunkCapY, compact.width, compact.height,
                           1, shrunkCamX, shrunkCamY, shrunkCamD, shrunkCamD) == 0);
    assert(DKFeedAllowsHit(1.0, 0, 0, shrunkCapX + compact.width + 4.0, compact.centerY,
                           shrunkCapX, shrunkCapY, compact.width, compact.height,
                           1, shrunkCamX, shrunkCamY, shrunkCamD, shrunkCamD) == 0);
    // Siri AI thin line / faded line (`controlsHidden == 1`) passes all touches through
    assert(DKFeedAllowsHit(1.0, 1, 1, compact.centerX, compact.centerY,
                           shrunkCapX, shrunkCapY, compact.width, compact.height,
                           1, shrunkCamX, shrunkCamY, shrunkCamD, shrunkCamD) == 0);

    // Pan state machine: 4pt deadzone, 1.2x vertical lock, hysteresis, and flick projection
    DKFeedPanState pan;
    double deltaP = 0.0, endVelP = 0.0;
    int endCompact = 0, locked = 0;
    DKFeedPanBegin(&pan, 844.0, 0, 0, 0, 0.0, 0.0, 1);
    // Horizontal top-category / progress drag rejected by 1.2x ratio lock
    assert(DKFeedPanUpdate(&pan, -24.0, -20.0, 0.0, 0, &deltaP, &endCompact, &endVelP, &locked) == DKFeedPanIgnored);
    assert(!locked && deltaP == 0.0);
    assert(DKFeedPanUpdate(&pan, -30.0, -22.0, -200.0, 1, &deltaP, &endCompact, &endVelP, &locked) == DKFeedPanFinishedUnlocked);

    // Sub-4pt jitter ignored, >4pt vertical locks and drives progress; <4pt reversal keeps compact target
    DKFeedPanBegin(&pan, 844.0, 0, 0, 0, 0.0, 0.0, 1);
    assert(DKFeedPanUpdate(&pan, 0.0, -3.5, 0.0, 0, &deltaP, &endCompact, &endVelP, &locked) == DKFeedPanIgnored);
    assert(DKFeedPanUpdate(&pan, 1.0, -18.0, 0.0, 0, &deltaP, &endCompact, &endVelP, &locked) == DKFeedPanMoved);
    assert(locked && deltaP > 0.0);
    // Tiny +2.5pt jitter moves progress slightly back, but endpoint remains compact=1
    assert(DKFeedPanUpdate(&pan, 1.0, -15.5, 0.0, 1, &deltaP, &endCompact, &endVelP, &locked) == DKFeedPanEnded);
    assert(deltaP < 0.0 && endCompact == 1);

    // Caught in-flight motion uses 0pt deadzone and subtracts initial Began translation
    DKFeedPanBegin(&pan, 844.0, 1, 1, 1, 5.0, 12.0, 1);
    assert(DKFeedPanUpdate(&pan, 5.0, 14.0, 180.0, 1, &deltaP, &endCompact, &endVelP, &locked) == DKFeedPanEnded);
    assert(locked && deltaP < 0.0 && endCompact == 0);

    // Siri AI full lifecycle: compress -> whiten (0.14s) -> 1.4s delay -> fade (0.18s) -> pull-down recovery
    DKFeedSpringState siriai;
    DKFeedSpringInit(&siriai);
    siriai.siriai = 1;
    siriai.siriaiHidesLine = 1;
    double sp = 0.0;
    int sApply = 0, sFin = 0, sStart = 0, sFade = 0;
    DKFeedSpringSetCompact(&siriai, 1, 1, 10.0, 0, 1, &sp, &sFin, &sStart, &sFade);
    assert(sStart && !sFin);
    double clock = 10.0;
    int safety = 0;
    while (safety++ < 240) {
        DKFeedAdvanceResult r = DKFeedSpringAdvance(&siriai, clock, clock + 1.0 / 60.0, 0, &sp, &sApply, &sFade);
        clock += 1.0 / 60.0;
        if (r == DKFeedAdvanceFinished) break;
    }
    assert(fabs(siriai.progress - DKSiriaiWhiteProgress) < 1e-9 && sFade == 1);
    uint64_t ticket = siriai.siriaiFadeGeneration;
    assert(DKFeedSpringTriggerSiriaiFade(&siriai, ticket) == 1);
    safety = 0;
    while (safety++ < 120) {
        DKFeedAdvanceResult r = DKFeedSpringAdvance(&siriai, clock, clock + 1.0 / 60.0, 0, &sp, &sApply, &sFade);
        clock += 1.0 / 60.0;
        if (r == DKFeedAdvanceFinished) break;
    }
    assert(fabs(siriai.progress - DKSiriaiHiddenProgress) < 1e-9);
    // Pull-down recovery from invisible hidden line picks up material and expands smoothly
    DKFeedSpringBeginDrag(&siriai, 0);
    assert(fabs(siriai.siriaiOpeningMaterial - DKSiriaiHiddenProgress) < 1e-9 && siriai.progress == 1.0);
    DKFeedSpringMoveDrag(&siriai, -0.35, clock + 0.01, 1.0 / 60.0, 1);
    DKFeedSpringAdvance(&siriai, clock + 0.01, clock + 0.01 + 1.0 / 60.0, 0, &sp, &sApply, &sFade);
    assert(sp < 1.0 && siriai.siriaiOpeningMaterial < DKSiriaiHiddenProgress);
    DKFeedSpringEndDrag(&siriai, 0, -2.0, clock + 0.03, 1.0 / 60.0, 1, 1, &sp, &sFin, &sStart, &sFade);
    safety = 0;
    while (safety++ < 240) {
        DKFeedAdvanceResult r = DKFeedSpringAdvance(&siriai, clock, clock + 1.0 / 60.0, 0, &sp, &sApply, &sFade);
        clock += 1.0 / 60.0;
        if (r == DKFeedAdvanceFinished) break;
    }
    assert(siriai.compact == 0 && siriai.progress == 0.0 && siriai.siriaiOpeningMaterial == 1.0);

    // Pan state machine + 2 reversals endpoint override across DisplayLink ticks
    DKFeedSpringState s;
    DKFeedSpringInit(&s);
    double progress = 0.0;
    int apply = 0, finished = 0, startLink = 0, scheduleFade = 0;
    assert(!DKFeedSpringBeginDrag(&s, 0));
    assert(DKFeedSpringMoveDrag(&s, 0.30, 1.00, 1.0 / 60.0, 0));
    DKFeedSpringAdvance(&s, 1.00, 1.00 + 1.0 / 60.0, 0, &progress, &apply, &scheduleFade);
    assert(DKFeedSpringMoveDrag(&s, -0.05, 1.02, 1.0 / 60.0, 0));
    DKFeedSpringAdvance(&s, 1.02, 1.02 + 1.0 / 60.0, 0, &progress, &apply, &scheduleFade);
    assert(DKFeedSpringMoveDrag(&s, 0.12, 1.04, 1.0 / 60.0, 0));
    assert(s.dragReversals >= 2);
    // Even if pan target passed compact=0, 2+ reversals with positive speed chooses compact=1
    DKFeedSpringEndDrag(&s, 0, 1.8, 1.05, 1.0 / 60.0, 1, 1, &progress, &finished, &startLink, &scheduleFade);
    assert(s.compact == 1);

    // Page switch / comment sheet / landscape immediate reset (`animated == 0`)
    DKFeedSpringSetCompact(&s, 0, 0, 1.10, 0, 1, &progress, &finished, &startLink, &scheduleFade);
    assert(finished && s.compact == 0 && s.progress == 0.0 && s.overtravel == 0.0);
}

int main(void) {
    check_centered_dock(440.0, 324.0, 62.0, 0.0, 83.0);
    check_centered_dock(375.0, 254.0, 62.0, 52.0, 80.0);
    check_centered_dock(440.0, 300.0, 56.0, 76.0, 83.0);
    check_follow(30.0);
    check_follow(60.0);
    check_follow(120.0);
    check_fast_tracking(30.0);
    check_fast_tracking(60.0);
    check_fast_tracking(120.0);
    check_release(30.0);
    check_release(60.0);
    check_release(120.0);
    for (int end = 0; end <= 1; end++) {
        check_landing(end, 30.0);
        check_landing(end, 60.0);
        check_landing(end, 120.0);
        check_landing_tail(end);
    }
    check_rebound_shape(324.0, 0.0, 83.0);
    check_rebound_shape(254.0, 52.0, 80.0);
    check_rebound_shape(300.0, 76.0, 76.0);
    check_fanqiex_modes_and_motion();
    puts("PASS: FanqieX DYe TikTok + Siri AI motion, gesture state machine, detached circle sync, and mutual exclusion");
    return 0;
}
