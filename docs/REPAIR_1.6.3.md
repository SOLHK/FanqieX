# FanqieX 1.6.3 段评保护

此提交从 `test` 的 1.6.2 基线重建 1.6.3。参考用户提供的历史 1.6.3 分发包确认了改动的运行时入口。新源码和产物有各自的 Git 和 SHA-256 标识。

旧广告和玻璃安装器通过固定原始入口查找 Objective-C 方法，再替换其 IMP。查找可返回继承自父类的 `Method`，因此替换会波及其他共享该父类的宿主组件。
新入口先校验签名，再比较目标类与父类返回的 `Method`。继承方法用原始 IMP 和编码复制到目标类或元类，随后重新验证归属。归属不明或安装失败时跳过该 Hook。
原广告规则条件和段评显示逻辑保持原样。

## 复现

Linux 使用 Python 3 与 LLVM 19 共享库运行完整离线回归。macOS 使用实际 Xcode 27.2 和 iOS 27.2 SDK 重新组装，并对照冻结候选。

```bash
python3 scripts/verify162.py --version 1.6.3 --output build/ci163 \
  --expect-candidate dist/1.6.3/FanqieX-1.6.3.dylib
DEVELOPER_DIR=/Applications/Xcode_27.2.app/Contents/Developer \
  python3 scripts/build_xcode27.py --version 1.6.3 \
  --expect-candidate dist/1.6.3/FanqieX-1.6.3.dylib
```

## 真机验收

1. 在同一宿主、签名环境和章节中对照旧版及候选版。移除旧库后再注入候选。
2. 分别进入有 0、1、多条段评的段落。核对气泡和数量，打开并关闭面板，然后再次打开。
3. 翻页返回、退出阅读页再进入并冷启动。记录首次出现差异的步骤。
4. 检查章节末尾广告规则、主底栏切换、书架和阅读控件。

离线用例执行真实 ARM64 Hook 指令并对照宿主运行时模型。iPhone 注入、段评面板关闭后的真实数据状态及视觉行为需要设备验证。
