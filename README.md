# Lovely Pet

Lovely Pet 是一个可复用的 macOS 桌宠项目模板，用于把宠物素材、交互配置和原生 macOS 运行时组合成一个可独立运行的桌面陪伴应用。

当前版本开箱即用：克隆仓库后可以直接运行一个布偶猫示例。该示例不依赖外部图片资源，而是根据布偶猫的稳定视觉特征，用 SwiftUI 程序化绘制角色，并提供 hover、点击、双击、长按、分区触摸、亲密度记忆和睡眠节奏等轻量互动。

## Quick start

```bash
make validate
make run
```

打包独立 app：

```bash
make package
open "templates/macos-desktop-pet/dist/Lovely Pet.app"
```

GitHub Actions 会生成可下载的构建产物：

```text
Lovely-Pet-macOS
```

## Included

- 原生 Swift + AppKit + SwiftUI macOS 桌宠模板
- 透明悬浮窗口、菜单栏入口、hover、点击和长按互动
- 程序化布偶猫示例，可直接运行
- 鼠标追踪、分区触摸、亲密度记忆、睡眠状态和缩放设置
- manifest 配置和校验入口
- app 打包脚本
- 素材、构建、交互、测试和工程审查文档

## Structure

```text
docs/                         文档
templates/macos-desktop-pet/   macOS 桌宠模板
pipeline/                      schema、校验脚本、提示词
examples/ragdoll-demo/         布偶猫角色 profile
```

## Key docs

- `docs/GETTING_STARTED.md`
- `docs/INTERACTION_DESIGN.md`
- `docs/ENGINEERING_REVIEW.md`
- `docs/TESTING.md`
- `docs/ROADMAP.md`
- `docs/GITHUB_OPERATIONS_NOTES.md`
- `examples/ragdoll-demo/CHARACTER_PROFILE.md`

## Current focus

当前重点是提升桌宠的自然感和陪伴感：更自然的 hover、点击反馈、眼神跟随、分区触摸、睡眠节奏、轻量养成和稳定的 macOS 打包体验。
