#!/usr/bin/env python3
"""Fail-closed AArch64 interpreter for a small, local binary patch audit.

This is not an iOS emulator. It decodes selected machine instructions, enforces
AAPCS register/stack rules, and delegates Objective-C calls to a stateful mock.
FP values use IEEE binary32/binary64 on the Python host. No UIKit rendering,
Core Animation transaction timing, dyld execution, or PAC is simulated.
"""
import math
import struct
from collections import deque

MASK64 = (1 << 64) - 1


def require(test, detail):
    if not test:
        raise AssertionError(detail)


def release_version(data):
    version = struct.unpack_from('<I', data, 0x818)[0]
    require(version in (0x10602, 0x10603, 0x10604, 0x10605,0x10606,0x10607,0x10608), 'Expected a 1.6.2–1.6.8 release candidate')
    return f'1.6.{version & 0xff}'


def sx(value, bits):
    return value - (1 << bits) if value & (1 << (bits - 1)) else value


def bits(value, width=64):
    if width == 64:
        return struct.unpack('<Q', struct.pack('<d', value))[0]
    try:
        return struct.unpack('<I', struct.pack('<f', value))[0]
    except OverflowError:
        return 0x7f800000 | (0x80000000 if value < 0 else 0)


def number(value, width=64):
    fmt = ('<Q', '<d') if width == 64 else ('<I', '<f')
    return struct.unpack(fmt[1], struct.pack(fmt[0], value & ((1 << width) - 1)))[0]


class CPU:
    RETURN = 0x3f000000

    def __init__(self, data, runtime, slide=0, ranges=None):
        self.data, self.runtime, self.slide = data, runtime, slide
        self.ranges = ranges or [(0, len(data))]
        self.x = [0x9000000000000000 + i for i in range(31)]
        self.v = [((0xa000000000000000 + i) << 64) | (0xb000000000000000 + i)
                  for i in range(32)]
        self.sp = 0x70000000
        self.memory = {}
        self.pointers = {}
        self.pc = 0
        self.n = self.z = self.c = self.overflow = False
        self.steps = 0
        self.executed = set()
        self.branches = set()
        self.opcodes = set()
        self.trace = deque(maxlen=4096)

    def read(self, address, size):
        if size == 8 and address in self.pointers:
            return self.pointers[address]
        if self.slide <= address and address + size <= self.slide + len(self.data):
            return int.from_bytes(self.data[address-self.slide:address-self.slide+size], 'little')
        require(all(address+i in self.memory for i in range(size)),
                'Read uninitialized memory ' + hex(address))
        return int.from_bytes(bytes(self.memory[address+i] for i in range(size)), 'little')

    def write(self, address, size, value):
        require(0x6ff00000 <= address and address + size <= 0x70000000,
                'Write outside simulated stack ' + hex(address))
        for i, b in enumerate((value & ((1 << (8*size))-1)).to_bytes(size, 'little')):
            self.memory[address+i] = b

    def r(self, n, sp=False, width=64):
        return ((self.sp if sp else 0) if n == 31 else self.x[n]) & ((1 << width)-1)

    def w(self, n, value, sp=False, width=64):
        value &= (1 << width)-1
        if n == 31:
            if sp:
                self.sp = value
        else:
            self.x[n] = value

    def fp(self, n, width=64):
        return number(self.v[n], width)

    def wf(self, n, value, width=64):
        self.v[n] = bits(value, width)

    def flags(self, n, z, c, v):
        self.n, self.z, self.c, self.overflow = bool(n), bool(z), bool(c), bool(v)

    def flags_imm(self, nzcv):
        self.flags(nzcv & 8, nzcv & 4, nzcv & 2, nzcv & 1)

    def arithmetic_flags(self, lhs, rhs, result, width, subtract):
        mask = (1 << width)-1
        lhs &= mask; rhs &= mask
        out = result & mask
        sign = 1 << (width-1)
        if subtract:
            carry = lhs >= rhs
            overflow = ((lhs ^ rhs) & (lhs ^ out) & sign) != 0
        else:
            carry = lhs + rhs > mask
            overflow = (~(lhs ^ rhs) & (lhs ^ out) & sign) != 0
        self.flags(out & sign, out == 0, carry, overflow)

    def fp_compare(self, lhs, rhs):
        if math.isnan(lhs) or math.isnan(rhs):
            self.flags(0, 0, 1, 1)
        elif lhs == rhs:
            self.flags(0, 1, 1, 0)
        elif lhs < rhs:
            self.flags(1, 0, 0, 0)
        else:
            self.flags(0, 0, 1, 0)

    def condition(self, cond):
        base = cond >> 1
        result = (self.z, self.c, self.n, self.overflow,
                  self.c and not self.z, self.n == self.overflow,
                  self.n == self.overflow and not self.z, True)[base]
        return (not result) if (cond & 1 and cond != 15) else result

    @staticmethod
    def shift(value, shift_type, amount, width):
        value &= (1 << width)-1
        if shift_type == 0:
            return value << amount
        if shift_type == 1:
            return value >> amount
        if shift_type == 2:
            return sx(value, width) >> amount
        return (value >> amount) | (value << ((width-amount) % width))

    def load_store(self, op, address, size, vector, signed=False, signed_to=64):
        reg = op & 31
        if op & (1 << 22) or signed:
            value = self.read(address, size)
            if signed:
                value = sx(value, size*8)
            if vector:
                self.v[reg] = value
            else:
                self.w(reg, value, width=signed_to if signed else min(64, size*8))
        else:
            value = self.v[reg] if vector else self.r(reg, width=size*8)
            self.write(address, size, value)

    def step(self):
        if self.runtime.handle(self, self.pc):
            return
        pc = self.pc
        rel = pc-self.slide
        require(any(a <= rel < b for a, b in self.ranges),
                'Execution outside audited code: ' + hex(pc))
        op = self.read(pc, 4)
        self.executed.add(rel); self.opcodes.add(op); self.trace.append(rel)
        self.steps += 1
        self.pc = pc+4
        if op == 0xd503201f:
            return
        if op & 0x7c000000 == 0x14000000:  # B / BL
            target = pc + (sx(op & 0x3ffffff, 26) << 2)
            if op >> 31:
                self.x[30] = pc+4
            self.pc = target; self.branches.add((rel, target-self.slide)); return
        if op & 0xfffffc1f in (0xd63f0000, 0xd65f0000, 0xd61f0000):
            base = op & 0xfffffc1f; target = self.r((op >> 5) & 31)
            if base == 0xd63f0000:
                self.x[30] = pc+4
            self.pc = target; return
        if op & 0x7e000000 == 0x34000000:  # CBZ / CBNZ
            width = 64 if op >> 31 else 32
            iszero = self.r(op & 31, width=width) == 0
            take = not iszero if op & (1 << 24) else iszero
            target = pc + (sx((op >> 5) & 0x7ffff, 19) << 2)
            if take:
                self.pc = target
            self.branches.add((rel, self.pc-self.slide)); return
        if op & 0x7e000000 == 0x36000000:  # TBZ / TBNZ
            bit = ((op >> 26) & 32) | ((op >> 19) & 31)
            nonzero = bool(self.r(op & 31) & (1 << bit))
            take = nonzero if op & (1 << 24) else not nonzero
            target = pc + (sx((op >> 5) & 0x3fff, 14) << 2)
            if take:
                self.pc = target
            self.branches.add((rel, self.pc-self.slide)); return
        if op & 0xff000010 == 0x54000000:  # B.cond
            target = pc + (sx((op >> 5) & 0x7ffff, 19) << 2)
            if self.condition(op & 15):
                self.pc = target
            self.branches.add((rel, self.pc-self.slide)); return
        if op & 0x1f000000 == 0x10000000:  # ADR / ADRP
            imm = sx((((op >> 5) & 0x7ffff) << 2) | ((op >> 29) & 3), 21)
            value = (pc & ~0xfff) + (imm << 12) if op >> 31 else pc+imm
            self.w(op & 31, value); return
        if op & 0x1f000000 == 0x11000000:  # ADD / SUB immediate
            width = 64 if op >> 31 else 32
            rhs = ((op >> 10) & 0xfff) << (12 if op & (1 << 22) else 0)
            lhs = self.r((op >> 5) & 31, sp=True, width=width)
            subtract = bool(op & (1 << 30)); flags = bool(op & (1 << 29))
            out = lhs-rhs if subtract else lhs+rhs
            if flags:
                self.arithmetic_flags(lhs, rhs, out, width, subtract)
            self.w(op & 31, out, sp=not flags, width=width); return
        if op & 0x1f800000 == 0x12800000:  # MOVN / MOVZ / MOVK
            width = 64 if op >> 31 else 32
            shift = 16*((op >> 21) & 3)
            imm = ((op >> 5) & 0xffff) << shift
            operation = (op >> 29) & 3
            require(operation in (0, 2, 3) and shift < width, 'Valid move-wide encoding')
            value = ~imm if operation == 0 else imm
            if operation == 3:
                value = (self.r(op & 31, width=width) & ~(0xffff << shift)) | imm
            self.w(op & 31, value, width=width); return
        if op & 0x1f800000 == 0x12000000:  # logical immediate
            width = 64 if op >> 31 else 32
            n, immr, imms = (op >> 22) & 1, (op >> 16) & 63, (op >> 10) & 63
            length = ((n << 6) | ((~imms) & 63)).bit_length()-1
            require(length >= 1 and (1 << length) <= width, 'Valid logical bitmask width')
            element_size = 1 << length; levels = element_size-1
            s, rotation = imms & levels, immr & levels
            require(s != levels, 'Reserved all-ones logical immediate')
            element = (1 << (s+1))-1
            element = ((element >> rotation) | (element << (element_size-rotation))) & ((1 << element_size)-1)
            mask = sum(element << at for at in range(0,width,element_size))
            source = self.r((op >> 5) & 31,width=width)
            operation = (op >> 29) & 3
            value = source & mask if operation in (0,3) else (source | mask if operation == 1 else source ^ mask)
            if operation == 3:
                self.flags(value & (1 << (width-1)),value == 0,0,0)
            self.w(op & 31,value,width=width); return
        if op & 0x1f200000 == 0x0b000000:  # ADD / SUB shifted register
            width = 64 if op >> 31 else 32
            lhs = self.r((op >> 5) & 31, width=width)
            rhs = self.shift(self.r((op >> 16) & 31, width=width),
                             (op >> 22) & 3, (op >> 10) & 63, width) & ((1 << width)-1)
            subtract = bool(op & (1 << 30))
            out = lhs-rhs if subtract else lhs+rhs
            if op & (1 << 29):
                self.arithmetic_flags(lhs, rhs, out, width, subtract)
            self.w(op & 31, out, width=width); return
        if op & 0x1f000000 == 0x0a000000:  # logical shifted register (includes MOV)
            width = 64 if op >> 31 else 32
            lhs = self.r((op >> 5) & 31, width=width)
            rhs = self.shift(self.r((op >> 16) & 31, width=width),
                             (op >> 22) & 3, (op >> 10) & 63, width)
            if op & (1 << 21):
                rhs = ~rhs
            operation = (op >> 29) & 3
            value = lhs & rhs if operation in (0, 3) else (lhs | rhs if operation == 1 else lhs ^ rhs)
            if operation == 3:
                self.flags(value & (1 << (width-1)), not (value & ((1 << width)-1)), 0, 0)
            self.w(op & 31, value, width=width); return
        if op & 0x3fe00c10 in (0x3a400000, 0x3a400800):  # CCMN / CCMP register or immediate
            if self.condition((op >> 12) & 15):
                width = 64 if op >> 31 else 32
                lhs = self.r((op >> 5) & 31, width=width)
                operand = (op >> 16) & 31
                rhs = operand if op & (1 << 11) else self.r(operand, width=width)
                subtract = bool(op & (1 << 30))
                self.arithmetic_flags(lhs, rhs, lhs-rhs if subtract else lhs+rhs, width, subtract)
            else:
                self.flags_imm(op & 15)
            return
        if op & 0x3fe00800 == 0x1a800000:  # CSEL / CSINC / CSINV / CSNEG
            width = 64 if op >> 31 else 32
            if self.condition((op >> 12) & 15):
                value = self.r((op >> 5) & 31, width=width)
            else:
                value = self.r((op >> 16) & 31, width=width)
                if op & (1 << 30):
                    value = ~value
                if op & (1 << 10):
                    value += 1
            self.w(op & 31, value, width=width); return
        if op & 0x7fe0fc00 in (0x1ac02000, 0x1ac02400, 0x1ac02800):  # variable shifts
            width = 64 if op >> 31 else 32
            mode = {0x1ac02000:0, 0x1ac02400:1, 0x1ac02800:2}[op & 0x7fe0fc00]
            value = self.shift(self.r((op >> 5) & 31, width=width), mode,
                               self.r((op >> 16) & 31) & (width-1), width)
            self.w(op & 31, value, width=width); return
        if op & 0x7fe00000 == 0x1b000000:  # MADD / MSUB (includes MUL)
            width = 64 if op >> 31 else 32
            product = self.r((op >> 5) & 31,width=width)*self.r((op >> 16) & 31,width=width)
            addend = self.r((op >> 10) & 31,width=width)
            value = addend-product if op & 0x8000 else addend+product
            self.w(op & 31,value,width=width); return
        if op & 0x7f800000 == 0x13000000:  # SBFM (signed extend / ASR / SBFX)
            width = 64 if op >> 31 else 32
            require(bool(op & (1 << 22)) == (width == 64), 'Signed bitfield N follows register width')
            immr, imms = (op >> 16) & 63, (op >> 10) & 63
            require(immr < width and imms < width, 'Valid signed bitfield range')
            source = self.r((op >> 5) & 31, width=width)
            if imms >= immr:
                count = imms-immr+1
                value = (source >> immr) & ((1 << count)-1)
                if value & (1 << (count-1)):
                    value -= 1 << count
            else:
                count = imms+1
                value = source & ((1 << count)-1)
                if value & (1 << (count-1)):
                    value -= 1 << count
                value <<= width-immr
            self.w(op & 31, value, width=width); return
        if op & 0x7f800000 == 0x53000000:  # UBFM (UBFX / LSL / LSR)
            width = 64 if op >> 31 else 32
            immr, imms = (op >> 16) & 63, (op >> 10) & 63
            source = self.r((op >> 5) & 31, width=width)
            if imms >= immr:
                value = (source >> immr) & ((1 << (imms-immr+1))-1)
            else:
                value = (source & ((1 << (imms+1))-1)) << (width-immr)
            self.w(op & 31, value, width=width); return
        if op & 0x7f800000 == 0x13000000:  # SBFM (SBFX / ASR / SXTB / SXTH / SXTW)
            width = 64 if op >> 31 else 32
            immr, imms = (op >> 16) & 63, (op >> 10) & 63
            require(bool(op & (1 << 22)) == (width == 64) and immr <= imms < width,
                    'Canonical signed bitfield extract')
            length = imms - immr + 1
            value = (self.r((op >> 5) & 31, width=width) >> immr) & ((1 << length) - 1)
            self.w(op & 31, sx(value, length), width=width); return
        if op & 0xff20fc00 == 0x4e201c00:  # ORR vector / MOV.16B
            self.v[op & 31] = self.v[(op >> 5) & 31] | self.v[(op >> 16) & 31]; return
        if op & 0x3a000000 == 0x28000000:  # LDP / STP integer or SIMD
            vector = bool(op & (1 << 26)); opc = (op >> 30) & 3
            size = 1 << (opc+2) if vector else (8 if opc == 2 else 4)
            require(size in (4, 8, 16), 'Pair access width')
            offset = sx((op >> 15) & 127, 7)*size
            mode = (op >> 23) & 3
            base = self.r((op >> 5) & 31, sp=True)
            address = base if mode == 1 else base+offset
            for i, reg in enumerate((op & 31, (op >> 10) & 31)):
                if op & (1 << 22):
                    value = self.read(address+i*size, size)
                    if vector:
                        self.v[reg] = value
                    else:
                        self.w(reg, value, width=size*8)
                else:
                    self.write(address+i*size, size, self.v[reg] if vector else self.r(reg, width=size*8))
            if mode in (1, 3):
                self.w((op >> 5) & 31, base+offset, sp=True)
            return
        if op & 0x3b000000 == 0x18000000:  # LDR literal
            vector = bool(op & (1 << 26)); opc = (op >> 30) & 3
            size = (4 << opc) if vector else (8 if opc == 1 else 4)
            require(opc != 3, 'No prefetch literal in audited code')
            value = self.read(pc + (sx((op >> 5) & 0x7ffff, 19) << 2), size)
            if vector:
                self.v[op & 31] = value
            else:
                self.w(op & 31, sx(value, 32) if opc == 2 else value)
            return
        if op & 0x3b000000 == 0x39000000:  # LDR / STR unsigned offset
            vector = bool(op & (1 << 26)); opc = (op >> 22) & 3
            size = 1 << ((op >> 30) & 3)
            if vector and opc & 2:
                size = 16
            address = self.r((op >> 5) & 31, sp=True) + ((op >> 10) & 0xfff)*size
            self.load_store(op, address, size, vector, signed=not vector and opc >= 2,
                            signed_to=32 if opc == 3 else 64)
            return
        if op & 0x3b200c00 == 0x38200800:  # LDR / STR register offset
            vector = bool(op & (1 << 26)); size = 1 << ((op >> 30) & 3)
            opc = (op >> 22) & 3
            if vector and opc & 2:
                size = 16
            option = (op >> 13) & 7
            require(option in (2, 3, 6, 7), 'Load/store index extension')
            width = 32 if option in (2, 6) else 64
            offset = self.r((op >> 16) & 31, width=width)
            if option in (6, 7):
                offset = sx(offset, width)
            if op & (1 << 12):
                offset *= size
            address = self.r((op >> 5) & 31, sp=True)+offset
            self.load_store(op, address, size, vector, signed=not vector and opc >= 2,
                            signed_to=32 if opc == 3 else 64)
            return
        if op & 0x3b200000 == 0x38000000:  # unscaled / pre-index / post-index
            vector = bool(op & (1 << 26)); opc = (op >> 22) & 3
            size = 1 << ((op >> 30) & 3)
            if vector and opc & 2:
                size = 16
            mode = (op >> 10) & 3
            require(mode != 2, 'Unprivileged memory access not supported')
            offset = sx((op >> 12) & 0x1ff, 9)
            base = self.r((op >> 5) & 31, sp=True)
            address = base if mode == 1 else base+offset
            self.load_store(op, address, size, vector, signed=not vector and opc >= 2,
                            signed_to=32 if opc == 3 else 64)
            if mode in (1, 3):
                self.w((op >> 5) & 31, base+offset, sp=True)
            return
        if op & 0xff201fe0 == 0x1e201000:  # FMOV scalar immediate
            width = 64 if op & (1 << 22) else 32
            imm = (op >> 13) & 255
            exponent_bits = 11 if width == 64 else 8
            fraction_bits = 52 if width == 64 else 23
            sign = (imm >> 7) & 1; b6 = (imm >> 6) & 1
            exponent = ((1-b6) << (exponent_bits-1)) | (((1 << (exponent_bits-3))-1)*b6 << 2) | ((imm >> 4) & 3)
            self.v[op & 31] = (sign << (width-1)) | (exponent << fraction_bits) | ((imm & 15) << (fraction_bits-4))
            return
        if op & 0x7f3ffc00 in (0x1e260000, 0x1e270000):  # FMOV scalar / general
            width = 64 if op >> 31 else 32
            require(bool(op & (1 << 22)) == (width == 64), 'Matching FP/general move width')
            if op & (1 << 16):
                self.v[op & 31] = self.r((op >> 5) & 31, width=width)
            else:
                self.w(op & 31, self.v[(op >> 5) & 31], width=width)
            return
        if op & 0x7f3ffc00 in (0x1e220000, 0x1e230000):  # SCVTF / UCVTF integer
            source_width = 64 if op >> 31 else 32
            value = self.r((op >> 5) & 31, width=source_width)
            if not op & (1 << 16):
                value = sx(value, source_width)
            self.wf(op & 31, float(value), 64 if op & (1 << 22) else 32); return
        if op & 0x7f3ffc00 == 0x1e380000:  # FCVTZS scalar FP -> signed general register
            width = 64 if op >> 31 else 32
            value = self.fp((op >> 5) & 31, 64 if op & (1 << 22) else 32)
            # Audited scroll-bucket operands are finite and in signed range.
            # Exceptional FP conversions require FPSR/FPCR modeling, which this
            # interpreter deliberately does not pretend to implement.
            require(math.isfinite(value) and -(1 << (width-1)) <= value < (1 << (width-1)),
                    'FCVTZS operand finite and in audited signed range')
            self.w(op & 31, math.trunc(value), width=width); return
        if op & 0xff20fc07 == 0x1e202000:  # FCMP / FCMPE register or zero
            width = 64 if op & (1 << 22) else 32
            rhs = 0.0 if op & 8 else self.fp((op >> 16) & 31, width)
            self.fp_compare(self.fp((op >> 5) & 31, width), rhs); return
        if op & 0xff200c00 == 0x1e200400:  # FCCMP / FCCMPE
            width = 64 if op & (1 << 22) else 32
            if self.condition((op >> 12) & 15):
                self.fp_compare(self.fp((op >> 5) & 31, width), self.fp((op >> 16) & 31, width))
            else:
                self.flags_imm(op & 15)
            return
        if op & 0xff200c00 == 0x1e200c00:  # FCSEL
            width = 64 if op & (1 << 22) else 32
            source = ((op >> 5) & 31) if self.condition((op >> 12) & 15) else ((op >> 16) & 31)
            self.v[op & 31] = self.v[source] & ((1 << width)-1); return
        if op & 0xff20fc00 in (0x1e200800, 0x1e201800, 0x1e202800, 0x1e203800,
                              0x1e204800, 0x1e205800, 0x1e206800, 0x1e207800):
            width = 64 if op & (1 << 22) else 32
            a = self.fp((op >> 5) & 31, width); b = self.fp((op >> 16) & 31, width)
            operation = (op >> 12) & 15
            if operation == 0:
                value = a*b
            elif operation == 1:
                value = a/b if b else (math.nan if not a else math.copysign(math.inf, a*b))
            elif operation == 2:
                value = a+b
            elif operation == 3:
                value = a-b
            else:
                if math.isnan(a) or math.isnan(b):
                    value = (b if math.isnan(a) else a) if operation >= 6 else math.nan
                else:
                    value = max(a, b) if operation in (4, 6) else min(a, b)
                    if a == b == 0.0:
                        value = -0.0 if operation in (5, 7) and (math.copysign(1, a) < 0 or math.copysign(1, b) < 0) else 0.0
            self.wf(op & 31, value, width); return
        if op & 0xfffffc00 in (0x1e204000, 0x1e604000, 0x1e20c000, 0x1e60c000,
                              0x1e214000, 0x1e614000, 0x1e22c000, 0x1e624000):
            key = op & 0xfffffc00; src = (op >> 5) & 31; dst = op & 31
            width = 64 if op & (1 << 22) else 32
            if key in (0x1e22c000, 0x1e624000):
                self.wf(dst, self.fp(src, width), 32 if width == 64 else 64)
            elif key in (0x1e204000, 0x1e604000):
                self.v[dst] = self.v[src] & ((1 << width)-1)
            elif key in (0x1e20c000, 0x1e60c000):
                self.v[dst] = self.v[src] & ((1 << (width-1))-1)
            else:
                self.v[dst] = (self.v[src] ^ (1 << (width-1))) & ((1 << width)-1)
            return
        raise AssertionError('Unsupported instruction %08x at %x' % (op, pc))

    def run(self, entry, x0=None, x1=None, x2=None, d0=None, max_steps=500000,
            args=None, fp_args=None, check_abi=True):
        before = {'sp':self.sp, 'x':self.x.copy(), 'v':self.v.copy()}
        for n, value in enumerate((x0, x1, x2)):
            if value is not None:
                self.x[n] = value
        if d0 is not None:
            self.v[0] = d0
        if args:
            for n, value in enumerate(args):
                self.x[n] = value
        if fp_args:
            for n, value in enumerate(fp_args):
                self.wf(n, value)
        self.x[30] = self.RETURN
        self.pc = self.slide+entry
        begin = self.steps; iterations = 0
        while self.pc != self.RETURN:
            iterations += 1
            require(iterations <= max_steps, 'Instruction/stub limit')
            self.step()
        if check_abi:
            require(self.sp == before['sp'], 'Balanced stack at return')
            require(self.x[18:30] == before['x'][18:30], 'Preserved x18 and x19..x29')
            require([v & MASK64 for v in self.v[8:16]] == [v & MASK64 for v in before['v'][8:16]],
                    'Preserved d8..d15')
        return {'instructions':self.steps-begin, 'result':self.x[0]}
