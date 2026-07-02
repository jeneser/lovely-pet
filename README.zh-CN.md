# Lovely Pet

Lovely Pet 是一个可复用的 macOS 桌宠项目模板，用于把宠物素材、交互配置和原生 macOS 运行时组合成一个可独立运行的桌面陪伴应用。

[English](README.md)

当前版本开箱即用：克隆仓库后会运行一个基于透明 PNG 序列帧的布偶猫示例。运行时从 `pet.json` 读取 idle、hover、tap、sleep、walk 等状态，启动时预加载素材，并使用与屏幕刷新同步的播放器驱动动画。SwiftUI 程序化布偶猫渲染器已移除，实际展示效果以仓库中的图片素材为准。

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

GitHub Actions 会按 runner 生成可下载构建产物，例如：

```text
Lovely-Pet-macOS-macos-14
```

## 包含内容

- 原生 Swift + AppKit + SwiftUI macOS 桌宠运行时
- Dock 上方透明窗口、菜单栏入口、hover、点击、双击、长按和 Dock 漫步控制
- idle、hover、tap、sleep、walk_right、walk_left 的 PNG 序列帧动画
- `CVDisplayLink` 帧同步、过渡帧和启动预加载
- 鼠标追踪、分区触摸、亲密度记忆、睡眠状态、缩放记忆和窗口位置记忆
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

当前重点是提升桌宠的自然感和陪伴感：更流畅的 PNG 序列帧播放、带过渡缓冲的状态切换、Dock 上方漫步、自然 hover、眼神跟随、分区触摸反馈、轻量亲密度记忆、睡眠节奏、可预测的本地状态、Xcode 友好调试和稳定的 macOS 打包体验。
