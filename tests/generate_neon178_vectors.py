#!/usr/bin/env python3
"""Regenerate independent AdvSIMD vectors with LLVM and Unicorn.

This developer tool is not needed by CI. ``--check`` re-executes all checked-in
vectors without changing them; ``--write`` deliberately regenerates the file.
The oracle executes one actual ARM64 instruction with FPCR=0. It does not call
the local instruction interpreter or borrow its expected-value calculations.
"""
from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
import random
import struct
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "repair162"))
from macho_tools import assemble_object, sections


def fp_pair(a, b):
    return int.from_bytes(struct.pack("<2d", a, b), "little")


def base_register(index):
    return ((0x1111111111111111 + index) << 64) | (0xeeeeeeeeeeeeeeee - index)


def instructions():
    rng = random.Random(178)
    cases = []

    def add(assembly, values):
        cases.append((assembly, values))

    for dst_lane in (0, 1):
        for src_lane in (0, 1):
            for alias in (False, True):
                add(f"ins v0.d[{dst_lane}], v{0 if alias else 1}.d[{src_lane}]",
                    {0: rng.getrandbits(128), 1: rng.getrandbits(128)})
    for lane in (0, 1):
        for dst, src in ((0, 1), (31, 30), (1, 1)):
            add(f"dup v{dst}.2d, v{src}.d[{lane}]", {src: rng.getrandbits(128)})
            add(f"mov d{dst}, v{src}.d[{lane}]", {src: rng.getrandbits(128)})
    for value in ("0.5", "-0.5", "1.5", "-2.0", "31.0", "0.125"):
        add(f"fmov v31.2d, #{value}", {})
    masks = (0, (1 << 128)-1, int("aa"*16, 16), rng.getrandbits(128))
    for mask in masks:
        for left, right in ((1, 2), (0, 2), (1, 0)):
            values = {0: mask, 1: rng.getrandbits(128), 2: rng.getrandbits(128)}
            add(f"bsl v0.16b, v{left}.16b, v{right}.16b", values)
    numeric = ((0., -0.), (1.5, -2.75), (48., 323.3333333333333),
               (-1024.125, 0.0000152587890625))
    for a, b in numeric:
        for lane in (0, 1):
            add(f"fmul v2.2d, v3.2d, v17.d[{lane}]",
                {3: fp_pair(a, b), 17: fp_pair(3., 0.25)})
        add("fmul v0.2d, v0.2d, v0.d[0]", {0: fp_pair(a, b)})
        add("fadd v7.2d, v8.2d, v9.2d", {8: fp_pair(a, b), 9: fp_pair(-0.5, 0.5)})
        add("fadd v0.2d, v0.2d, v1.2d", {0: fp_pair(a, b), 1: fp_pair(0.5, -0.5)})
        add("fdiv v10.2d, v11.2d, v12.2d", {11: fp_pair(a, b), 12: fp_pair(3., -2.)})
        add("fdiv v0.2d, v1.2d, v0.2d", {0: fp_pair(3., 2.), 1: fp_pair(a, b)})
    comparisons = ((0., -0., -0., 0.), (1., -1., 1., 1.),
                   (float("inf"), float("-inf"), float("inf"), float("-inf")),
                   (float("nan"), -1., float("nan"), -1.))
    for a, b, c, d in comparisons:
        add("fcmeq v13.2d, v14.2d, v15.2d", {14: fp_pair(a, b), 15: fp_pair(c, d)})
        add("fcmeq v0.2d, v0.2d, v1.2d", {0: fp_pair(a, b), 1: fp_pair(c, d)})
        add("fcmlt v16.2d, v17.2d, #0.0", {17: fp_pair(a, b)})
    conversions = ((0., -0.), (79.6, -79.6), (0.999, -0.999),
                   (float(-(1 << 63)), math.nextafter(float(1 << 63), 0.)),
                   (float((1 << 52)-1), -float((1 << 52)-1)))
    for a, b in conversions:
        add("fcvtzs v18.2d, v19.2d", {19: fp_pair(a, b)})
        add("fcvtzs v0.2d, v0.2d", {0: fp_pair(a, b)})
        add("fcvtzs d22, d23", {23: fp_pair(a, b)})
        add("fcvtzs d0, d0", {0: fp_pair(b, a)})
    for a, b in ((0, -1), (79, -79), (-(1 << 63), (1 << 63)-1),
                 ((1 << 53)+1, -(1 << 53)-1)):
        pair = (a & ((1 << 64)-1)) | ((b & ((1 << 64)-1)) << 64)
        add("scvtf v20.2d, v21.2d", {21: pair})
        add("scvtf v0.2d, v0.2d", {0: pair})
        add("scvtf d24, d25", {25: pair})
        add("scvtf d0, d0", {0: pair})
    for index in range(12):
        a, b = rng.getrandbits(128), rng.getrandbits(128)
        if index == 0:
            a = 0x0123456789abcdeffedcba9876543210
        elif index == 1:
            a = (1 << 128)-1
        elif index == 2:
            a = ((1 << 64)-1) << 64
        add("uzp1 v26.4s, v27.4s, v28.4s", {27: a, 28: b})
        add("uzp1 v0.4s, v1.4s, v0.4s", {1: a, 0: b})
        add("not v29.16b, v30.16b", {30: a})
        add("xtn v0.4h, v1.4s", {1: a})
        add("xtn v0.4h, v0.4s", {0: a})
        add("umaxv h2, v3.4h", {3: a})
    return cases


def oracle_rows():
    import unicorn
    from unicorn import Uc, UC_ARCH_ARM64, UC_MODE_ARM
    from unicorn.arm64_const import (UC_ARM64_REG_Q0, UC_ARM64_REG_NZCV,
                                    UC_ARM64_REG_FPCR, UC_ARM64_REG_CPACR_EL1)
    cases = instructions()
    unique = list(dict.fromkeys(assembly for assembly, _ in cases))
    obj = assemble_object(".text\n" + "\n".join(unique) + "\n")
    section = next(section for section in sections(obj) if section["name"] == "__text")
    code = obj[section["offset"]:section["offset"] + section["size"]]
    assert len(code) == 4 * len(unique)
    encoded = {name: code[index*4:(index+1)*4] for index, name in enumerate(unique)}
    result = []
    for index, (assembly, inputs) in enumerate(cases):
        machine = Uc(UC_ARCH_ARM64, UC_MODE_ARM)
        machine.mem_map(0x10000, 0x1000)
        instruction = encoded[assembly]
        machine.mem_write(0x10000, instruction)
        machine.reg_write(UC_ARM64_REG_CPACR_EL1, 3 << 20)
        machine.reg_write(UC_ARM64_REG_FPCR, 0)
        nzcv = (index % 16) << 28
        machine.reg_write(UC_ARM64_REG_NZCV, nzcv)
        initial = [inputs.get(reg, base_register(reg)) for reg in range(32)]
        for reg, value in enumerate(initial):
            machine.reg_write(UC_ARM64_REG_Q0 + reg, value)
        machine.emu_start(0x10000, 0x10004, count=1)
        destination = int.from_bytes(instruction, "little") & 31
        actual = [machine.reg_read(UC_ARM64_REG_Q0 + reg) for reg in range(32)]
        assert all(actual[reg] == initial[reg] for reg in range(32) if reg != destination)
        assert machine.reg_read(UC_ARM64_REG_NZCV) == nzcv
        result.append({
            "assembly": assembly, "opcode": instruction.hex(),
            "inputs": {str(reg): f"{value:032x}" for reg, value in sorted(inputs.items())},
            "nzcv": index % 16, "destination": destination,
            "expected": f"{actual[destination]:032x}",
        })
    return {"oracle": "Unicorn " + unicorn.__version__ + " AArch64",
            "fpcr": 0, "scope": "Register values and unchanged NZCV; FPSR is not modeled",
            "vectors": result}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    parser.add_argument("--output", type=Path,
                        default=ROOT / "tests/fixtures/neon178_vectors.json")
    args = parser.parse_args()
    result = oracle_rows()
    if args.check:
        expected = json.loads(args.output.read_text())
        assert expected["vectors"] == result["vectors"], "Independent oracle vectors changed"
    else:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({"vectors": len(result["vectors"]), "oracle": result["oracle"],
                      "checked": args.check}))


if __name__ == "__main__":
    main()
