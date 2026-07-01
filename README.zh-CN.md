# Lovely Pet

Lovely Pet 是一个可复用的 macOS 桌宠项目模板，用于把宠物素材、交互配置和原生 macOS 运行时组合成一个可独立运行的桌面陪伴应用。

[English](README.md)

当前版本开箱即用：克隆仓库后可以直接运行一个布偶猫示例。该示例不依赖外部图片资源，而是根据布偶猫的稳定视觉特征，用 SwiftUI 程序化绘制角色，并提供 hover、点击、双击、长按、分区触摸、亲密度记忆、缩放设置和睡眠节奏等轻量互动。

## 快速开始

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

## 包含内容

- 原生 Swift + AppKit + SwiftUI macOS 桌宠运行时
- 透明悬浮窗口、菜单栏入口、hover、点击、双击和长按互动
- 程序化布偶猫示例，可直接运行，不依赖图片素材
- 鼠标追踪、分区触摸、亲密度记忆、睡眠状态、缩放记忆和窗口位置记忆
- manifest 配置和校验脚本
- app 打包流程和 GitHub Actions 构建产物上传
- 设置、交互设计、素材准备、测试和工程审查文档

## 仓库结构

```text
docs/                         文档
templates/macos-desktop-pet/   macOS 桌宠运行时模板
pipeline/                      schema、校验脚本、素材提示词
examples/ragdoll-demo/         布偶猫角色 profile 和说明
```

## 关键文档

- `docs/GETTING_STARTED.md`
- `docs/INTERACTION_DESIGN.md`
- `docs/ENGINEERING_REVIEW.md`
- `docs/ASSET_PIPELINE.md`
- `docs/BUILD_PIPELINE.md`
- `docs/TESTING.md`
- `docs/ROADMAP.md`
- `examples/ragdoll-demo/CHARACTER_PROFILE.md`

## 当前重点

当前重点是提升桌宠的自然感和陪伴感：更自然的 hover、眼神跟随、分区触摸反馈、轻量亲密度记忆、睡眠节奏和稳定的 macOS 打包体验。
