# Imported action sprite sheets

The Google Drive bundle was normalized into runtime sprite sheets that match the existing `320x340` per-frame crop contract.

## Output contract

- Frame canvas: `320x340`
- Frames per action: `20`
- Sheet size per action: `6400x340`
- Layout: one horizontal row, addressed by `#0` through `#19`.
- The importer uses a fixed slot width and bottom-aligned paste position per frame, which prevents crop drift in `FrameAnimationPlayer`.

## Actions

| State | Source | Output sheet | FPS | Loop | Notes |
|---|---|---|---:|---:|---|
| `eat` | `eat_20f_row.png` | `frames/eat/eat-20f-sheet.png` | 8 | `false` | Approach food, eat, lift head, and settle back to an idle-compatible pose. |
| `playPaperBall` | `play_paper_ball_20f_row.png` | `frames/play-paper-ball/play-paper-ball-20f-sheet.png` | 10 | `false` | Notice, paw, crouch, pounce, and recover beside the paper ball. |
| `roll` | `roll_20f_row.png` | `frames/roll/roll-20f-sheet.png` | 8 | `true` | Continuous floor roll / belly-up loop; kept looping to avoid a direct lying-to-standing snap. |
| `groom` | `groom_20f_row.png` | `frames/groom/groom-20f-sheet.png` | 8 | `false` | Sit, lower head, lick chest/paw, wipe face, and return to idle-compatible sitting. |
| `run` | `run_20f_row.png` | `frames/run/run-20f-sheet.png` | 12 | `true` | Loopable side-view running cycle. |
| `walk` | `walk_20f_row.png` | `frames/walk/walk-20f-sheet.png` | 8 | `true` | Loopable side-view walking cycle. |
| `yawn` | `yawn_20f_row.png` | `frames/yawn/yawn-20f-sheet.png` | 8 | `false` | Idle-compatible sitting yawn that opens, peaks, closes, and returns to calm. |
| `meow` | `meow_20f_row.png` | `frames/meow/meow-20f-sheet.png` | 8 | `false` | Idle-compatible meow expression cycle that returns to calm. |

## Import measurements

### `eat`

```json
{
  "source": "/tmp/cat_action_sprites_20f_row/cat_action_sprites_20f_row/eat_20f_row.png",
  "target": "templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames/eat/eat-20f-sheet.png",
  "source_size": [
    2172,
    724
  ],
  "output_size": [
    6400,
    340
  ],
  "source_slot_count": 20,
  "frame_width": 320,
  "frame_height": 340,
  "scale": 1.745,
  "detected_main_components": 20,
  "max_source_crop_size": [
    138,
    149
  ],
  "frames": [
    {
      "index": 0,
      "source_slot": [
        0,
        109
      ],
      "source_box": [
        0,
        290,
        131,
        430
      ],
      "render_size": [
        229,
        244
      ],
      "frame_rect": [
        0,
        0,
        320,
        340
      ],
      "paste_xy": [
        45,
        76
      ]
    },
    {
      "index": 1,
      "source_slot": [
        109,
        217
      ],
      "source_box": [
        113,
        300,
        251,
        436
      ],
      "render_size": [
        241,
        237
      ],
      "frame_rect": [
        320,
        0,
        320,
        340
      ],
      "paste_xy": [
        359,
        83
      ]
    },
    {
      "index": 2,
      "source_slot": [
        217,
        326
      ],
      "source_box": [
        234,
        304,
        371,
        437
      ],
      "render_size": [
        239,
        232
      ],
      "frame_rect": [
        640,
        0,
        320,
        340
      ],
      "paste_xy": [
        680,
        88
      ]
    },
    {
      "index": 3,
      "source_slot": [
        326,
        434
      ],
      "source_box": [
        355,
        306,
        485,
        436
      ],
      "render_size": [
        227,
        227
      ],
      "frame_rect": [
        960,
        0,
        320,
        340
      ],
      "paste_xy": [
        1006,
        93
      ]
    },
    {
      "index": 4,
      "source_slot": [
        434,
        543
      ],
      "source_box": [
        469,
        310,
        600,
        436
      ],
      "render_size": [
        229,
        220
      ],
      "frame_rect": [
        1280,
        0,
        320,
        340
      ],
      "paste_xy": [
        1325,
        100
      ]
    },
    {
      "index": 5,
      "source_slot": [
        543,
        652
      ],
      "source_box": [
        592,
        310,
        717,
        435
      ],
      "render_size": [
        218,
        218
      ],
      "frame_rect": [
        1600,
        0,
        320,
        340
      ],
      "paste_xy": [
        1651,
        102
      ]
    },
    {
      "index": 6,
      "source_slot": [
        652,
        760
      ],
      "source_box": [
        706,
        313,
        830,
        434
      ],
      "render_size": [
        216,
        211
      ],
      "frame_rect": [
        1920,
        0,
        320,
        340
      ],
      "paste_xy": [
        1972,
        109
      ]
    },
    {
      "index": 7,
      "source_slot": [
        760,
        869
      ],
      "source_box": [
        818,
        312,
        939,
        435
      ],
      "render_size": [
        211,
        215
      ],
      "frame_rect": [
        2240,
        0,
        320,
        340
      ],
      "paste_xy": [
        2294,
        105
      ]
    },
    {
      "index": 8,
      "source_slot": [
        869,
        977
      ],
      "source_box": [
        926,
        315,
        1042,
        435
      ],
      "render_size": [
        202,
        209
      ],
      "frame_rect": [
        2560,
        0,
        320,
        340
      ],
      "paste_xy": [
        2619,
        111
      ]
    },
    {
      "index": 9,
      "source_slot": [
        977,
        1086
      ],
      "source_box": [
        1030,
        316,
        1151,
        435
      ],
      "render_size": [
        211,
        208
      ],
      "frame_rect": [
        2880,
        0,
        320,
        340
      ],
      "paste_xy": [
        2934,
        112
      ]
    },
    {
      "index": 10,
      "source_slot": [
        1086,
        1195
      ],
      "source_box": [
        1141,
        317,
        1260,
        436
      ],
      "render_size": [
        208,
        208
      ],
      "frame_rect": [
        3200,
        0,
        320,
        340
      ],
      "paste_xy": [
        3256,
        112
      ]
    },
    {
      "index": 11,
      "source_slot": [
        1195,
        1303
      ],
      "source_box": [
        1250,
        317,
        1365,
        436
      ],
      "render_size": [
        201,
        208
      ],
      "frame_rect": [
        3520,
        0,
        320,
        340
      ],
      "paste_xy": [
        3579,
        112
      ]
    },
    {
      "index": 12,
      "source_slot": [
        1303,
        1412
      ],
      "source_box": [
        1358,
        315,
        1477,
        436
      ],
      "render_size": [
        208,
        211
      ],
      "frame_rect": [
        3840,
        0,
        320,
        340
      ],
      "paste_xy": [
        3896,
        109
      ]
    },
    {
      "index": 13,
      "source_slot": [
        1412,
        1520
      ],
      "source_box": [
        1472,
        317,
        1586,
        436
      ],
      "render_size": [
        199,
        208
      ],
      "frame_rect": [
        4160,
        0,
        320,
        340
      ],
      "paste_xy": [
        4220,
        112
      ]
    },
    {
      "index": 14,
      "source_slot": [
        1520,
        1629
      ],
      "source_box": [
        1589,
        302,
        1688,
        436
      ],
      "render_size": [
        173,
        234
      ],
      "frame_rect": [
        4480,
        0,
        320,
        340
      ],
      "paste_xy": [
        4553,
        86
      ]
    },
    {
      "index": 15,
      "source_slot": [
        1629,
        1738
      ],
      "source_box": [
        1681,
        295,
        1775,
        436
      ],
      "render_size": [
        164,
        246
      ],
      "frame_rect": [
        4800,
        0,
        320,
        340
      ],
      "paste_xy": [
        4878,
        74
      ]
    },
    {
      "index": 16,
      "source_slot": [
        1738,
        1846
      ],
      "source_box": [
        1774,
        294,
        1866,
        436
      ],
      "render_size": [
        161,
        248
      ],
      "frame_rect": [
        5120,
        0,
        320,
        340
      ],
      "paste_xy": [
        5199,
        72
      ]
    },
    {
      "index": 17,
      "source_slot": [
        1846,
        1955
      ],
      "source_box": [
        1853,
        288,
        1961,
        436
      ],
      "render_size": [
        188,
        258
      ],
      "frame_rect": [
        5440,
        0,
        320,
        340
      ],
      "paste_xy": [
        5506,
        62
      ]
    },
    {
      "index": 18,
      "source_slot": [
        1955,
        2063
      ],
      "source_box": [
        1950,
        290,
        2059,
        437
      ],
      "render_size": [
        190,
        257
      ],
      "frame_rect": [
        5760,
        0,
        320,
        340
      ],
      "paste_xy": [
        5825,
        63
      ]
    },
    {
      "index": 19,
      "source_slot": [
        2063,
        2172
      ],
      "source_box": [
        2043,
        288,
        2151,
        437
      ],
      "render_size": [
        188,
        260
      ],
      "frame_rect": [
        6080,
        0,
        320,
        340
      ],
      "paste_xy": [
        6146,
        60
      ]
    }
  ]
}
```

### `playPaperBall`

```json
{
  "source": "/tmp/cat_action_sprites_20f_row/cat_action_sprites_20f_row/play_paper_ball_20f_row.png",
  "target": "templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames/play-paper-ball/play-paper-ball-20f-sheet.png",
  "source_size": [
    2172,
    724
  ],
  "output_size": [
    6400,
    340
  ],
  "source_slot_count": 20,
  "frame_width": 320,
  "frame_height": 340,
  "scale": 1.4815,
  "detected_main_components": 17,
  "max_source_crop_size": [
    189,
    148
  ],
  "frames": [
    {
      "index": 0,
      "source_slot": [
        0,
        109
      ],
      "source_box": [
        10,
        285,
        146,
        432
      ],
      "render_size": [
        201,
        218
      ],
      "frame_rect": [
        0,
        0,
        320,
        340
      ],
      "paste_xy": [
        59,
        102
      ]
    },
    {
      "index": 1,
      "source_slot": [
        109,
        217
      ],
      "source_box": [
        126,
        284,
        261,
        432
      ],
      "render_size": [
        200,
        219
      ],
      "frame_rect": [
        320,
        0,
        320,
        340
      ],
      "paste_xy": [
        380,
        101
      ]
    },
    {
      "index": 2,
      "source_slot": [
        217,
        326
      ],
      "source_box": [
        254,
        288,
        393,
        432
      ],
      "render_size": [
        206,
        213
      ],
      "frame_rect": [
        640,
        0,
        320,
        340
      ],
      "paste_xy": [
        697,
        107
      ]
    },
    {
      "index": 3,
      "source_slot": [
        326,
        434
      ],
      "source_box": [
        385,
        286,
        503,
        432
      ],
      "render_size": [
        175,
        216
      ],
      "frame_rect": [
        960,
        0,
        320,
        340
      ],
      "paste_xy": [
        1032,
        104
      ]
    },
    {
      "index": 4,
      "source_slot": [
        434,
        543
      ],
      "source_box": [
        385,
        286,
        503,
        432
      ],
      "render_size": [
        175,
        216
      ],
      "frame_rect": [
        1280,
        0,
        320,
        340
      ],
      "paste_xy": [
        1352,
        104
      ]
    },
    {
      "index": 5,
      "source_slot": [
        543,
        652
      ],
      "source_box": [
        506,
        285,
        623,
        432
      ],
      "render_size": [
        173,
        218
      ],
      "frame_rect": [
        1600,
        0,
        320,
        340
      ],
      "paste_xy": [
        1673,
        102
      ]
    },
    {
      "index": 6,
      "source_slot": [
        652,
        760
      ],
      "source_box": [
        612,
        294,
        754,
        433
      ],
      "render_size": [
        210,
        206
      ],
      "frame_rect": [
        1920,
        0,
        320,
        340
      ],
      "paste_xy": [
        1975,
        114
      ]
    },
    {
      "index": 7,
      "source_slot": [
        760,
        869
      ],
      "source_box": [
        711,
        311,
        900,
        433
      ],
      "render_size": [
        280,
        181
      ],
      "frame_rect": [
        2240,
        0,
        320,
        340
      ],
      "paste_xy": [
        2260,
        139
      ]
    },
    {
      "index": 8,
      "source_slot": [
        869,
        977
      ],
      "source_box": [
        895,
        324,
        1029,
        433
      ],
      "render_size": [
        199,
        161
      ],
      "frame_rect": [
        2560,
        0,
        320,
        340
      ],
      "paste_xy": [
        2620,
        159
      ]
    },
    {
      "index": 9,
      "source_slot": [
        977,
        1086
      ],
      "source_box": [
        1021,
        327,
        1159,
        433
      ],
      "render_size": [
        204,
        157
      ],
      "frame_rect": [
        2880,
        0,
        320,
        340
      ],
      "paste_xy": [
        2938,
        163
      ]
    },
    {
      "index": 10,
      "source_slot": [
        1086,
        1195
      ],
      "source_box": [
        1021,
        327,
        1159,
        433
      ],
      "render_size": [
        204,
        157
      ],
      "frame_rect": [
        3200,
        0,
        320,
        340
      ],
      "paste_xy": [
        3258,
        163
      ]
    },
    {
      "index": 11,
      "source_slot": [
        1195,
        1303
      ],
      "source_box": [
        1161,
        313,
        1291,
        433
      ],
      "render_size": [
        193,
        178
      ],
      "frame_rect": [
        3520,
        0,
        320,
        340
      ],
      "paste_xy": [
        3583,
        142
      ]
    },
    {
      "index": 12,
      "source_slot": [
        1303,
        1412
      ],
      "source_box": [
        1272,
        312,
        1405,
        433
      ],
      "render_size": [
        197,
        179
      ],
      "frame_rect": [
        3840,
        0,
        320,
        340
      ],
      "paste_xy": [
        3901,
        141
      ]
    },
    {
      "index": 13,
      "source_slot": [
        1412,
        1520
      ],
      "source_box": [
        1392,
        315,
        1530,
        433
      ],
      "render_size": [
        204,
        175
      ],
      "frame_rect": [
        4160,
        0,
        320,
        340
      ],
      "paste_xy": [
        4218,
        145
      ]
    },
    {
      "index": 14,
      "source_slot": [
        1520,
        1629
      ],
      "source_box": [
        1508,
        319,
        1652,
        435
      ],
      "render_size": [
        213,
        172
      ],
      "frame_rect": [
        4480,
        0,
        320,
        340
      ],
      "paste_xy": [
        4533,
        148
      ]
    },
    {
      "index": 15,
      "source_slot": [
        1629,
        1738
      ],
      "source_box": [
        1647,
        326,
        1768,
        438
      ],
      "render_size": [
        179,
        166
      ],
      "frame_rect": [
        4800,
        0,
        320,
        340
      ],
      "paste_xy": [
        4870,
        154
      ]
    },
    {
      "index": 16,
      "source_slot": [
        1738,
        1846
      ],
      "source_box": [
        1647,
        326,
        1768,
        438
      ],
      "render_size": [
        179,
        166
      ],
      "frame_rect": [
        5120,
        0,
        320,
        340
      ],
      "paste_xy": [
        5190,
        154
      ]
    },
    {
      "index": 17,
      "source_slot": [
        1846,
        1955
      ],
      "source_box": [
        1751,
        336,
        1891,
        438
      ],
      "render_size": [
        207,
        151
      ],
      "frame_rect": [
        5440,
        0,
        320,
        340
      ],
      "paste_xy": [
        5496,
        169
      ]
    },
    {
      "index": 18,
      "source_slot": [
        1955,
        2063
      ],
      "source_box": [
        1872,
        333,
        1993,
        440
      ],
      "render_size": [
        179,
        159
      ],
      "frame_rect": [
        5760,
        0,
        320,
        340
      ],
      "paste_xy": [
        5830,
        161
      ]
    },
    {
      "index": 19,
      "source_slot": [
        2063,
        2172
      ],
      "source_box": [
        1997,
        302,
        2127,
        439
      ],
      "render_size": [
        193,
        203
      ],
      "frame_rect": [
        6080,
        0,
        320,
        340
      ],
      "paste_xy": [
        6143,
        117
      ]
    }
  ]
}
```

### `roll`

```json
{
  "source": "/tmp/cat_action_sprites_20f_row/cat_action_sprites_20f_row/roll_20f_row.png",
  "target": "templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames/roll/roll-20f-sheet.png",
  "source_size": [
    2172,
    724
  ],
  "output_size": [
    6400,
    340
  ],
  "source_slot_count": 20,
  "frame_width": 320,
  "frame_height": 340,
  "scale": 1.0145,
  "detected_main_components": 15,
  "max_source_crop_size": [
    276,
    124
  ],
  "frames": [
    {
      "index": 0,
      "source_slot": [
        0,
        109
      ],
      "source_box": [
        10,
        308,
        164,
        424
      ],
      "render_size": [
        156,
        118
      ],
      "frame_rect": [
        0,
        0,
        320,
        340
      ],
      "paste_xy": [
        82,
        202
      ]
    },
    {
      "index": 1,
      "source_slot": [
        109,
        217
      ],
      "source_box": [
        154,
        308,
        299,
        426
      ],
      "render_size": [
        147,
        120
      ],
      "frame_rect": [
        320,
        0,
        320,
        340
      ],
      "paste_xy": [
        406,
        200
      ]
    },
    {
      "index": 2,
      "source_slot": [
        217,
        326
      ],
      "source_box": [
        154,
        308,
        299,
        426
      ],
      "render_size": [
        147,
        120
      ],
      "frame_rect": [
        640,
        0,
        320,
        340
      ],
      "paste_xy": [
        726,
        200
      ]
    },
    {
      "index": 3,
      "source_slot": [
        326,
        434
      ],
      "source_box": [
        290,
        312,
        421,
        428
      ],
      "render_size": [
        133,
        118
      ],
      "frame_rect": [
        960,
        0,
        320,
        340
      ],
      "paste_xy": [
        1053,
        202
      ]
    },
    {
      "index": 4,
      "source_slot": [
        434,
        543
      ],
      "source_box": [
        416,
        317,
        539,
        427
      ],
      "render_size": [
        125,
        112
      ],
      "frame_rect": [
        1280,
        0,
        320,
        340
      ],
      "paste_xy": [
        1377,
        208
      ]
    },
    {
      "index": 5,
      "source_slot": [
        543,
        652
      ],
      "source_box": [
        537,
        320,
        645,
        426
      ],
      "render_size": [
        110,
        108
      ],
      "frame_rect": [
        1600,
        0,
        320,
        340
      ],
      "paste_xy": [
        1705,
        212
      ]
    },
    {
      "index": 6,
      "source_slot": [
        652,
        760
      ],
      "source_box": [
        537,
        320,
        645,
        426
      ],
      "render_size": [
        110,
        108
      ],
      "frame_rect": [
        1920,
        0,
        320,
        340
      ],
      "paste_xy": [
        2025,
        212
      ]
    },
    {
      "index": 7,
      "source_slot": [
        760,
        869
      ],
      "source_box": [
        641,
        321,
        846,
        429
      ],
      "render_size": [
        208,
        110
      ],
      "frame_rect": [
        2240,
        0,
        320,
        340
      ],
      "paste_xy": [
        2296,
        210
      ]
    },
    {
      "index": 8,
      "source_slot": [
        869,
        977
      ],
      "source_box": [
        764,
        322,
        881,
        434
      ],
      "render_size": [
        119,
        114
      ],
      "frame_rect": [
        2560,
        0,
        320,
        340
      ],
      "paste_xy": [
        2660,
        206
      ]
    },
    {
      "index": 9,
      "source_slot": [
        977,
        1086
      ],
      "source_box": [
        817,
        308,
        1014,
        432
      ],
      "render_size": [
        200,
        126
      ],
      "frame_rect": [
        2880,
        0,
        320,
        340
      ],
      "paste_xy": [
        2940,
        194
      ]
    },
    {
      "index": 10,
      "source_slot": [
        1086,
        1195
      ],
      "source_box": [
        817,
        308,
        1014,
        432
      ],
      "render_size": [
        200,
        126
      ],
      "frame_rect": [
        3200,
        0,
        320,
        340
      ],
      "paste_xy": [
        3260,
        194
      ]
    },
    {
      "index": 11,
      "source_slot": [
        1195,
        1303
      ],
      "source_box": [
        1013,
        317,
        1156,
        434
      ],
      "render_size": [
        145,
        119
      ],
      "frame_rect": [
        3520,
        0,
        320,
        340
      ],
      "paste_xy": [
        3607,
        201
      ]
    },
    {
      "index": 12,
      "source_slot": [
        1303,
        1412
      ],
      "source_box": [
        1145,
        316,
        1290,
        438
      ],
      "render_size": [
        147,
        124
      ],
      "frame_rect": [
        3840,
        0,
        320,
        340
      ],
      "paste_xy": [
        3926,
        196
      ]
    },
    {
      "index": 13,
      "source_slot": [
        1412,
        1520
      ],
      "source_box": [
        1276,
        317,
        1416,
        434
      ],
      "render_size": [
        142,
        119
      ],
      "frame_rect": [
        4160,
        0,
        320,
        340
      ],
      "paste_xy": [
        4249,
        201
      ]
    },
    {
      "index": 14,
      "source_slot": [
        1520,
        1629
      ],
      "source_box": [
        1276,
        317,
        1416,
        434
      ],
      "render_size": [
        142,
        119
      ],
      "frame_rect": [
        4480,
        0,
        320,
        340
      ],
      "paste_xy": [
        4569,
        201
      ]
    },
    {
      "index": 15,
      "source_slot": [
        1629,
        1738
      ],
      "source_box": [
        1402,
        324,
        1549,
        430
      ],
      "render_size": [
        149,
        108
      ],
      "frame_rect": [
        4800,
        0,
        320,
        340
      ],
      "paste_xy": [
        4885,
        212
      ]
    },
    {
      "index": 16,
      "source_slot": [
        1738,
        1846
      ],
      "source_box": [
        1529,
        326,
        1805,
        430
      ],
      "render_size": [
        280,
        106
      ],
      "frame_rect": [
        5120,
        0,
        320,
        340
      ],
      "paste_xy": [
        5140,
        214
      ]
    },
    {
      "index": 17,
      "source_slot": [
        1846,
        1955
      ],
      "source_box": [
        1797,
        329,
        1961,
        430
      ],
      "render_size": [
        166,
        102
      ],
      "frame_rect": [
        5440,
        0,
        320,
        340
      ],
      "paste_xy": [
        5517,
        218
      ]
    },
    {
      "index": 18,
      "source_slot": [
        1955,
        2063
      ],
      "source_box": [
        1797,
        329,
        1961,
        430
      ],
      "render_size": [
        166,
        102
      ],
      "frame_rect": [
        5760,
        0,
        320,
        340
      ],
      "paste_xy": [
        5837,
        218
      ]
    },
    {
      "index": 19,
      "source_slot": [
        2063,
        2172
      ],
      "source_box": [
        1949,
        324,
        2147,
        428
      ],
      "render_size": [
        201,
        106
      ],
      "frame_rect": [
        6080,
        0,
        320,
        340
      ],
      "paste_xy": [
        6139,
        214
      ]
    }
  ]
}
```

### `groom`

```json
{
  "source": "/tmp/cat_action_sprites_20f_row/cat_action_sprites_20f_row/groom_20f_row.png",
  "target": "templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames/groom/groom-20f-sheet.png",
  "source_size": [
    2172,
    724
  ],
  "output_size": [
    6400,
    340
  ],
  "source_slot_count": 20,
  "frame_width": 320,
  "frame_height": 340,
  "scale": 1.6456,
  "detected_main_components": 18,
  "max_source_crop_size": [
    134,
    158
  ],
  "frames": [
    {
      "index": 0,
      "source_slot": [
        0,
        109
      ],
      "source_box": [
        12,
        278,
        141,
        436
      ],
      "render_size": [
        212,
        260
      ],
      "frame_rect": [
        0,
        0,
        320,
        340
      ],
      "paste_xy": [
        54,
        60
      ]
    },
    {
      "index": 1,
      "source_slot": [
        109,
        217
      ],
      "source_box": [
        132,
        305,
        265,
        436
      ],
      "render_size": [
        219,
        216
      ],
      "frame_rect": [
        320,
        0,
        320,
        340
      ],
      "paste_xy": [
        370,
        104
      ]
    },
    {
      "index": 2,
      "source_slot": [
        217,
        326
      ],
      "source_box": [
        248,
        306,
        376,
        436
      ],
      "render_size": [
        211,
        214
      ],
      "frame_rect": [
        640,
        0,
        320,
        340
      ],
      "paste_xy": [
        694,
        106
      ]
    },
    {
      "index": 3,
      "source_slot": [
        326,
        434
      ],
      "source_box": [
        363,
        305,
        492,
        436
      ],
      "render_size": [
        212,
        216
      ],
      "frame_rect": [
        960,
        0,
        320,
        340
      ],
      "paste_xy": [
        1014,
        104
      ]
    },
    {
      "index": 4,
      "source_slot": [
        434,
        543
      ],
      "source_box": [
        486,
        296,
        615,
        436
      ],
      "render_size": [
        212,
        230
      ],
      "frame_rect": [
        1280,
        0,
        320,
        340
      ],
      "paste_xy": [
        1334,
        90
      ]
    },
    {
      "index": 5,
      "source_slot": [
        543,
        652
      ],
      "source_box": [
        486,
        296,
        615,
        436
      ],
      "render_size": [
        212,
        230
      ],
      "frame_rect": [
        1600,
        0,
        320,
        340
      ],
      "paste_xy": [
        1654,
        90
      ]
    },
    {
      "index": 6,
      "source_slot": [
        652,
        760
      ],
      "source_box": [
        610,
        293,
        737,
        435
      ],
      "render_size": [
        209,
        234
      ],
      "frame_rect": [
        1920,
        0,
        320,
        340
      ],
      "paste_xy": [
        1975,
        86
      ]
    },
    {
      "index": 7,
      "source_slot": [
        760,
        869
      ],
      "source_box": [
        729,
        295,
        856,
        436
      ],
      "render_size": [
        209,
        232
      ],
      "frame_rect": [
        2240,
        0,
        320,
        340
      ],
      "paste_xy": [
        2295,
        88
      ]
    },
    {
      "index": 8,
      "source_slot": [
        869,
        977
      ],
      "source_box": [
        847,
        293,
        975,
        435
      ],
      "render_size": [
        211,
        234
      ],
      "frame_rect": [
        2560,
        0,
        320,
        340
      ],
      "paste_xy": [
        2614,
        86
      ]
    },
    {
      "index": 9,
      "source_slot": [
        977,
        1086
      ],
      "source_box": [
        969,
        293,
        1099,
        435
      ],
      "render_size": [
        214,
        234
      ],
      "frame_rect": [
        2880,
        0,
        320,
        340
      ],
      "paste_xy": [
        2933,
        86
      ]
    },
    {
      "index": 10,
      "source_slot": [
        1086,
        1195
      ],
      "source_box": [
        1095,
        295,
        1224,
        435
      ],
      "render_size": [
        212,
        230
      ],
      "frame_rect": [
        3200,
        0,
        320,
        340
      ],
      "paste_xy": [
        3254,
        90
      ]
    },
    {
      "index": 11,
      "source_slot": [
        1195,
        1303
      ],
      "source_box": [
        1216,
        300,
        1350,
        436
      ],
      "render_size": [
        221,
        224
      ],
      "frame_rect": [
        3520,
        0,
        320,
        340
      ],
      "paste_xy": [
        3569,
        96
      ]
    },
    {
      "index": 12,
      "source_slot": [
        1303,
        1412
      ],
      "source_box": [
        1336,
        296,
        1463,
        436
      ],
      "render_size": [
        209,
        230
      ],
      "frame_rect": [
        3840,
        0,
        320,
        340
      ],
      "paste_xy": [
        3895,
        90
      ]
    },
    {
      "index": 13,
      "source_slot": [
        1412,
        1520
      ],
      "source_box": [
        1455,
        299,
        1581,
        436
      ],
      "render_size": [
        207,
        225
      ],
      "frame_rect": [
        4160,
        0,
        320,
        340
      ],
      "paste_xy": [
        4216,
        95
      ]
    },
    {
      "index": 14,
      "source_slot": [
        1520,
        1629
      ],
      "source_box": [
        1568,
        293,
        1693,
        436
      ],
      "render_size": [
        206,
        235
      ],
      "frame_rect": [
        4480,
        0,
        320,
        340
      ],
      "paste_xy": [
        4537,
        85
      ]
    },
    {
      "index": 15,
      "source_slot": [
        1629,
        1738
      ],
      "source_box": [
        1568,
        293,
        1693,
        436
      ],
      "render_size": [
        206,
        235
      ],
      "frame_rect": [
        4800,
        0,
        320,
        340
      ],
      "paste_xy": [
        4857,
        85
      ]
    },
    {
      "index": 16,
      "source_slot": [
        1738,
        1846
      ],
      "source_box": [
        1678,
        290,
        1803,
        436
      ],
      "render_size": [
        206,
        240
      ],
      "frame_rect": [
        5120,
        0,
        320,
        340
      ],
      "paste_xy": [
        5177,
        80
      ]
    },
    {
      "index": 17,
      "source_slot": [
        1846,
        1955
      ],
      "source_box": [
        1787,
        289,
        1911,
        436
      ],
      "render_size": [
        204,
        242
      ],
      "frame_rect": [
        5440,
        0,
        320,
        340
      ],
      "paste_xy": [
        5498,
        78
      ]
    },
    {
      "index": 18,
      "source_slot": [
        1955,
        2063
      ],
      "source_box": [
        1895,
        288,
        2019,
        435
      ],
      "render_size": [
        204,
        242
      ],
      "frame_rect": [
        5760,
        0,
        320,
        340
      ],
      "paste_xy": [
        5818,
        78
      ]
    },
    {
      "index": 19,
      "source_slot": [
        2063,
        2172
      ],
      "source_box": [
        2000,
        287,
        2127,
        436
      ],
      "render_size": [
        209,
        245
      ],
      "frame_rect": [
        6080,
        0,
        320,
        340
      ],
      "paste_xy": [
        6135,
        75
      ]
    }
  ]
}
```

### `run`

```json
{
  "source": "/tmp/cat_action_sprites_20f_row/cat_action_sprites_20f_row/run_20f_row.png",
  "target": "templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames/run/run-20f-sheet.png",
  "source_size": [
    2172,
    724
  ],
  "output_size": [
    6400,
    340
  ],
  "source_slot_count": 20,
  "frame_width": 320,
  "frame_height": 340,
  "scale": 1.958,
  "detected_main_components": 17,
  "max_source_crop_size": [
    143,
    79
  ],
  "frames": [
    {
      "index": 0,
      "source_slot": [
        0,
        109
      ],
      "source_box": [
        15,
        326,
        147,
        400
      ],
      "render_size": [
        258,
        145
      ],
      "frame_rect": [
        0,
        0,
        320,
        340
      ],
      "paste_xy": [
        31,
        175
      ]
    },
    {
      "index": 1,
      "source_slot": [
        109,
        217
      ],
      "source_box": [
        143,
        332,
        274,
        408
      ],
      "render_size": [
        257,
        149
      ],
      "frame_rect": [
        320,
        0,
        320,
        340
      ],
      "paste_xy": [
        351,
        171
      ]
    },
    {
      "index": 2,
      "source_slot": [
        217,
        326
      ],
      "source_box": [
        265,
        332,
        407,
        407
      ],
      "render_size": [
        278,
        147
      ],
      "frame_rect": [
        640,
        0,
        320,
        340
      ],
      "paste_xy": [
        661,
        173
      ]
    },
    {
      "index": 3,
      "source_slot": [
        326,
        434
      ],
      "source_box": [
        404,
        337,
        547,
        410
      ],
      "render_size": [
        280,
        143
      ],
      "frame_rect": [
        960,
        0,
        320,
        340
      ],
      "paste_xy": [
        980,
        177
      ]
    },
    {
      "index": 4,
      "source_slot": [
        434,
        543
      ],
      "source_box": [
        404,
        337,
        547,
        410
      ],
      "render_size": [
        280,
        143
      ],
      "frame_rect": [
        1280,
        0,
        320,
        340
      ],
      "paste_xy": [
        1300,
        177
      ]
    },
    {
      "index": 5,
      "source_slot": [
        543,
        652
      ],
      "source_box": [
        548,
        337,
        686,
        412
      ],
      "render_size": [
        270,
        147
      ],
      "frame_rect": [
        1600,
        0,
        320,
        340
      ],
      "paste_xy": [
        1625,
        173
      ]
    },
    {
      "index": 6,
      "source_slot": [
        652,
        760
      ],
      "source_box": [
        682,
        335,
        817,
        414
      ],
      "render_size": [
        264,
        155
      ],
      "frame_rect": [
        1920,
        0,
        320,
        340
      ],
      "paste_xy": [
        1948,
        165
      ]
    },
    {
      "index": 7,
      "source_slot": [
        760,
        869
      ],
      "source_box": [
        811,
        335,
        952,
        411
      ],
      "render_size": [
        276,
        149
      ],
      "frame_rect": [
        2240,
        0,
        320,
        340
      ],
      "paste_xy": [
        2262,
        171
      ]
    },
    {
      "index": 8,
      "source_slot": [
        869,
        977
      ],
      "source_box": [
        952,
        339,
        1089,
        409
      ],
      "render_size": [
        268,
        137
      ],
      "frame_rect": [
        2560,
        0,
        320,
        340
      ],
      "paste_xy": [
        2586,
        183
      ]
    },
    {
      "index": 9,
      "source_slot": [
        977,
        1086
      ],
      "source_box": [
        1079,
        335,
        1213,
        407
      ],
      "render_size": [
        262,
        141
      ],
      "frame_rect": [
        2880,
        0,
        320,
        340
      ],
      "paste_xy": [
        2909,
        179
      ]
    },
    {
      "index": 10,
      "source_slot": [
        1086,
        1195
      ],
      "source_box": [
        1079,
        335,
        1213,
        407
      ],
      "render_size": [
        262,
        141
      ],
      "frame_rect": [
        3200,
        0,
        320,
        340
      ],
      "paste_xy": [
        3229,
        179
      ]
    },
    {
      "index": 11,
      "source_slot": [
        1195,
        1303
      ],
      "source_box": [
        1206,
        332,
        1338,
        407
      ],
      "render_size": [
        258,
        147
      ],
      "frame_rect": [
        3520,
        0,
        320,
        340
      ],
      "paste_xy": [
        3551,
        173
      ]
    },
    {
      "index": 12,
      "source_slot": [
        1303,
        1412
      ],
      "source_box": [
        1328,
        343,
        1458,
        411
      ],
      "render_size": [
        255,
        133
      ],
      "frame_rect": [
        3840,
        0,
        320,
        340
      ],
      "paste_xy": [
        3872,
        187
      ]
    },
    {
      "index": 13,
      "source_slot": [
        1412,
        1520
      ],
      "source_box": [
        1452,
        338,
        1582,
        409
      ],
      "render_size": [
        255,
        139
      ],
      "frame_rect": [
        4160,
        0,
        320,
        340
      ],
      "paste_xy": [
        4192,
        181
      ]
    },
    {
      "index": 14,
      "source_slot": [
        1520,
        1629
      ],
      "source_box": [
        1572,
        335,
        1700,
        409
      ],
      "render_size": [
        251,
        145
      ],
      "frame_rect": [
        4480,
        0,
        320,
        340
      ],
      "paste_xy": [
        4514,
        175
      ]
    },
    {
      "index": 15,
      "source_slot": [
        1629,
        1738
      ],
      "source_box": [
        1687,
        335,
        1822,
        409
      ],
      "render_size": [
        264,
        145
      ],
      "frame_rect": [
        4800,
        0,
        320,
        340
      ],
      "paste_xy": [
        4828,
        175
      ]
    },
    {
      "index": 16,
      "source_slot": [
        1738,
        1846
      ],
      "source_box": [
        1687,
        335,
        1822,
        409
      ],
      "render_size": [
        264,
        145
      ],
      "frame_rect": [
        5120,
        0,
        320,
        340
      ],
      "paste_xy": [
        5148,
        175
      ]
    },
    {
      "index": 17,
      "source_slot": [
        1846,
        1955
      ],
      "source_box": [
        1808,
        343,
        1933,
        410
      ],
      "render_size": [
        245,
        131
      ],
      "frame_rect": [
        5440,
        0,
        320,
        340
      ],
      "paste_xy": [
        5477,
        189
      ]
    },
    {
      "index": 18,
      "source_slot": [
        1955,
        2063
      ],
      "source_box": [
        1923,
        339,
        2048,
        411
      ],
      "render_size": [
        245,
        141
      ],
      "frame_rect": [
        5760,
        0,
        320,
        340
      ],
      "paste_xy": [
        5797,
        179
      ]
    },
    {
      "index": 19,
      "source_slot": [
        2063,
        2172
      ],
      "source_box": [
        2039,
        348,
        2158,
        411
      ],
      "render_size": [
        233,
        123
      ],
      "frame_rect": [
        6080,
        0,
        320,
        340
      ],
      "paste_xy": [
        6123,
        197
      ]
    }
  ]
}
```

### `walk`

```json
{
  "source": "/tmp/cat_action_sprites_20f_row/cat_action_sprites_20f_row/walk_20f_row.png",
  "target": "templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames/walk/walk-20f-sheet.png",
  "source_size": [
    2172,
    724
  ],
  "output_size": [
    6400,
    340
  ],
  "source_slot_count": 20,
  "frame_width": 320,
  "frame_height": 340,
  "scale": 1.958,
  "detected_main_components": 18,
  "max_source_crop_size": [
    143,
    91
  ],
  "frames": [
    {
      "index": 0,
      "source_slot": [
        0,
        109
      ],
      "source_box": [
        4,
        316,
        147,
        407
      ],
      "render_size": [
        280,
        178
      ],
      "frame_rect": [
        0,
        0,
        320,
        340
      ],
      "paste_xy": [
        20,
        142
      ]
    },
    {
      "index": 1,
      "source_slot": [
        109,
        217
      ],
      "source_box": [
        136,
        316,
        272,
        407
      ],
      "render_size": [
        266,
        178
      ],
      "frame_rect": [
        320,
        0,
        320,
        340
      ],
      "paste_xy": [
        347,
        142
      ]
    },
    {
      "index": 2,
      "source_slot": [
        217,
        326
      ],
      "source_box": [
        262,
        316,
        396,
        407
      ],
      "render_size": [
        262,
        178
      ],
      "frame_rect": [
        640,
        0,
        320,
        340
      ],
      "paste_xy": [
        669,
        142
      ]
    },
    {
      "index": 3,
      "source_slot": [
        326,
        434
      ],
      "source_box": [
        382,
        318,
        515,
        406
      ],
      "render_size": [
        260,
        172
      ],
      "frame_rect": [
        960,
        0,
        320,
        340
      ],
      "paste_xy": [
        990,
        148
      ]
    },
    {
      "index": 4,
      "source_slot": [
        434,
        543
      ],
      "source_box": [
        502,
        318,
        635,
        407
      ],
      "render_size": [
        260,
        174
      ],
      "frame_rect": [
        1280,
        0,
        320,
        340
      ],
      "paste_xy": [
        1310,
        146
      ]
    },
    {
      "index": 5,
      "source_slot": [
        543,
        652
      ],
      "source_box": [
        502,
        318,
        635,
        407
      ],
      "render_size": [
        260,
        174
      ],
      "frame_rect": [
        1600,
        0,
        320,
        340
      ],
      "paste_xy": [
        1630,
        146
      ]
    },
    {
      "index": 6,
      "source_slot": [
        652,
        760
      ],
      "source_box": [
        624,
        319,
        753,
        407
      ],
      "render_size": [
        253,
        172
      ],
      "frame_rect": [
        1920,
        0,
        320,
        340
      ],
      "paste_xy": [
        1953,
        148
      ]
    },
    {
      "index": 7,
      "source_slot": [
        760,
        869
      ],
      "source_box": [
        739,
        320,
        868,
        407
      ],
      "render_size": [
        253,
        170
      ],
      "frame_rect": [
        2240,
        0,
        320,
        340
      ],
      "paste_xy": [
        2273,
        150
      ]
    },
    {
      "index": 8,
      "source_slot": [
        869,
        977
      ],
      "source_box": [
        857,
        316,
        983,
        407
      ],
      "render_size": [
        247,
        178
      ],
      "frame_rect": [
        2560,
        0,
        320,
        340
      ],
      "paste_xy": [
        2596,
        142
      ]
    },
    {
      "index": 9,
      "source_slot": [
        977,
        1086
      ],
      "source_box": [
        972,
        318,
        1093,
        408
      ],
      "render_size": [
        237,
        176
      ],
      "frame_rect": [
        2880,
        0,
        320,
        340
      ],
      "paste_xy": [
        2921,
        144
      ]
    },
    {
      "index": 10,
      "source_slot": [
        1086,
        1195
      ],
      "source_box": [
        1083,
        319,
        1202,
        407
      ],
      "render_size": [
        233,
        172
      ],
      "frame_rect": [
        3200,
        0,
        320,
        340
      ],
      "paste_xy": [
        3243,
        148
      ]
    },
    {
      "index": 11,
      "source_slot": [
        1195,
        1303
      ],
      "source_box": [
        1193,
        319,
        1316,
        408
      ],
      "render_size": [
        241,
        174
      ],
      "frame_rect": [
        3520,
        0,
        320,
        340
      ],
      "paste_xy": [
        3559,
        146
      ]
    },
    {
      "index": 12,
      "source_slot": [
        1303,
        1412
      ],
      "source_box": [
        1308,
        319,
        1431,
        407
      ],
      "render_size": [
        241,
        172
      ],
      "frame_rect": [
        3840,
        0,
        320,
        340
      ],
      "paste_xy": [
        3879,
        148
      ]
    },
    {
      "index": 13,
      "source_slot": [
        1412,
        1520
      ],
      "source_box": [
        1423,
        319,
        1546,
        408
      ],
      "render_size": [
        241,
        174
      ],
      "frame_rect": [
        4160,
        0,
        320,
        340
      ],
      "paste_xy": [
        4199,
        146
      ]
    },
    {
      "index": 14,
      "source_slot": [
        1520,
        1629
      ],
      "source_box": [
        1539,
        321,
        1665,
        407
      ],
      "render_size": [
        247,
        168
      ],
      "frame_rect": [
        4480,
        0,
        320,
        340
      ],
      "paste_xy": [
        4516,
        152
      ]
    },
    {
      "index": 15,
      "source_slot": [
        1629,
        1738
      ],
      "source_box": [
        1539,
        321,
        1665,
        407
      ],
      "render_size": [
        247,
        168
      ],
      "frame_rect": [
        4800,
        0,
        320,
        340
      ],
      "paste_xy": [
        4836,
        152
      ]
    },
    {
      "index": 16,
      "source_slot": [
        1738,
        1846
      ],
      "source_box": [
        1653,
        321,
        1781,
        407
      ],
      "render_size": [
        251,
        168
      ],
      "frame_rect": [
        5120,
        0,
        320,
        340
      ],
      "paste_xy": [
        5154,
        152
      ]
    },
    {
      "index": 17,
      "source_slot": [
        1846,
        1955
      ],
      "source_box": [
        1768,
        317,
        1903,
        408
      ],
      "render_size": [
        264,
        178
      ],
      "frame_rect": [
        5440,
        0,
        320,
        340
      ],
      "paste_xy": [
        5468,
        142
      ]
    },
    {
      "index": 18,
      "source_slot": [
        1955,
        2063
      ],
      "source_box": [
        1888,
        316,
        2021,
        407
      ],
      "render_size": [
        260,
        178
      ],
      "frame_rect": [
        5760,
        0,
        320,
        340
      ],
      "paste_xy": [
        5790,
        142
      ]
    },
    {
      "index": 19,
      "source_slot": [
        2063,
        2172
      ],
      "source_box": [
        2008,
        316,
        2145,
        407
      ],
      "render_size": [
        268,
        178
      ],
      "frame_rect": [
        6080,
        0,
        320,
        340
      ],
      "paste_xy": [
        6106,
        142
      ]
    }
  ]
}
```

### `yawn`

```json
{
  "source": "/tmp/cat_action_sprites_20f_row/cat_action_sprites_20f_row/yawn_20f_row.png",
  "target": "templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames/yawn/yawn-20f-sheet.png",
  "source_size": [
    2172,
    724
  ],
  "output_size": [
    6400,
    340
  ],
  "source_slot_count": 20,
  "frame_width": 320,
  "frame_height": 340,
  "scale": 0.8163,
  "detected_main_components": 17,
  "max_source_crop_size": [
    343,
    198
  ],
  "frames": [
    {
      "index": 0,
      "source_slot": [
        0,
        109
      ],
      "source_box": [
        11,
        279,
        354,
        461
      ],
      "render_size": [
        280,
        149
      ],
      "frame_rect": [
        0,
        0,
        320,
        340
      ],
      "paste_xy": [
        20,
        171
      ]
    },
    {
      "index": 1,
      "source_slot": [
        109,
        217
      ],
      "source_box": [
        335,
        279,
        463,
        461
      ],
      "render_size": [
        104,
        149
      ],
      "frame_rect": [
        320,
        0,
        320,
        340
      ],
      "paste_xy": [
        428,
        171
      ]
    },
    {
      "index": 2,
      "source_slot": [
        217,
        326
      ],
      "source_box": [
        444,
        278,
        572,
        461
      ],
      "render_size": [
        104,
        149
      ],
      "frame_rect": [
        640,
        0,
        320,
        340
      ],
      "paste_xy": [
        748,
        171
      ]
    },
    {
      "index": 3,
      "source_slot": [
        326,
        434
      ],
      "source_box": [
        560,
        274,
        687,
        461
      ],
      "render_size": [
        104,
        153
      ],
      "frame_rect": [
        960,
        0,
        320,
        340
      ],
      "paste_xy": [
        1068,
        167
      ]
    },
    {
      "index": 4,
      "source_slot": [
        434,
        543
      ],
      "source_box": [
        560,
        274,
        687,
        461
      ],
      "render_size": [
        104,
        153
      ],
      "frame_rect": [
        1280,
        0,
        320,
        340
      ],
      "paste_xy": [
        1388,
        167
      ]
    },
    {
      "index": 5,
      "source_slot": [
        543,
        652
      ],
      "source_box": [
        676,
        271,
        802,
        461
      ],
      "render_size": [
        103,
        155
      ],
      "frame_rect": [
        1600,
        0,
        320,
        340
      ],
      "paste_xy": [
        1708,
        165
      ]
    },
    {
      "index": 6,
      "source_slot": [
        652,
        760
      ],
      "source_box": [
        792,
        268,
        917,
        461
      ],
      "render_size": [
        102,
        158
      ],
      "frame_rect": [
        1920,
        0,
        320,
        340
      ],
      "paste_xy": [
        2029,
        162
      ]
    },
    {
      "index": 7,
      "source_slot": [
        760,
        869
      ],
      "source_box": [
        907,
        265,
        1033,
        462
      ],
      "render_size": [
        103,
        161
      ],
      "frame_rect": [
        2240,
        0,
        320,
        340
      ],
      "paste_xy": [
        2348,
        159
      ]
    },
    {
      "index": 8,
      "source_slot": [
        869,
        977
      ],
      "source_box": [
        1025,
        264,
        1152,
        461
      ],
      "render_size": [
        104,
        161
      ],
      "frame_rect": [
        2560,
        0,
        320,
        340
      ],
      "paste_xy": [
        2668,
        159
      ]
    },
    {
      "index": 9,
      "source_slot": [
        977,
        1086
      ],
      "source_box": [
        1144,
        263,
        1270,
        461
      ],
      "render_size": [
        103,
        162
      ],
      "frame_rect": [
        2880,
        0,
        320,
        340
      ],
      "paste_xy": [
        2988,
        158
      ]
    },
    {
      "index": 10,
      "source_slot": [
        1086,
        1195
      ],
      "source_box": [
        1144,
        263,
        1270,
        461
      ],
      "render_size": [
        103,
        162
      ],
      "frame_rect": [
        3200,
        0,
        320,
        340
      ],
      "paste_xy": [
        3308,
        158
      ]
    },
    {
      "index": 11,
      "source_slot": [
        1195,
        1303
      ],
      "source_box": [
        1262,
        265,
        1389,
        461
      ],
      "render_size": [
        104,
        160
      ],
      "frame_rect": [
        3520,
        0,
        320,
        340
      ],
      "paste_xy": [
        3628,
        160
      ]
    },
    {
      "index": 12,
      "source_slot": [
        1303,
        1412
      ],
      "source_box": [
        1379,
        269,
        1504,
        461
      ],
      "render_size": [
        102,
        157
      ],
      "frame_rect": [
        3840,
        0,
        320,
        340
      ],
      "paste_xy": [
        3949,
        163
      ]
    },
    {
      "index": 13,
      "source_slot": [
        1412,
        1520
      ],
      "source_box": [
        1496,
        275,
        1620,
        461
      ],
      "render_size": [
        101,
        152
      ],
      "frame_rect": [
        4160,
        0,
        320,
        340
      ],
      "paste_xy": [
        4269,
        168
      ]
    },
    {
      "index": 14,
      "source_slot": [
        1520,
        1629
      ],
      "source_box": [
        1610,
        279,
        1736,
        461
      ],
      "render_size": [
        103,
        149
      ],
      "frame_rect": [
        4480,
        0,
        320,
        340
      ],
      "paste_xy": [
        4588,
        171
      ]
    },
    {
      "index": 15,
      "source_slot": [
        1629,
        1738
      ],
      "source_box": [
        1721,
        281,
        1846,
        461
      ],
      "render_size": [
        102,
        147
      ],
      "frame_rect": [
        4800,
        0,
        320,
        340
      ],
      "paste_xy": [
        4909,
        173
      ]
    },
    {
      "index": 16,
      "source_slot": [
        1738,
        1846
      ],
      "source_box": [
        1721,
        281,
        1846,
        461
      ],
      "render_size": [
        102,
        147
      ],
      "frame_rect": [
        5120,
        0,
        320,
        340
      ],
      "paste_xy": [
        5229,
        173
      ]
    },
    {
      "index": 17,
      "source_slot": [
        1846,
        1955
      ],
      "source_box": [
        1829,
        282,
        1954,
        461
      ],
      "render_size": [
        102,
        146
      ],
      "frame_rect": [
        5440,
        0,
        320,
        340
      ],
      "paste_xy": [
        5549,
        174
      ]
    },
    {
      "index": 18,
      "source_slot": [
        1955,
        2063
      ],
      "source_box": [
        1936,
        283,
        2060,
        461
      ],
      "render_size": [
        101,
        145
      ],
      "frame_rect": [
        5760,
        0,
        320,
        340
      ],
      "paste_xy": [
        5869,
        175
      ]
    },
    {
      "index": 19,
      "source_slot": [
        2063,
        2172
      ],
      "source_box": [
        2042,
        282,
        2168,
        461
      ],
      "render_size": [
        103,
        146
      ],
      "frame_rect": [
        6080,
        0,
        320,
        340
      ],
      "paste_xy": [
        6188,
        174
      ]
    }
  ]
}
```

### `meow`

```json
{
  "source": "/tmp/cat_action_sprites_20f_row/cat_action_sprites_20f_row/meow_20f_row.png",
  "target": "templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames/meow/meow-20f-sheet.png",
  "source_size": [
    2172,
    724
  ],
  "output_size": [
    6400,
    340
  ],
  "source_slot_count": 20,
  "frame_width": 320,
  "frame_height": 340,
  "scale": 1.4943,
  "detected_main_components": 18,
  "max_source_crop_size": [
    131,
    174
  ],
  "frames": [
    {
      "index": 0,
      "source_slot": [
        0,
        109
      ],
      "source_box": [
        21,
        283,
        148,
        452
      ],
      "render_size": [
        190,
        253
      ],
      "frame_rect": [
        0,
        0,
        320,
        340
      ],
      "paste_xy": [
        65,
        67
      ]
    },
    {
      "index": 1,
      "source_slot": [
        109,
        217
      ],
      "source_box": [
        134,
        283,
        263,
        453
      ],
      "render_size": [
        193,
        254
      ],
      "frame_rect": [
        320,
        0,
        320,
        340
      ],
      "paste_xy": [
        383,
        66
      ]
    },
    {
      "index": 2,
      "source_slot": [
        217,
        326
      ],
      "source_box": [
        246,
        282,
        375,
        452
      ],
      "render_size": [
        193,
        254
      ],
      "frame_rect": [
        640,
        0,
        320,
        340
      ],
      "paste_xy": [
        703,
        66
      ]
    },
    {
      "index": 3,
      "source_slot": [
        326,
        434
      ],
      "source_box": [
        361,
        282,
        491,
        453
      ],
      "render_size": [
        194,
        256
      ],
      "frame_rect": [
        960,
        0,
        320,
        340
      ],
      "paste_xy": [
        1023,
        64
      ]
    },
    {
      "index": 4,
      "source_slot": [
        434,
        543
      ],
      "source_box": [
        476,
        282,
        606,
        452
      ],
      "render_size": [
        194,
        254
      ],
      "frame_rect": [
        1280,
        0,
        320,
        340
      ],
      "paste_xy": [
        1343,
        66
      ]
    },
    {
      "index": 5,
      "source_slot": [
        543,
        652
      ],
      "source_box": [
        476,
        282,
        606,
        452
      ],
      "render_size": [
        194,
        254
      ],
      "frame_rect": [
        1600,
        0,
        320,
        340
      ],
      "paste_xy": [
        1663,
        66
      ]
    },
    {
      "index": 6,
      "source_slot": [
        652,
        760
      ],
      "source_box": [
        593,
        282,
        723,
        452
      ],
      "render_size": [
        194,
        254
      ],
      "frame_rect": [
        1920,
        0,
        320,
        340
      ],
      "paste_xy": [
        1983,
        66
      ]
    },
    {
      "index": 7,
      "source_slot": [
        760,
        869
      ],
      "source_box": [
        709,
        281,
        836,
        453
      ],
      "render_size": [
        190,
        257
      ],
      "frame_rect": [
        2240,
        0,
        320,
        340
      ],
      "paste_xy": [
        2305,
        63
      ]
    },
    {
      "index": 8,
      "source_slot": [
        869,
        977
      ],
      "source_box": [
        824,
        280,
        952,
        453
      ],
      "render_size": [
        191,
        259
      ],
      "frame_rect": [
        2560,
        0,
        320,
        340
      ],
      "paste_xy": [
        2624,
        61
      ]
    },
    {
      "index": 9,
      "source_slot": [
        977,
        1086
      ],
      "source_box": [
        940,
        279,
        1069,
        453
      ],
      "render_size": [
        193,
        260
      ],
      "frame_rect": [
        2880,
        0,
        320,
        340
      ],
      "paste_xy": [
        2943,
        60
      ]
    },
    {
      "index": 10,
      "source_slot": [
        1086,
        1195
      ],
      "source_box": [
        1057,
        280,
        1186,
        452
      ],
      "render_size": [
        193,
        257
      ],
      "frame_rect": [
        3200,
        0,
        320,
        340
      ],
      "paste_xy": [
        3263,
        63
      ]
    },
    {
      "index": 11,
      "source_slot": [
        1195,
        1303
      ],
      "source_box": [
        1171,
        280,
        1300,
        452
      ],
      "render_size": [
        193,
        257
      ],
      "frame_rect": [
        3520,
        0,
        320,
        340
      ],
      "paste_xy": [
        3583,
        63
      ]
    },
    {
      "index": 12,
      "source_slot": [
        1303,
        1412
      ],
      "source_box": [
        1285,
        280,
        1412,
        452
      ],
      "render_size": [
        190,
        257
      ],
      "frame_rect": [
        3840,
        0,
        320,
        340
      ],
      "paste_xy": [
        3905,
        63
      ]
    },
    {
      "index": 13,
      "source_slot": [
        1412,
        1520
      ],
      "source_box": [
        1396,
        280,
        1527,
        453
      ],
      "render_size": [
        196,
        259
      ],
      "frame_rect": [
        4160,
        0,
        320,
        340
      ],
      "paste_xy": [
        4222,
        61
      ]
    },
    {
      "index": 14,
      "source_slot": [
        1520,
        1629
      ],
      "source_box": [
        1512,
        282,
        1639,
        453
      ],
      "render_size": [
        190,
        256
      ],
      "frame_rect": [
        4480,
        0,
        320,
        340
      ],
      "paste_xy": [
        4545,
        64
      ]
    },
    {
      "index": 15,
      "source_slot": [
        1629,
        1738
      ],
      "source_box": [
        1512,
        282,
        1639,
        453
      ],
      "render_size": [
        190,
        256
      ],
      "frame_rect": [
        4800,
        0,
        320,
        340
      ],
      "paste_xy": [
        4865,
        64
      ]
    },
    {
      "index": 16,
      "source_slot": [
        1738,
        1846
      ],
      "source_box": [
        1628,
        282,
        1756,
        453
      ],
      "render_size": [
        191,
        256
      ],
      "frame_rect": [
        5120,
        0,
        320,
        340
      ],
      "paste_xy": [
        5184,
        64
      ]
    },
    {
      "index": 17,
      "source_slot": [
        1846,
        1955
      ],
      "source_box": [
        1743,
        283,
        1872,
        452
      ],
      "render_size": [
        193,
        253
      ],
      "frame_rect": [
        5440,
        0,
        320,
        340
      ],
      "paste_xy": [
        5503,
        67
      ]
    },
    {
      "index": 18,
      "source_slot": [
        1955,
        2063
      ],
      "source_box": [
        1861,
        283,
        1991,
        453
      ],
      "render_size": [
        194,
        254
      ],
      "frame_rect": [
        5760,
        0,
        320,
        340
      ],
      "paste_xy": [
        5823,
        66
      ]
    },
    {
      "index": 19,
      "source_slot": [
        2063,
        2172
      ],
      "source_box": [
        1982,
        282,
        2112,
        452
      ],
      "render_size": [
        194,
        254
      ],
      "frame_rect": [
        6080,
        0,
        320,
        340
      ],
      "paste_xy": [
        6143,
        66
      ]
    }
  ]
}
```
## Precision follow-up

The `yawn` sheet was regenerated with action-specific component isolation. The generic importer had allowed the first runtime frame to contain multiple adjacent source cats. The fixed sheet selects exactly one detected yawn component per frame, rescales it into a centered `320x340` slot, and keeps the runtime sheet at `6400x340`.

```json
{
  "source": "/tmp/cat_action_sprites_20f_row/cat_action_sprites_20f_row/yawn_20f_row.png",
  "target": "templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/frames/yawn/yawn-20f-sheet.png",
  "detected_components": 19,
  "source_indexes": [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18
  ],
  "output_size": [
    6400,
    340
  ],
  "max_source_crop_size": [
    115,
    184
  ],
  "scale": 1.413,
  "frames": [
    {
      "index": 0,
      "source_component_index": 0,
      "source_box": [
        18,
        286,
        133,
        454
      ],
      "render_size": [
        162,
        237
      ],
      "paste_xy": [
        79,
        83
      ]
    },
    {
      "index": 1,
      "source_component_index": 1,
      "source_box": [
        125,
        286,
        239,
        454
      ],
      "render_size": [
        161,
        237
      ],
      "paste_xy": [
        399,
        83
      ]
    },
    {
      "index": 2,
      "source_component_index": 2,
      "source_box": [
        232,
        286,
        347,
        454
      ],
      "render_size": [
        162,
        237
      ],
      "paste_xy": [
        719,
        83
      ]
    },
    {
      "index": 3,
      "source_component_index": 3,
      "source_box": [
        342,
        286,
        456,
        454
      ],
      "render_size": [
        161,
        237
      ],
      "paste_xy": [
        1039,
        83
      ]
    },
    {
      "index": 4,
      "source_component_index": 4,
      "source_box": [
        451,
        285,
        565,
        454
      ],
      "render_size": [
        161,
        239
      ],
      "paste_xy": [
        1359,
        81
      ]
    },
    {
      "index": 5,
      "source_component_index": 5,
      "source_box": [
        567,
        281,
        680,
        454
      ],
      "render_size": [
        160,
        244
      ],
      "paste_xy": [
        1680,
        76
      ]
    },
    {
      "index": 6,
      "source_component_index": 6,
      "source_box": [
        683,
        278,
        795,
        454
      ],
      "render_size": [
        158,
        249
      ],
      "paste_xy": [
        2001,
        71
      ]
    },
    {
      "index": 7,
      "source_component_index": 7,
      "source_box": [
        799,
        275,
        910,
        454
      ],
      "render_size": [
        157,
        253
      ],
      "paste_xy": [
        2321,
        67
      ]
    },
    {
      "index": 8,
      "source_component_index": 8,
      "source_box": [
        914,
        272,
        1026,
        455
      ],
      "render_size": [
        158,
        259
      ],
      "paste_xy": [
        2641,
        61
      ]
    },
    {
      "index": 9,
      "source_component_index": 9,
      "source_box": [
        1032,
        271,
        1145,
        454
      ],
      "render_size": [
        160,
        259
      ],
      "paste_xy": [
        2960,
        61
      ]
    },
    {
      "index": 10,
      "source_component_index": 9,
      "source_box": [
        1032,
        271,
        1145,
        454
      ],
      "render_size": [
        160,
        259
      ],
      "paste_xy": [
        3280,
        61
      ]
    },
    {
      "index": 11,
      "source_component_index": 10,
      "source_box": [
        1151,
        270,
        1263,
        454
      ],
      "render_size": [
        158,
        260
      ],
      "paste_xy": [
        3601,
        60
      ]
    },
    {
      "index": 12,
      "source_component_index": 11,
      "source_box": [
        1269,
        272,
        1382,
        454
      ],
      "render_size": [
        160,
        257
      ],
      "paste_xy": [
        3920,
        63
      ]
    },
    {
      "index": 13,
      "source_component_index": 12,
      "source_box": [
        1386,
        276,
        1497,
        454
      ],
      "render_size": [
        157,
        252
      ],
      "paste_xy": [
        4241,
        68
      ]
    },
    {
      "index": 14,
      "source_component_index": 13,
      "source_box": [
        1503,
        282,
        1613,
        454
      ],
      "render_size": [
        155,
        243
      ],
      "paste_xy": [
        4562,
        77
      ]
    },
    {
      "index": 15,
      "source_component_index": 14,
      "source_box": [
        1617,
        286,
        1729,
        454
      ],
      "render_size": [
        158,
        237
      ],
      "paste_xy": [
        4881,
        83
      ]
    },
    {
      "index": 16,
      "source_component_index": 15,
      "source_box": [
        1728,
        288,
        1839,
        454
      ],
      "render_size": [
        157,
        235
      ],
      "paste_xy": [
        5201,
        85
      ]
    },
    {
      "index": 17,
      "source_component_index": 16,
      "source_box": [
        1836,
        289,
        1947,
        454
      ],
      "render_size": [
        157,
        233
      ],
      "paste_xy": [
        5521,
        87
      ]
    },
    {
      "index": 18,
      "source_component_index": 17,
      "source_box": [
        1943,
        290,
        2053,
        454
      ],
      "render_size": [
        155,
        232
      ],
      "paste_xy": [
        5842,
        88
      ]
    },
    {
      "index": 19,
      "source_component_index": 18,
      "source_box": [
        2049,
        289,
        2161,
        454
      ],
      "render_size": [
        158,
        233
      ],
      "paste_xy": [
        6161,
        87
      ]
    }
  ]
}
```
