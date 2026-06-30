# Desktop Pet Interaction Design

可玩性决定用户是否愿意付费。Lovely Pet 的互动设计目标不是做一个复杂游戏，而是做一个低打扰、高情绪回报、持续陪伴感强的桌面角色。

## Core loop

```text
notice -> react -> reward -> settle
```

用户把鼠标移到桌宠上，桌宠注意到用户；用户点击或拖动，桌宠给出短反馈；反馈结束后自然回到待机。每次互动都应该短、轻、可重复。

## Implemented in current demo

| Interaction | Behavior | Product value |
|---|---|---|
| Idle | 呼吸起伏、轻微尾巴摆动、自然眨眼 | 让桌宠像活着，而不是静态贴纸 |
| Hover | 抬头、放大、耳朵竖起、眼睛变大、尾巴更活跃 | 让用户感到它注意到了自己 |
| Cursor tracking | 眼睛和头部轻微跟随鼠标位置 | 形成被回应、被关注的感觉 |
| Tap | 小跳、旋转、sparkle、亲密度 +1 | 立即奖励，适合反复点击 |
| Double tap | 爱心、短文案、亲密度 +3 | 做出更强的情绪回报 |
| Idle timeout | 长时间无互动进入 sleepy 状态 | 形成日常陪伴节奏 |
| Affection badge | 显示亲密度计数 | 给用户一个轻量成长目标 |

## Interaction state model

Runtime state is now represented by `PetInteractionModel`:

```text
hovering
tapping
celebrating
asleep
affection
gazeX / gazeY
message
```

This separates product interaction state from the rendering layer. Future renderers can reuse the same model.

## Paid upgrade ideas

1. Petting zones: 摸头、摸背、摸尾巴触发不同反应。
2. Mood meter: 根据互动频率切换开心、困、好奇、傲娇。
3. Idle surprises: 长时间待机会伸懒腰、打哈欠、睡觉、洗脸。
4. Treat mode: 点击投喂，桌宠扑向小零食。
5. Desk awareness: 靠近屏幕边缘时趴下或探头。
6. Daily rhythm: 白天活跃，晚上睡觉。
7. Seasonal skins: 节日蝴蝶结、围巾、生日帽等付费扩展。
8. Collection loop: 解锁动作、表情和装饰。

## Design constraints

- 每个反馈尽量小于 1 秒，避免打扰工作。
- 桌宠不能抢占大量屏幕空间。
- 默认不要播放声音；声音必须可关闭。
- 所有互动都必须能自然回到 idle。
- 高级动作应通过 manifest 或资源包扩展，不要硬编码到客户项目。

## Next implementation backlog

1. Add hit zones for head, back, tail, and paws.
2. Persist position, scale, and affection in user defaults.
3. Add alpha hit testing for transparent window areas.
4. Add drag-specific reaction while moving the pet.
5. Add a treat mini-game.
6. Add asset-backed skin switching.
