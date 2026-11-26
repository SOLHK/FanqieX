"""Mandatory, dependency-free instruction checks using independent oracle data.

The geometry fixture comes from LLVM-assembled instructions executed by Unicorn,
not from this repository's Python interpreter. The generator is a separate,
explicit developer tool; missing Unicorn never skips these CI assertions. MOVI
uses fixed LLVM-assembled opcodes and Arm's specified per-byte immediate values.
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
        self.assertGreaterEqual(len(fixture["vectors"]), 200)
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

    def test_xcode_geometry_replicates_raw_64_bit_values(self):
        # Apple object code at 0x3fd94/0x3fe24, with independent GPR and memory values.
        raw = 0xfedcba9876543210
        for op, dst, source in ((0x4d40cd02, 2, raw), (0x4e080d01, 1, 8)):
            with self.subTest(op=hex(op)):
                cpu = CPU(struct.pack("<I", op) + bytes(4) + struct.pack("<Q", raw), Boundary())
                cpu.x[8] = 8
                cpu.flags_imm(10)
                originals, gprs, sp = cpu.v[:], cpu.x[:], cpu.sp
                cpu.step()
                originals[dst] = source | (source << 64)
                self.assertEqual(cpu.v, originals)
                self.assertEqual(cpu.x, gprs)
                self.assertEqual(cpu.sp, sp)
                self.assertEqual((cpu.n, cpu.z, cpu.c, cpu.overflow), (True, False, True, False))

    def test_xcode_geometry_rejects_nonfinite_operands(self):
        for op in (0x4ee2d462, 0x6e61dc00, 0x4ee5c443, 0x4e62c482, 0x6ee0e422):
            with self.subTest(op=hex(op)):
                cpu = CPU(struct.pack("<I", op), Boundary())
                cpu.v[(op >> 5) & 31] = int.from_bytes(struct.pack("<2d", 1., float("nan")), "little")
                with self.assertRaisesRegex(AssertionError, "Audited SIMD"):
                    cpu.step()

    def test_unaudited_lane_shapes_are_not_accidentally_accepted(self):
        for op in (0x4e040420, 0x4e22d420, 0x6e22fc20, 0x0ee0e820):
            with self.subTest(op=hex(op)):
                cpu = CPU(struct.pack("<I", op), Boundary())
                with self.assertRaisesRegex(AssertionError, "Unsupported instruction"):
                    cpu.step()


class ByteImmediateMOVI(unittest.TestCase):
    def test_fixed_opcodes_write_only_the_destination_and_preserve_flags(self):
        # LLVM 19 assembly bytes; semantics: Arm Instruction Set Reference Guide
        # 100076_0100_00_en, D6.123 MOVI (vector), 8-bit arrangement.
        # Literal expected bytes deliberately do not reuse the decoder's masks.
        cases = (
            (0x4f00e400, 0, bytes(16)),                  # movi v0.16b, #0
            (0x0f00e407, 7, bytes(16)),                  # movi v7.8b, #0
            (0x4f00e433, 19, b'\x01' * 16),             # movi v19.16b, #1
            (0x0f02e75f, 31, b'\x5a' * 8 + bytes(8)),   # movi v31.8b, #0x5a
            (0x4f04e408, 8, b'\x80' * 16),              # movi v8.16b, #0x80
            (0x0f07e7e4, 4, b'\xff' * 8 + bytes(8)),    # movi v4.8b, #0xff
            (0x4f07e7ff, 31, b'\xff' * 16),             # movi v31.16b, #0xff
        )
        for opcode, destination, expected_bytes in cases:
            for nzcv in (0, 5, 10, 15):
                with self.subTest(opcode=hex(opcode), nzcv=nzcv):
                    cpu = CPU(struct.pack('<I', opcode), Boundary())
                    expected = cpu.v[:]
                    expected[destination] = int.from_bytes(expected_bytes, 'little')
                    original_x, original_sp = cpu.x[:], cpu.sp
                    cpu.flags_imm(nzcv)
                    flags = (cpu.n, cpu.z, cpu.c, cpu.overflow)
                    cpu.step()
                    self.assertEqual(cpu.v, expected)
                    self.assertEqual(cpu.x, original_x)
                    self.assertEqual(cpu.sp, original_sp)
                    self.assertEqual((cpu.n, cpu.z, cpu.c, cpu.overflow), flags)
                    self.assertEqual(cpu.pc, 4)

    def test_other_immediate_shapes_and_reserved_bits_stay_unsupported(self):
        for opcode in (0x4f000400, 0x4f008400, 0x4f00c400,  # 32/16-bit lanes
                       0x2f00e400, 0x6f00e400,              # 64-bit bitmasks
                       0x4f00ec00, 0x4f08e400, 0xcf00e400): # unrelated/reserved
            with self.subTest(opcode=hex(opcode)):
                cpu = CPU(struct.pack('<I', opcode), Boundary())
                with self.assertRaisesRegex(AssertionError, 'Unsupported instruction'):
                    cpu.step()


if __name__ == "__main__":
    unittest.main()
