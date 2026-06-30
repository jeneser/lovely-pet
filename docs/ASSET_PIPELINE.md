# Asset Pipeline

## Principle

Do not turn random pet photos directly into a video. First lock a stable 2D character identity, then create key poses, then produce animation-ready frames or layered assets.

The highest-risk failure is identity drift: face shape, coat pattern, eye color, body ratio, or lighting changes between frames.

## Workflow

1. Select 12-30 high-quality reference photos.
2. Generate one gold-standard character image.
3. Generate a small set of key poses.
4. QA identity consistency.
5. Produce transparent PNG frames or layered parts.
6. Place final assets into the pet resource folder.
7. Validate `pet.json`.
8. Build the customer app.

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

## Prompt: Layered Parts

```text
把这只猫输出为可制作 2D 骨骼动画的分层素材设计稿。请分别生成并清晰标注这些层：头部、身体、左前腿、右前腿、左后腿、右后腿、尾巴、左耳、右耳、左眼、右眼、嘴部。每个部件边缘需要被合理补全，允许对被遮挡区域进行补画，以便后续旋转、位移和轻微变形。保持透明背景、角色一致、结构清晰，不要添加任何多余装饰。
```

## QA Rubric

| Dimension | Requirement |
|---|---|
| Identity | Still recognizably the same pet |
| Coat pattern | Stable facial and body markings |
| Perspective | No major camera or body-ratio drift |
| Edge quality | Clean alpha, no background residue |
| Animation readability | Pose intention is clear |
| Rig suitability | Limbs, tail, ears can be separated |

## Recommended Directory

```text
examples/cat-assets/
  raw-photos/
  selected/
  character/
  poses/
  layered/
  final-frames/
```
