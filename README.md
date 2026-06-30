# Lovely Pet

Lovely Pet 是一个可复用的 macOS 桌宠商业化项目模板。目标是把宠物照片、客制化配置和交付流水线连接起来，持续生成不同客户的独立桌宠 app。

当前版本已经重构为开箱即用：克隆仓库后可以直接运行一个布偶猫 demo。这个 demo 不依赖外部图片资源，而是根据本轮照片里的稳定特征，用 SwiftUI 程序化绘制布偶猫角色，并通过 `pet.json` 驱动 idle、hover、tap 和 sleep 动作。

## Quick start

```bash
make validate
make run
```

打包独立 app：

```bash
make package
open "templates/macos-desktop-pet/dist/Lovely Pet Demo.app"
```

## Included

- 原生 Swift + AppKit + SwiftUI macOS 桌宠模板
- 透明悬浮窗口、菜单栏入口、hover 和点击互动
- 程序化布偶猫 demo，可直接运行
- manifest 动画状态机
- app 打包脚本
- 素材生产、构建、商业化和订单文档

## Structure

```text
docs/                         文档
templates/macos-desktop-pet/   macOS 桌宠模板
pipeline/                      schema、校验脚本、提示词
examples/ragdoll-demo/         本次照片对应的角色 profile
```

从 `docs/GETTING_STARTED.md` 开始阅读。
