# FanqieX — 签名工具兼容与验收

## 版本与边界

运行时仍为 **FanqieX 1.6.2**；本次分发修订为 **1.6.2-1（signing-r1）**。
不改名、不修改去广告或液态玻璃代码、不重置设置，不把打包修订冒充功能升级。
所有容器内的 dylib 必须与冻结的 1.6.2 逐字节一致：

`8784d9d4a065d2bff4dc9f602e503a80bc41c877937d02ebb019e1dbfb0a9a01`

本工程没有这些闭源签名 App 的真机自动化环境；**不能声称所有版本、证书和设备全部适配通过**。
自动验证分为包结构/负对照、真实发布文件、Apple codesign 重签名三层；三者都不替代设备安装与视觉验收。
签名工具支持导入某种格式，不等于特定宿主一定能运行。

## 交付格式

- `FanqieX-1.6.2.dylib`：首选，直接使用签名工具的注入/添加第三方库功能。
- `FanqieX-1.6.2-1.deb`：为支持 DEB 提取注入的工具提供同一 dylib；使用 gzip/USTAR/标准 ar，
  没有安装脚本、没有 Substrate/ElleKit 依赖，也不携带证书。**这是注入载体，不是越狱安装器。**
- `FanqieX-1.6.2-signing-r1.zip`：上述文件、说明、审计和 SHA-256 校验值的集合，先解压再选择一种插件格式。

不要把 `.dylib` 与 `.deb` 同时注入。不要把 ZIP 当作 IPA 安装。

## 工具路线

| 工具 | 使用路线 | 本轮能验证的范围 | 设备状态 |
| --- | --- | --- | --- |
| 全能签 | 添加/注入原始 `.dylib` 后重签名整个 IPA | 官方明确提供 dylib 注入；插件结构与加载条件由 CI 检查 | 未验收 |
| 轻松签 ESign | 在应用签名选项中添加第三方库，选择 `.dylib` | 官方渠道明确支持注入库；实际界面名称以工具版本为准 | 未验收 |
| Feather | 选择添加 tweak，导入 `.dylib` 或 `.deb`，只选一个 | 官方声明支持两种格式；DEB 用标准解包器验证内容一致 | 未验收 |
| Sideloadly | Tweak Injection 中导入 `.dylib` 或 `.deb` | 官方支持这些输入；官方也明确不保证所有越狱插件可用于免越狱环境 | 未验收 |
| 其他支持动态库注入的签名工具 | 首选单独 `.dylib`；签完后导出 IPA 做预检 | 只验证通用文件与加载规范，不假定某个闭源工具内部实现 | 未验收 |
| 只接受 IPA、没有插件注入功能的工具 | 先用注入工具生成 IPA，再由该工具重签名 | 单独把 dylib 导入此类工具不能代替宿主加载命令 | 未验收 |

## 安装条件

1. 使用自己有权处理、未加密且与插件兼容的宿主 IPA。预检发现加密会停止，不做解密或破解。
2. 在签名工具中移除旧的 `FanqieAdBlock*.dylib` / `FanqieX*.dylib` 及其加载引用，
   再加入本版一份插件。**不要求卸载手机里的阅读 App，不要因此丢失本地书籍与设置。**
3. 插件和宿主必须一起重签名，使用同一有效签名身份及匹配的描述文件。
   分发时的 ad-hoc 签名仅用于完整性检查，不能用于普通 iPhone 安装。
4. 不需要额外注入 Substrate、Substitute、ElleKit。本版只有已审核的苹果系统依赖；
   不要启用会错误删除插件或更改其代码的“清理插件”选项。不要为安装任意添加高权限 entitlement。
5. 不要自行改 dylib 文件名或硬改加载地址。包内安装名为 `@rpath/FanqieX-1.6.2.dylib`；
   宿主真正使用的加载命令必须能找到工具实际放入的文件。
   `@executable_path/`、`@loader_path/`、`@rpath/` 三类常见应用内路径均由预检覆盖。
6. 分身修改 Bundle ID 不是本预检的拒绝条件，但不保证宿主登录、推送、钥匙串和原有内部校验能在分身中工作。
   本修订不修改原插件内部宿主校验，不绕过签名或系统权限。

## 可复现检查

```sh
# 检查冻结的真实 dylib，不执行它
python3 scripts/signing_compat.py audit dist/1.6.2/FanqieX-1.6.2.dylib

# 验证原 ad-hoc 页哈希并生成可复现分发包
python3 scripts/signing_compat.py package dist/1.6.2/FanqieX-1.6.2.dylib --output build/signing

# 读取签名工具导出的 IPA；不会修改、提取到磁盘或上传其中任何内容
python3 scripts/signing_compat.py ipa /path/to/your-signed.ipa
```

IPA 预检检查主应用、ARM64/FAT 切片、加密标记、已知产品名的重复旧库、
每个 ARM64 宿主切片的直接加载引用、缺失 rpath、插件代码是否改变、签名数据是否存在，
并拒绝 ZIP 路径穿越、大小写冲突、符号链接与超限读取。
弱链接会提示可能“安装成功但插件没加载”。

边界：预检面向**直接加载命令注入**，不宣称支持任意额外加载器/运行时 dlopen 方案；
不验证证书链、吊销、UDID、描述文件权限或系统加载结果；不能识别所有被任意改名的第三方重复插件。
真实签名可信度和实际启动必须在设备上验收。

CI 的 macOS 步骤使用 Apple `codesign` 去签再重签，在不同文件位置/名称上验证签名与代码不变；
包括 `__FQPATCH` 段，不能只检查普通 `__text` 节而漏掉补丁代码。
这仍是 ad-hoc 重签名工具链测试，不是 ESign、全能签或 iPhone 安装测试。

## 设备验收记录

每个实际使用的工具分别记录：工具版本、宿主版本、iOS 版本、原 Bundle ID/分身情况、
注入格式、是否安装成功、是否冷启动成功、设置页 FanqieX 1.6.2 是否出现、
去广告/书架/阅读返回/底栏拖动是否正常。不要公开证书、私钥或用户识别信息。
失败时保留签名工具错误、宿主崩溃信息及插件导出诊断，不能把证书过期统称为插件不兼容。

## 一手资料

- 全能签开发者网站：https://udid.nuosike.cn/sign/
- ESign 官方发布渠道：https://t.me/s/tgqsw/98 （链接到 esign.yyyue.xyz）
- Feather 官方：https://feather.claration.dev/
- Sideloadly 官方：https://sideloadly.io/faq
- Apple：动态库运行路径：https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/RunpathDependentLibraries.html
- Apple：iOS 代码签名与 Team ID：https://support.apple.com/en-gb/guide/security/sec7c917bf14/1/web/1

来源能力与本工程结果分开记录；公开能力不能替代实际验收结果。
