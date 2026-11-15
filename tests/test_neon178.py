"""Mandatory, dependency-free instruction checks using independent oracle data.

The checked-in values come from LLVM-assembled instructions executed by Unicorn,
not from this repository's Python interpreter. The generator is a separate,
explicit developer tool; missing Unicorn never skips these CI assertions.
"""
import json
from pathlib import Path
import struct
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "audit162"))
from arm64 import CPU


class Boundary:
    def handle(self, cpu, pc):
        return False


class GeometrySIMD(unittest.TestCase):
    def test_independent_unicorn_vectors(self):
        fixture = json.loads((ROOT / "tests/fixtures/neon178_vectors.json").read_text())
        self.assertGreaterEqual(len(fixture["vectors"]), 150)
        for row in fixture["vectors"]:
            with self.subTest(assembly=row["assembly"], inputs=row["inputs"]):
                instruction = bytes.fromhex(row["opcode"])
                cpu = CPU(instruction, Boundary())
                cpu.v = [((0x1111111111111111 + reg) << 64) |
                         (0xeeeeeeeeeeeeeeee - reg) for reg in range(32)]
                for register, value in row["inputs"].items():
                    cpu.v[int(register)] = int(value, 16)
                expected = cpu.v[:]
                expected[row["destination"]] = int(row["expected"], 16)
                cpu.flags_imm(row["nzcv"])
                flags = (cpu.n, cpu.z, cpu.c, cpu.overflow)
                cpu.step()
                self.assertEqual(cpu.v, expected)
                self.assertEqual((cpu.n, cpu.z, cpu.c, cpu.overflow), flags)
                self.assertEqual(cpu.pc, 4)

    def test_exceptional_conversions_fail_closed(self):
        for op in (0x4ee1b800, 0x5ee1b800):
            for value in (float("nan"), float("inf"), float("-inf"), float(1 << 63)):
                with self.subTest(op=hex(op), value=str(value)):
                    cpu = CPU(struct.pack("<I", op), Boundary())
                    cpu.v[0] = int.from_bytes(struct.pack("<2d", value, 1.), "little")
                    with self.assertRaisesRegex(AssertionError, "FCVTZS SIMD operand"):
                        cpu.step()

    def test_exceptional_arithmetic_fail_closed(self):
        # FDIV V0.2D,V1.2D,V2.2D must not silently approximate exception state.
        for divisor in (0., float("nan"), float("inf")):
            with self.subTest(divisor=str(divisor)):
                cpu = CPU(struct.pack("<I", 0x6e62fc20), Boundary())
                cpu.v[1] = int.from_bytes(struct.pack("<2d", 1., 2.), "little")
                cpu.v[2] = int.from_bytes(struct.pack("<2d", divisor, 3.), "little")
                with self.assertRaisesRegex(AssertionError, "Audited SIMD"):
                    cpu.step()

    def test_unaudited_lane_shapes_are_not_accidentally_accepted(self):
        for op in (0x4e040420, 0x4e22d420, 0x6e22fc20, 0x0ee0e820):
            with self.subTest(op=hex(op)):
                cpu = CPU(struct.pack("<I", op), Boundary())
                with self.assertRaisesRegex(AssertionError, "Unsupported instruction"):
                    cpu.step()


if __name__ == "__main__":
    unittest.main()
