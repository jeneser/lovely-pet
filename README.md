# Lovely Pet

Lovely Pet 是一个面向 **macOS 桌宠客制化商业化** 的单仓库项目模板。它的目标不是做一次性的猫咪桌宠，而是建立一套可以持续复用的产品流水线：用户上传宠物素材、完成客制化配置和付款，系统生成一个独立可分发的 macOS 桌宠 `.app`。

## 产品定位

- **客户价值**：把真实宠物照片转成稳定、可互动、可运行的桌面宠物。
- **交付物**：独立 macOS 应用，不要求用户安装 Node、Python 或开发环境。
- **商业模式**：按宠物/按风格/按互动动作收费；高级包可包含更多动作、更多皮肤、签名下载、后续更新。
- **核心能力**：素材标准化、角色一致性、动画资产生成、桌宠模板实例化、收费与订单管理。

## 推荐架构

```text
lovely-pet/
  docs/                         # 产品、技术、商业化、流水线文档
  templates/macos-desktop-pet/   # 可实例化的原生 macOS 桌宠模板
  pipeline/                      # 素材生产、校验、打包流水线
  examples/cat-assets/           # 当前猫咪素材样例
  .github/workflows/             # 后续 CI/CD、构建、发布占位
```

## 技术路线

第一版建议采用 **Swift + AppKit + SwiftUI 设置面板 + 序列帧状态机**。原因是它最快能交付可运行 `.app`，并且不引入 Node/Python 运行时依赖。第二阶段再把主动画升级为 Live2D/骨骼动画，以降低动作扩展成本并提升 hover 互动丝滑度。

详见：

- [`docs/PRODUCT_SPEC.md`](docs/PRODUCT_SPEC.md)
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)
- [`docs/ASSET_PIPELINE.md`](docs/ASSET_PIPELINE.md)
- [`docs/BUILD_PIPELINE.md`](docs/BUILD_PIPELINE.md)
- [`docs/BUSINESS_AND_PAYMENT.md`](docs/BUSINESS_AND_PAYMENT.md)

## MVP 范围

MVP 不追求一次实现完整生成式平台，而是先打通收费交付闭环：

1. 固定一个 macOS 桌宠模板。
2. 支持一只宠物的 `idle / hover / tap / sleep` 状态。
3. 支持透明悬浮窗、拖拽、hover、点击反馈、菜单栏退出。
4. 支持 `pet.json` 配置驱动宠物名字、缩放、帧率、动作目录。
5. 支持通过流水线复制模板、注入素材、构建 `.app`、签名、压缩交付。

## 当前仓库状态

本仓库已经包含：

- 产品设计文档
- macOS 桌宠模板骨架
- 宠物素材生产提示词
- 配置 schema
- 构建流水线脚本草案
- 当前猫咪照片样例

## 本地构建方向

进入模板目录：

```bash
cd templates/macos-desktop-pet
swift build -c release
```

实际 `.app` 打包请参考 `pipeline/scripts/build-macos-app.sh`。该脚本预留了签名、notarization 和客户包输出位置。
