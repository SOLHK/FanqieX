#!/usr/bin/env python3
"""Package only the exact candidate that completed verify162.py successfully."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import zipfile

from verify162 import source_manifest

ROOT = Path(__file__).resolve().parents[1]
VERSION = '1.6.2'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--version', choices=('1.6.2','1.6.3','1.6.4'), default=VERSION)
    parser.add_argument('--verification-dir', type=Path, required=True)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    version=args.version
    source = args.verification_dir.resolve()
    summary = json.loads((source / 'ci-summary.json').read_text())
    if not summary.get('passed') or not summary.get('source_files_unchanged_during_verification'):
        raise SystemExit('Only a successful frozen-source verification may be packaged')
    manifest_bytes = (source / 'source-manifest.json').read_bytes()
    if hashlib.sha256(manifest_bytes).hexdigest() != summary['source_manifest_sha256']:
        raise SystemExit('Verification source manifest changed after verification')
    if source_manifest() != json.loads(manifest_bytes):
        raise SystemExit('Build/test sources changed after verification; verify the current tree again')
    binary_name = f'FanqieX-{version}.dylib'
    binary = (source / binary_name).read_bytes()
    digest = hashlib.sha256(binary).hexdigest()
    if digest != summary['candidate_sha256']:
        raise SystemExit('Candidate changed after verification')
    output = (args.output or ROOT/'dist'/version).resolve()
    report_dir = ROOT / 'verification' / version
    for target in (output, report_dir):
        if target.exists() and any(target.iterdir()):
            raise SystemExit(f'Packaging requires an empty generated destination: {target}')
    for path in source.glob('*.json'):
        report = json.loads(path.read_text())
        if isinstance(report, dict) and report.get('candidate_sha256', digest) != digest:
            raise SystemExit(f'Report belongs to a different candidate: {path.name}')
    output.mkdir(parents=True, exist_ok=True)
    (output / binary_name).write_bytes(binary)
    readme = f'''FanqieX {version}

使用现有 IPA 注入和重签名流程替换旧插件；同一个宿主只加载一份 FanqieX。
请先移除原来以 FanqieAdBlock 命名的旧库，再注入本版本，避免新旧插件同时加载。
本文件是 ARM64 动态库，不能直接点击当作独立 iOS 应用安装。

修复范围：主底栏保留一层 Regular 玻璃底座，选中项改用语义灰色，
保留原有按钮文字与内容，并由系统控件处理原生选择和拖动。
书架顶部的看听读时长、编辑和筛选按钮在挂入页面前完成尺寸及胶囊形状配置。
阅读页顶部保持宿主原始图标与布局；保留去广告、原始选页路径、诊断入口
和最近一小时导出。插件文件名、内部安装标识和设置页统一为 FanqieX。

本包二进制已通过可复现构建、结构与签名检查及明确范围的 ARM64 离线回归。
构建器要求云端发布校验使用 Xcode 27.2 / iOS 27.2 SDK。
对应提交的真实云端构建结果见 GitHub Actions，不能从本地报告推断它已经通过。
尚未在用户 iPhone 上验证最终合成、动态折射及 IPA 注入。
宿主链接的 SDK、系统设置与兼容模式仍可能影响系统控件表现。
本次修复未新增全局设计模式覆盖，沿用旧偏好键以保留已有用户设置。

SHA-256: {digest}
大小: {len(binary)} bytes

源码与下载：https://github.com/SOLHK/FanqieX/tree/test
构建记录：https://github.com/SOLHK/FanqieX/actions
设备观察点：docs/DEVICE_ACCEPTANCE_162.md
'''
    (output / 'README_zh-CN.txt').write_text(readme)
    verification = {key: summary[key] for key in
                    ('passed', 'candidate_sha256', 'candidate_size', 'two_builds_identical',
                     'device_tested', 'source_manifest_sha256', 'source_file_count', 'steps')}
    verification['scope'] = summary['scope']
    (output / 'VERIFICATION.json').write_text(
        json.dumps(verification, ensure_ascii=False, indent=2) + '\n')
    if version=='1.6.4':
        readme=f'''FanqieX {version}

使用现有 IPA 注入和重签名流程替换旧插件，同一宿主只加载一份 FanqieX。
本文件是 ARM64 动态库。先移除旧库，再注入并重签名。

本版增加冷启动首页非标广告规则，继承开屏广告开关。
本次启动修复补齐原生诊断 Hook 的异常展开元数据，未知类型的接口标识直接放行。
启动事件没有附加数据时，保留 JSON null，并生成关联 ID，避免把空值当作字典读取。
加载过程写入应用沙盒 Documents/FanqieX/load-diagnostics.json；正常导出也包含 loadDiagnostics。
记录上次启动最后阶段、完成标记、插件/系统/宿主版本，文件限制为 32 KiB。
上次未完成不直接等于系统崩溃；dyld 拒绝加载时插件无法留下这份文件。
底栏左右留白结合 Safe Area 对称调整，继续使用现有 UIKit 玻璃和原生选择控件。
设置页提供增强诊断开关和 JSON 导出。评论、请求、模型及实际规则调用记录匿名关联标识。
诊断保留最近一小时，队列、保留记录、文件和导出容量均有上限，丢失与写入失败在导出中标记。

启动修复及验收见 docs/STARTUP_CRASH_1.6.4.md，其他覆盖范围见 docs/REPAIR_1.6.4.md。
本包的离线验证执行真实 ARM64 指令和明确的宿主边界模型。
京东素材是否消失、评论保护、玻璃材质、触控与 iOS 性能仍需真机验收。

SHA-256 {digest}
大小 {len(binary)} bytes
'''
    (output / 'README_zh-CN.txt').write_text(readme)
    zip_name = f'FanqieX-{version}.zip'
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
    print(json.dumps({'version': version, 'candidate_sha256': digest,
                      'zip_sha256': zip_digest, 'size_bytes': len(binary),
                      'steps': len(summary['steps']), 'device_tested': False}, indent=2))


if __name__ == '__main__':
    main()
