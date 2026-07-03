# Lovely Pet

Lovely Pet 是一个可复用的 macOS 桌宠项目模板，用于把宠物素材、交互配置和原生 macOS 运行时组合成一个可独立运行的桌面陪伴应用。

[English](README.md)

当前版本开箱即用：克隆仓库后可以直接运行一个布偶猫示例。该示例使用 `Resources/pets/default/frames` 下由 `pet.json` 驱动的透明 PNG 图片帧，并提供 hover、点击、双击爱心反馈、长按/拖拽反馈、触摸分区、缩放设置和睡眠节奏等轻量互动。

## 快速开始

```bash
make validate
make run
```

用 Xcode 打开：

```bash
make xcode
```

打包独立 app：

```bash
make package
open "templates/macos-desktop-pet/dist/Lovely Pet.app"
```

GitHub Actions 会按 CI 矩阵中的 macOS runner 生成可下载构建产物。

## 包含内容

- 原生 Swift + AppKit + SwiftUI macOS 桌宠运行时
- 透明悬浮窗口，以及只包含 Settings 和 Quit 的状态栏菜单
- hover、点击、双击、长按和触摸分区互动
- 通过 `pet.json` 加载的 PNG 逐帧布偶猫示例
- 鼠标追踪、触摸分区视觉反馈、增强的爱心反馈、睡眠状态、缩放记忆和窗口位置记忆
- manifest 配置和校验脚本
- 基于 Swift Package 的 Xcode 调试支持
- app 打包流程和 GitHub Actions 构建产物上传
- 设置、Xcode 调试、交互设计、运行安全、素材准备、测试和工程审查文档

## 仓库结构

```text
docs/                         文档
templates/macos-desktop-pet/   macOS 桌宠运行时模板
pipeline/                      schema、校验脚本、素材提示词
examples/ragdoll-demo/         布偶猫角色 profile 和说明
```

## 关键文档

- `docs/GETTING_STARTED.md`
- `docs/XCODE_DEBUGGING.md`
- `docs/INTERACTION_DESIGN.md`
- `docs/RUNTIME_SAFETY.md`
- `docs/ENGINEERING_REVIEW.md`
- `docs/ASSET_PIPELINE.md`
- `docs/BUILD_PIPELINE.md`
- `docs/TESTING.md`
- `docs/ROADMAP.md`
- `examples/ragdoll-demo/CHARACTER_PROFILE.md`

## 当前重点

当前重点是在 PNG 图片帧播放基础上提升桌宠的自然感和陪伴感：更自然的 hover、鼠标感知移动、触摸分区视觉反馈、更强且不显示文字的双击视觉反馈、睡眠节奏、可预测的本地状态、Xcode 友好调试和稳定的 macOS 打包体验。
