# Asset Pipeline

## Principle

Do not turn random pet photos directly into a video. First lock a stable 2D character identity, then create key poses, then produce animation-ready transparent PNG frames or layered assets.

The highest-risk failure is identity drift: face shape, coat pattern, eye color, body ratio, or lighting changes between frames.

## Workflow

1. Select 12-30 high-quality reference photos.
2. Generate one gold-standard character image.
3. Generate a small set of key poses.
4. QA identity consistency.
5. Produce transparent PNG frames or layered parts.
6. Add in-between frames for each runtime state.
7. Place final assets into the pet resource folder.
8. Validate `pet.json`.
9. Build the app bundle.

## Prompt: Character Lock

```text
请基于我提供的多张宠物猫照片，提炼出同一只猫的稳定角色设定。保持脸型、花色分布、耳朵形状、眼睛颜色、体型比例一致。输出为桌宠风格的 2D 角色立绘，视角统一为 3/4 侧前方，背景透明，主体完整，边缘干净，毛发轮廓清晰，整体适合后续做逐帧动画或骨骼动画。不要改变猫的辨识度，不要增加饰品，不要改变品种特征，不要出现额外肢体。
```

## Prompt: Idle Key Poses

```text
基于已经锁定身份的同一只猫角色，生成一组桌宠待机动作关键姿态，包含：自然站立、轻微呼吸、缓慢眨眼、尾巴轻摆、耳朵轻抖。要求每张图的角色比例、花色位置、视角、光照完全一致，背景透明，角色居中，适合作为同一动画状态的关键帧。保持四肢结构稳定，避免毛发纹理随机变化。
```

## Prompt: Hover Interaction

```text
基于同一只猫角色，生成一组用于鼠标 hover 互动的关键姿态：先注意到鼠标、耳朵竖起、眼睛跟随、身体微微前倾、抬前爪试探、恢复站立。动作情绪递进自然，适合在 0.8 到 1.2 秒内做顺滑过渡。所有姿态必须保持同一只猫的花色和体型一致，背景透明。
```

## Prompt: Walk Loop

```text
基于同一只猫角色，生成一组桌宠在 Dock 上方横向行走的关键姿态。动作包含左右前后腿交替、身体轻微上下起伏、尾巴保持自然平衡。要求 8 到 12 帧可首尾循环，透明背景，画布尺寸一致，脚底锚点对齐，右行动作可镜像为左行。
```

## Frame Targets

| State | Recommended frames | fps | Notes |
|---|---:|---:|---|
| `idle` | 8-12 | 12 | breathing, blink, tail sway |
| `hover` | 6-10 | 16 | attention, ears up, paw probe |
| `tap` | 5-8 | 18 | startle, hop, land, recover |
| `sleep` | 6-8 | 8 | slow breathing loop |
| `walk_right` / `walk_left` | 8-12 each | 14 | horizontal Dock walking loop |

## QA Rubric

| Dimension | Requirement |
|---|---|
| Identity | Still recognizably the same pet |
| Coat pattern | Stable facial and body markings |
| Perspective | No major camera or body-ratio drift |
| Edge quality | Clean alpha, no background residue |
| Animation readability | Pose intention is clear |
| Frame continuity | First and last loop frames connect without a visible hitch |
| Anchor consistency | Feet/body baseline stays aligned across frames |

## Runtime Directory

```text
templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/
  pet.json
  frames/
    idle/
    hover/
    tap/
    sleep/
    walk_right/
    walk_left/
    idle_to_hover/
    hover_to_idle/
```
