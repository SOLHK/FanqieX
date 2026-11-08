#!/usr/bin/env python3
"""Local-only ARM64 assembly and verification helpers for this repair.

Uses the preinstalled LLVM shared library. Does not execute the input dylib.
Supports same-layout rehashing of this file's existing ad-hoc signature only.
"""
import argparse
import ctypes as C
import hashlib
import json
import pathlib
import struct


def macho_commands(data):
    magic, cpu, sub, typ, ncmds, size, flags, reserved = struct.unpack_from('<8I', data)
    if magic != 0xfeedfacf:
        raise ValueError('Expected little-endian Mach-O 64')
    offset = 32
    for i in range(ncmds):
        cmd, length = struct.unpack_from('<II', data, offset)
        if length < 8 or offset + length > 32 + size:
            raise ValueError('Invalid load-command bounds')
        yield cmd, offset, length
        offset += length
    if offset != 32 + size:
        raise ValueError('Inconsistent load-command length')


def sections(data):
    for cmd, offset, length in macho_commands(data):
        if cmd != 0x19:
            continue
        nsections = struct.unpack_from('<I', data, offset + 64)[0]
        for i in range(nsections):
            a = offset + 72 + i * 80
            vals = struct.unpack_from('<16s16sQQIIIIIIII', data, a)
            name, segment, addr, size, fileoff, align, reloff, nreloc, flags, r1, r2, r3 = vals
            yield {'name': name.rstrip(b'\0').decode(),
                   'segment': segment.rstrip(b'\0').decode(), 'address': addr,
                   'size': size, 'offset': fileoff, 'reloc_offset': reloff,
                   'reloc_count': nreloc, 'flags': flags}


def signature_directory(data):
    locations = [(o, struct.unpack_from('<II', data, o + 8))
                 for cmd, o, length in macho_commands(data) if cmd == 0x1d]
    if len(locations) != 1:
        raise ValueError('Expected one LC_CODE_SIGNATURE')
    lcoff, (sigoff, sigsize) = locations[0]
    if sigoff + sigsize != len(data):
        raise ValueError('Signature must be at end of this file')
    magic, length, count = struct.unpack_from('>III', data, sigoff)
    if magic != 0xfade0cc0 or length != sigsize or count != 1:
        raise ValueError('Expected one ad-hoc SuperBlob slot')
    typ, relative = struct.unpack_from('>II', data, sigoff + 12)
    if typ != 0:
        raise ValueError('Expected CodeDirectory slot')
    off = sigoff + relative
    magic, length, version, flags, hash_offset, ident_offset, special, codeslots, codelimit = struct.unpack_from('>9I', data, off)
    hashsize, hashtype, platform, pagelog = struct.unpack_from('>4B', data, off + 36)
    if magic != 0xfade0c02 or not flags & 2 or special != 0 or hashtype != 2 or hashsize != 32:
        raise ValueError('Unsupported CodeDirectory signing format')
    if codelimit != sigoff or hash_offset + codeslots * hashsize > length:
        raise ValueError('Inconsistent signature bounds')
    pagesize = 1 << pagelog
    if (codelimit + pagesize - 1) // pagesize != codeslots:
        raise ValueError('Inconsistent code slot count')
    return {'offset': off, 'length': length, 'version': version, 'flags': flags,
            'hash_offset': hash_offset, 'ident_offset': ident_offset,
            'special_slots': special, 'code_slots': codeslots, 'code_limit': codelimit,
            'hash_size': hashsize, 'hash_type': hashtype, 'platform': platform,
            'page_size': pagesize, 'signature_offset': sigoff, 'signature_size': sigsize}


def verify_signature(data):
    cd = signature_directory(data)
    off = cd['offset']
    start = off + cd['ident_offset']
    ident = data[start:data.index(b'\0', start)].decode('utf-8')
    bad = []
    for i in range(cd['code_slots']):
        a, b = i * cd['page_size'], min((i + 1) * cd['page_size'], cd['code_limit'])
        digest = hashlib.sha256(data[a:b]).digest()
        ha = off + cd['hash_offset'] + i * cd['hash_size']
        if digest != data[ha:ha + cd['hash_size']]:
            bad.append(i)
    result = dict(cd)
    result.update(identifier=ident, page_hashes_valid=not bad, invalid_pages=bad,
                  cdhash=hashlib.sha256(data[off:off + cd['length']]).digest()[:20].hex(),
                  file_sha256=hashlib.sha256(data).hexdigest(),
                  verification_scope='Ad-hoc CodeDirectory and page hashes; not device acceptance')
    return result


def resign_same_layout(data, identifier=None):
    data = bytearray(data)
    cd = signature_directory(data)
    off = cd['offset']
    if identifier is not None:
        s = identifier.encode('utf-8') + b'\0'
        room = cd['hash_offset'] - cd['ident_offset']
        if len(s) > room:
            raise ValueError('New identifier does not fit original CodeDirectory')
        a = off + cd['ident_offset']
        data[a:a + room] = s.ljust(room, b'\0')
    for i in range(cd['code_slots']):
        a, b = i * cd['page_size'], min((i + 1) * cd['page_size'], cd['code_limit'])
        ha = off + cd['hash_offset'] + i * cd['hash_size']
        data[ha:ha + cd['hash_size']] = hashlib.sha256(data[a:b]).digest()
    out = bytes(data)
    if not verify_signature(out)['page_hashes_valid']:
        raise ValueError('Rehashed signature verification failed')
    return out


def llvm_library():
    lib = C.CDLL('/lib/x86_64-linux-gnu/libLLVM.so.19.1')
    for name in ('TargetInfo', 'Target', 'TargetMC', 'AsmPrinter', 'AsmParser', 'Disassembler'):
        getattr(lib, 'LLVMInitializeAArch64' + name)()
    return lib


def assemble_object(asm, triple='arm64-apple-ios15.0.1'):
    lib = llvm_library()
    ptr = C.c_void_p
    lib.LLVMContextCreate.restype = ptr
    lib.LLVMCreateMemoryBufferWithMemoryRangeCopy.argtypes = [C.c_char_p, C.c_size_t, C.c_char_p]
    lib.LLVMCreateMemoryBufferWithMemoryRangeCopy.restype = ptr
    lib.LLVMParseIRInContext.argtypes = [ptr, ptr, C.POINTER(ptr), C.POINTER(C.c_char_p)]
    lib.LLVMParseIRInContext.restype = C.c_int
    lib.LLVMGetTargetFromTriple.argtypes = [C.c_char_p, C.POINTER(ptr), C.POINTER(C.c_char_p)]
    lib.LLVMGetTargetFromTriple.restype = C.c_int
    lib.LLVMCreateTargetMachine.argtypes = [ptr, C.c_char_p, C.c_char_p, C.c_char_p, C.c_int, C.c_int, C.c_int]
    lib.LLVMCreateTargetMachine.restype = ptr
    lib.LLVMTargetMachineEmitToMemoryBuffer.argtypes = [ptr, ptr, C.c_int, C.POINTER(C.c_char_p), C.POINTER(ptr)]
    lib.LLVMTargetMachineEmitToMemoryBuffer.restype = C.c_int
    lib.LLVMGetBufferStart.argtypes = [ptr]
    lib.LLVMGetBufferStart.restype = ptr
    lib.LLVMGetBufferSize.argtypes = [ptr]
    lib.LLVMGetBufferSize.restype = C.c_size_t
    for name in ('LLVMDisposeModule', 'LLVMDisposeMemoryBuffer', 'LLVMContextDispose', 'LLVMDisposeTargetMachine'):
        getattr(lib, name).argtypes = [ptr]
    lib.LLVMDisposeMessage.argtypes = [C.c_char_p]
    escaped = ''.join('\\%02X' % b for b in asm.encode('utf-8'))
    ir = ('target triple = "' + triple + '"\nmodule asm "' + escaped + '"\n').encode()
    context = lib.LLVMContextCreate()
    source = lib.LLVMCreateMemoryBufferWithMemoryRangeCopy(ir, len(ir), b'inline_asm')
    module, target, output, err = ptr(), ptr(), ptr(), C.c_char_p()
    if lib.LLVMParseIRInContext(context, source, C.byref(module), C.byref(err)):
        raise RuntimeError('LLVM IR parser: ' + (err.value or b'unknown').decode())
    if lib.LLVMGetTargetFromTriple(triple.encode(), C.byref(target), C.byref(err)):
        raise RuntimeError('LLVM target: ' + (err.value or b'unknown').decode())
    machine = lib.LLVMCreateTargetMachine(target, triple.encode(), b'generic', b'', 2, 2, 0)
    if not machine:
        raise RuntimeError('LLVMCreateTargetMachine returned null')
    if lib.LLVMTargetMachineEmitToMemoryBuffer(machine, module, 1, C.byref(err), C.byref(output)):
        raise RuntimeError('LLVM codegen: ' + (err.value or b'unknown').decode())
    data = C.string_at(lib.LLVMGetBufferStart(output), lib.LLVMGetBufferSize(output))
    lib.LLVMDisposeMemoryBuffer(output)
    lib.LLVMDisposeTargetMachine(machine)
    lib.LLVMDisposeModule(module)
    lib.LLVMContextDispose(context)
    return data


def assemble_text(asm):
    data = assemble_object(asm)
    sects = [s for s in sections(data) if s['name'] == '__text']
    if len(sects) != 1:
        raise ValueError('Expected one assembled __text section')
    s = sects[0]
    if s['reloc_count']:
        raise ValueError('Assembled section contains unresolved relocations; link or resolve before injection')
    return data[s['offset']:s['offset'] + s['size']]


def disassemble(data, address=0):
    lib = llvm_library()
    ptr = C.c_void_p
    lib.LLVMCreateDisasm.argtypes = [C.c_char_p, ptr, C.c_int, ptr, ptr]
    lib.LLVMCreateDisasm.restype = ptr
    lib.LLVMSetDisasmOptions.argtypes = [ptr, C.c_uint64]
    lib.LLVMDisasmInstruction.argtypes = [ptr, ptr, C.c_uint64, C.c_uint64, C.c_char_p, C.c_size_t]
    lib.LLVMDisasmInstruction.restype = C.c_size_t
    lib.LLVMDisasmDispose.argtypes = [ptr]
    dc = lib.LLVMCreateDisasm(b'arm64-apple-ios', None, 0, None, None)
    if not dc:
        raise RuntimeError('LLVMCreateDisasm failed')
    lib.LLVMSetDisasmOptions(dc, 2)
    source = C.create_string_buffer(data)
    out = C.create_string_buffer(512)
    lines, offset = [], 0
    while offset < len(data):
        n = lib.LLVMDisasmInstruction(dc, C.byref(source, offset), len(data) - offset,
                                    address + offset, out, len(out))
        if not n:
            raise ValueError('Invalid instruction at 0x%x' % (address + offset))
        lines.append('%08x  %s  %s' % (address + offset, data[offset:offset + n].hex(), out.value.decode().strip()))
        offset += n
    lib.LLVMDisasmDispose(dc)
    return lines


def main():
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest='command', required=True)
    p = sub.add_parser('verify'); p.add_argument('file')
    p = sub.add_parser('rehash'); p.add_argument('source'); p.add_argument('output'); p.add_argument('--identifier')
    p = sub.add_parser('assemble'); p.add_argument('source'); p.add_argument('output'); p.add_argument('--object', action='store_true')
    p = sub.add_parser('disassemble'); p.add_argument('file'); p.add_argument('--offset', type=lambda s:int(s,0), default=0); p.add_argument('--size', type=lambda s:int(s,0)); p.add_argument('--address', type=lambda s:int(s,0))
    args = parser.parse_args()
    if args.command == 'verify':
        result = verify_signature(pathlib.Path(args.file).read_bytes())
        print(json.dumps(result, indent=2))
        if not result['page_hashes_valid']:
            raise SystemExit(1)
    elif args.command == 'rehash':
        if pathlib.Path(args.source).resolve() == pathlib.Path(args.output).resolve():
            raise ValueError('Refusing in-place modification')
        result = resign_same_layout(pathlib.Path(args.source).read_bytes(), args.identifier)
        pathlib.Path(args.output).write_bytes(result)
        print(json.dumps(verify_signature(result), indent=2))
    elif args.command == 'assemble':
        asm = pathlib.Path(args.source).read_text()
        data = assemble_object(asm) if args.object else assemble_text(asm)
        pathlib.Path(args.output).write_bytes(data)
        print(json.dumps({'output':args.output,'size':len(data)}))
    else:
        data = pathlib.Path(args.file).read_bytes()
        data = data[args.offset:args.offset + args.size if args.size is not None else None]
        print('\n'.join(disassemble(data, args.address if args.address is not None else args.offset)))


if __name__ == '__main__':
    main()
