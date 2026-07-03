# Desktop Pet Interaction Design

可玩性决定用户是否愿意持续使用。Lovely Pet 的互动设计目标不是做一个复杂游戏，而是做一个低打扰、高情绪回报、持续陪伴感强的桌面角色。

## Core loop

```text
notice -> react -> visual reward -> settle
```

用户把鼠标移到桌宠上，桌宠注意到用户；用户点击不同身体区域，桌宠给出对应视觉反馈；反馈结束后自然回到待机。每次互动都应该短、轻、可重复。

## Implemented in current runtime

| Interaction | Behavior | Product value |
|---|---|---|
| Idle | PNG 帧播放叠加轻微呼吸、眨眼或尾部变化 | 让桌宠像活着，而不是静态贴纸 |
| Hover | PNG 状态切换，叠加抬升、轻微缩放、视线跟随和姿态偏移 | 让用户感到它注意到了自己 |
| Cursor tracking | 根据鼠标在窗口中的相对位置更新 gazeX/gazeY | 形成被回应、被关注的感觉 |
| Touch zones | 根据窗口坐标区分 head、tail、paw、body，并显示对应视觉反馈 | 让互动从普通点击变成空间化触摸 |
| Tap reward | 短暂抬升、sparkle、触摸分区反馈，并自然回到 idle | 立即奖励，适合反复点击 |
| Double tap | 更强的撒爱心视觉反馈，无文字气泡、无计数增长 | 做出更强但低打扰的情绪回报 |
| Long press / drag | 长按进入 dragging/startled 反馈，释放后恢复 | 增加玩耍感和角色边界感 |
| Idle timeout | 长时间无互动进入 sleepy 状态 | 形成日常陪伴节奏 |
| Scale setting | 设置面板中的缩放会同步调整 PNG 宠物视图和透明窗口 | 避免放大后裁切或只缩放窗口 |

## Interaction state model

Runtime state is represented by `PetInteractionModel`:

```text
hovering
tapping
celebrating
celebrationStartedAt
asleep
dragging
gazeX / gazeY
message
touchedZone
```

This separates product interaction state from the rendering layer. Future renderers can reuse the same model.

## Current runtime constraints

- The visible character is rendered from PNG frames, not from procedural SwiftUI shapes.
- SwiftUI shapes are used only as lightweight feedback around the image frames, such as hearts, sparkles, simple punctuation, shadows, and bubbles.
- Double-click feedback is visual-only and should not show affection counts or text bubbles.
- The status bar menu currently exposes Settings and Quit only.
- Resetting the saved window position is available through local data reset, not as a standalone status bar menu item.

## Future upgrade ideas

1. Mood meter: 根据互动频率切换开心、困、好奇、安静等状态。
2. Idle surprises: 长时间待机会伸懒腰、打哈欠、睡觉、洗脸。
3. Treat mode: 点击投喂，桌宠扑向小零食。
4. Desk awareness: 靠近屏幕边缘时趴下或探头。
5. Daily rhythm: 白天活跃，晚上睡觉。
6. Seasonal skins: 节日蝴蝶结、围巾、生日帽等扩展。
7. Collection loop: 解锁动作、表情和装饰。
8. Multi-pet mode: 多只宠物互相看、靠近、打招呼。

## Design constraints

- 每个反馈尽量小于 1 秒，避免打扰工作。
- 桌宠不能抢占大量屏幕空间。
- 默认不要播放声音；声音必须可关闭。
- 所有互动都必须能自然回到 idle。
- 高级动作应通过 manifest 或资源包扩展，不要硬编码到客户项目。
- 双击反馈应优先使用视觉效果，不显示文字气泡。
- 互动不应依赖点击计数或亲密度计数 UI。
- 文档和注释必须以当前代码为事实依据；不要保留已经移除的菜单项、计数器或拟人化文案。

## Next implementation backlog

1. Add alpha hit testing for transparent window areas.
2. Add true drag-specific reaction while moving the window.
3. Add a treat mini-game.
4. Add asset-backed skin switching.
