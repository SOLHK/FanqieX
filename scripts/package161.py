#!/usr/bin/env python3
"""Package only the exact candidate that completed verify161.py successfully."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import zipfile

from verify161 import source_manifest

ROOT = Path(__file__).resolve().parents[1]
VERSION = '1.6.1'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--verification-dir', type=Path, required=True)
    parser.add_argument('--output', type=Path, default=ROOT / 'dist' / VERSION)
    args = parser.parse_args()
    source = args.verification_dir.resolve()
    summary = json.loads((source / 'ci-summary.json').read_text())
    if not summary.get('passed') or not summary.get('source_files_unchanged_during_verification'):
        raise SystemExit('Only a successful frozen-source verification may be packaged')
    manifest_bytes = (source / 'source-manifest.json').read_bytes()
    if hashlib.sha256(manifest_bytes).hexdigest() != summary['source_manifest_sha256']:
        raise SystemExit('Verification source manifest changed after verification')
    if source_manifest() != json.loads(manifest_bytes):
        raise SystemExit('Build/test sources changed after verification; verify the current tree again')
    binary_name = f'FanqieAdBlock-{VERSION}.dylib'
    binary = (source / binary_name).read_bytes()
    digest = hashlib.sha256(binary).hexdigest()
    if digest != summary['candidate_sha256']:
        raise SystemExit('Candidate changed after verification')
    output = args.output.resolve()
    report_dir = ROOT / 'verification' / VERSION
    for target in (output, report_dir):
        if target.exists() and any(target.iterdir()):
            raise SystemExit(f'Packaging requires an empty generated destination: {target}')
    for path in source.glob('*.json'):
        report = json.loads(path.read_text())
        if isinstance(report, dict) and report.get('candidate_sha256', digest) != digest:
            raise SystemExit(f'Report belongs to a different candidate: {path.name}')
    output.mkdir(parents=True, exist_ok=True)
    (output / binary_name).write_bytes(binary)
    readme = f'''FanqieAdBlock {VERSION} / FanqieX

使用现有 IPA 注入和重签名流程替换旧插件；同一个宿主只加载一份 FanqieAdBlock。
本文件是 ARM64 动态库，不能直接点击当作独立 iOS 应用安装。

修复范围：阅读页顶部按钮恢复宿主原始图标与布局；主底栏选择交互交给
系统原生 UISegmentedControl，保留番茄原始选页路径，由系统管理选择透镜。
不在原生控件后叠加第二层玻璃；无法创建时回退单 Regular 玻璃与普通选中底色。
兼容回退的拖动定位已修正。
保留去广告、主底栏交互、诊断入口和最近一小时导出。

本包二进制已通过可复现构建、结构与签名检查及明确范围的 ARM64 离线回归。
构建器支持并要求云端发布校验使用 Xcode 27.2 / iOS 27.2 SDK。
对应提交的真实云端构建结果见 GitHub Actions，不能从本地报告推断它已经通过。
尚未在用户 iPhone 上验证最终合成、系统选择透镜的光学表现及 IPA 注入。
宿主 SDK 与系统兼容模式可能影响原生控件外观；插件不会伪造宿主 SDK 或修改全局设计模式。

SHA-256: {digest}
大小: {len(binary)} bytes

源码与下载：https://github.com/SOLHK/FanqieX/tree/test
构建记录：https://github.com/SOLHK/FanqieX/actions
设备验收：docs/DEVICE_ACCEPTANCE_161.md
'''
    (output / 'README_zh-CN.txt').write_text(readme)
    verification = {key: summary[key] for key in
                    ('passed', 'candidate_sha256', 'candidate_size', 'two_builds_identical',
                     'device_tested', 'source_manifest_sha256', 'source_file_count', 'steps')}
    verification['scope'] = summary['scope']
    (output / 'VERIFICATION.json').write_text(
        json.dumps(verification, ensure_ascii=False, indent=2) + '\n')
    zip_name = f'FanqieAdBlock-{VERSION}.zip'
    with zipfile.ZipFile(output / zip_name, 'w', compression=zipfile.ZIP_DEFLATED,
                         compresslevel=9) as archive:
        for name in (binary_name, 'README_zh-CN.txt', 'VERIFICATION.json'):
            info = zipfile.ZipInfo(name, (2026, 11, 8, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            archive.writestr(info, (output / name).read_bytes())
    with zipfile.ZipFile(output / zip_name) as archive:
        if archive.testzip() is not None or archive.read(binary_name) != binary:
            raise SystemExit('Archive does not contain the exact verified plugin bytes')
    zip_digest = hashlib.sha256((output / zip_name).read_bytes()).hexdigest()
    (output / 'SHA256SUMS.txt').write_text(
        f'{digest}  {binary_name}\n{zip_digest}  {zip_name}\n')
    report_dir.mkdir(parents=True, exist_ok=True)
    for path in sorted(source.glob('*.json')):
        shutil.copy2(path, report_dir / path.name)
    shutil.copy2(source / 'SHA256SUMS.txt', report_dir / 'SHA256SUMS.txt')
    shutil.copytree(source / 'logs', report_dir / 'logs', dirs_exist_ok=True)
    print(json.dumps({'version': VERSION, 'candidate_sha256': digest,
                      'zip_sha256': zip_digest, 'size_bytes': len(binary),
                      'steps': len(summary['steps']), 'device_tested': False}, indent=2))


if __name__ == '__main__':
    main()
