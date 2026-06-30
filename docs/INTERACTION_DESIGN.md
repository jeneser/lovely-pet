# Desktop Pet Interaction Design

可玩性决定用户是否愿意付费。Lovely Pet 的互动设计目标不是做一个复杂游戏，而是做一个低打扰、高情绪回报、持续陪伴感强的桌面角色。

## Core loop

```text
notice -> react -> reward -> settle
```

用户把鼠标移到桌宠上，桌宠注意到用户；用户点击或拖动，桌宠给出短反馈；反馈结束后自然回到待机。每次互动都应该短、轻、可重复。

## MVP interactions

| Interaction | Current behavior | Product value |
|---|---|---|
| Hover | 放大、抬起、耳朵更精神、眼睛更大、尾巴角度变化 | 让用户感到它注意到了自己 |
| Tap | 小跳、轻微旋转、黄色 sparkle | 立即奖励，适合反复点击 |
| Drag | 通过窗口背景拖动 | 用户可以把桌宠放在喜欢的位置 |
| Menu bar | 设置、退出、重置位置 | 降低打扰感 |

## Paid upgrade ideas

1. Cursor follow: 眼睛和头部跟随鼠标。
2. Petting zones: 摸头、摸背、摸尾巴触发不同反应。
3. Mood meter: 根据互动频率切换开心、困、好奇。
4. Idle surprises: 长时间待机会伸懒腰、打哈欠、睡觉。
5. Treat mode: 点击投喂，桌宠扑向小零食。
6. Desk awareness: 靠近屏幕边缘时趴下或探头。
7. Daily rhythm: 白天活跃，晚上睡觉。
8. Seasonal skins: 节日蝴蝶结、围巾、生日帽等付费扩展。

## Design constraints

- 每个反馈尽量小于 1 秒，避免打扰工作。
- 桌宠不能抢占大量屏幕空间。
- 默认不要播放声音；声音必须可关闭。
- 所有互动都必须能自然回到 idle。
- 高级动作应通过 manifest 或资源包扩展，不要硬编码到客户项目。

## Next implementation backlog

1. Add eye tracking toward cursor.
2. Add separate head and tail transforms.
3. Add double-click special reaction.
4. Add idle timeout to sleep.
5. Add alpha hit testing for transparent window areas.
6. Persist position and scale in user defaults.
