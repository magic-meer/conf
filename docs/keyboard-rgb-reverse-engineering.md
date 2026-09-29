# No-name tri-mode RGB keyboard — reverse engineering

Status: **SOLVED** — frame format, mode register and the complete
87-key slot map are all verified. This file is the source of truth for
the protocol; `keyboard-layout.json` next to it holds the machine-readable
map. Update both after every successful probe run.

> **Now lives in `~/projects/keyboard_rgb/`** — the CLI tool (`tool/`),
> the web editor (`app/`), every probe and its raw output (`probes/`),
> the research log (`RESEARCH.md`) and this document
> (`docs/protocol.md`). This copy is kept in sync for the nixconfig
> record.

---

## 1. The device

| | |
|---|---|
| USB VID:PID | `258a:0049` |
| USB name | `SINO WEALTH Bluetooth Keyboard` |
| HID id (vendor interface) | `0003:258A:0049` |
| MCU | Sinowealth (same family as Epom/Redragon boards OpenRGB calls "Sinowealth") |
| Bluetooth id | `000E:3412` — "BT5.0 KB", paired `EB:23:8F:35:94:00`, usually asleep |
| 2.4G dongle | `25a7:fa70` (Areson/Compx) |
| Interface 0 | boot keyboard (standard HID) |
| **Interface 1** | **vendor channel** — no interrupt-OUT, all traffic is EP0 feature reports |

- `/dev/hidraw*` is `0600 root:root`, so everything below needs `sudo`
  — **unless** `system/jinnnn/keyboard-rgb.nix` has been activated:
  `sudo nixos-rebuild switch --flake ~/nixconfig#jinnnn` (udev rule,
  `GROUP="users" MODE="0660" TAG+="uaccess"` for `258a:0049` and
  `25a7:fa70`).
- hidraw numbering changes on replug/re-enumerate. Always resolve with
  `hidtool.py resolve 0003:258A:0049` rather than hard-coding a number.

### Feature reports on interface 1

| report | size (payload) | R/W | purpose |
|---|---|---|---|
| `0x05` | 5 B | **write only** | command register — **DO NOT WRITE** (OpenRGB reports firmware-flash risk) |
| `0x09` | 504 B | read | 126 × u32 slot→keycode map (alignment anomaly at offset 2) |
| `0x0A` | 41 B | read/write | **settings / mode register** |
| `0x0B` | 378 B | **write** | **per-key RGB frame buffer** ← this is the one |
| `0x0C` | 1920 B | write | unknown, larger; writes accepted, no observed effect in mode `0x13` |

The HID descriptor declares exact lengths. Sending a different length →
`EPIPE` (stall) on write, or `ETIMEDOUT` on read. `0x05`, `0x0B`, `0x0C`
cannot be `GET` at all — stall/timeout — so the frame buffer is write-only.

Report id `0x08` (used by Sinodragon / redragon-ks82b-rgb) is **not declared**
by this board and stalls.

### Relevant kernel ioctl ABI

From `linux/hidraw.h`:

```
HIDIOCSFEATURE(len) = _IOC(READ|WRITE, 'H', 0x06, len)   // set, len includes report id
HIDIOCGFEATURE(len) = _IOC(READ,        'H', 0x07, len)
HIDIOCSINPUT(0x09) / HIDIOCGINPUT(0x0A)
HIDIOCSOUTPUT(0x0B) / HIDIOCGOUTPUT(0x0C)
```

`hidtool.py set_feature(fd, rid, payload)` prepends the report id itself, so
callers pass the payload **without** the leading id byte.

---

## 2. Report `0x0A` — settings register (41 B payload)

```
byte  meaning                         writable?
----  ------------------------------  ---------
0     report id (0x0A)                —
1     mode / effect index             NO  (see below)
2     status flag                     mirrors 0x0B[0]; NOT the colour register
3     speed (0..4)                    YES (readback = 4 - written)
4     brightness (0..5)               YES (readback = written; 0=off 5=full)

Read the register as 42 bytes (report id + 41 payload); write it with a
41-byte payload (`reg[1:]`) — the two lengths are asymmetric.
```

### mode (`[1]`)

- `0x00` = lights off.
- `0x01..0x13` = 19 effects.
- Changed by the Fn key on the keyboard. **Writing it does have an
  effect** — but not the one you asked for: the byte is a fixed
  *permutation* of the 20 effect indices, so the board lands on
  `MODE_FROM_WIRE[written]`, not on `written`. Echoing the value you
  just read therefore moves the effect on **every** `0x0A` write, which
  is what made the brightness/speed sliders cycle the keyboard's mode.
- The permutation is deterministic, bijective and independent of the
  previous state (measured twice across all 20 indices), so writing
  `MODE_TO_WIRE[mode]` re-lands on `mode` exactly.
  `rgbset.apply_settings()` always writes that inverted byte — 20/20
  settings writes preserved the mode across four different effects.
- Does **not** drift on its own — verified stable for 20 s with zero writes.
- Earlier apparent "random jumping" during probing was caused by our own
  `0x0A` writes perturbing state, not by the device.

Write → read map:

| write | `00` | `01` | `02` | `03` | `04` | `05` | `06` | `07` | `08` | `09` |
|---|---|---|---|---|---|---|---|---|---|---|
| read  | `00` | `06` | `08` | `0A` | `0C` | `07` | `05` | `0F` | `0E` | `0D` |

| write | `0A` | `0B` | `0C` | `0D` | `0E` | `0F` | `10` | `11` | `12` | `13` |
|---|---|---|---|---|---|---|---|---|---|---|
| read  | `10` | `0B` | `11` | `12` | `09` | `01` | `02` | `04` | `03` | `13` |

Fixed points: `00`, `0B`, `13`.

Observed behaviour map — all 20 named by eye on 2026-09-27 with
`tool/mode_namer.py` (Fn-driven, read-only), recorded in
`probes/mode-names.json`. "readback" is the value `0x0A[1]` shows.

| readback | class | description |
|---|---|---|
| `0x00` | — | off |
| `0x01` | blue | solid blue, full board, no animation |
| `0x02` | blue | blue breathe — full board fades in/out smoothly |
| `0x03` | **works** | colour cycle, all keys change together |
| `0x04` | **reactive** | key lights on press, fades out over ~1.5–2 s |
| `0x05` | **reactive** | row ripple outward from the pressed key |
| `0x06` | **works** | horizontal rainbow ripples, L→R |
| `0x07` | **reactive** | full ripple travelling in all directions |
| `0x08` | **works** | circular ripples, counter-clockwise |
| `0x09` | blue | zigzag / sine wave, width 1, right→left, always on |
| `0x0A` | **works** | row RGB, top→bottom |
| `0x0B` | blue | rain — random keys light and fade, no pattern |
| `0x0C` | **works** | circle out from centre |
| `0x0D` | blue | snake Esc→Pause, square to centre, spin, ripple out |
| `0x0E` | blue | same as `0x0D`, mirrored (starts at Pause) |
| `0x0F` | blue | dual snake from opposite corners, meet, spin, ripple |
| `0x10` | blue | snake travels row-by-row across the board |
| `0x11` | blue | two vertical trailing lines, crossing |
| `0x12` | blue | diagonal trailing lines (Esc→opp, then Pause→opp) |
| `0x13` | **works** | **STATIC PARTIAL — renders the `0x0B` frame buffer** |

Three classes:

- **works** (`03 06 08 0A 0C 13`) — never went dark, full colour.
- **reactive** (`04 05 07`) — dark until a key is pressed. Lives in
  `rgbset.REACTIVE`.
- **blue** (`01 02 09 0B 0D 0E 0F 10 11 12`) — animate on their own
  with no keypress, but render **only the blue channel**. Lives in
  `rgbset.ALWAYS_ON_BLUE`.

The split is exact: 6 / 3 / 10, no mode is ambiguous.

Mode `0x13` is the important one: it is the static per-key mode that
displays whatever is in `0x0B`.

**All ten blue modes are otherwise perfect** — geometry, timing,
trails and reactive response are correct on all 87 keys. Only colour
is wrong, which is the signature of a degraded palette table rather
than broken effect logic (see §5).

### speed (`[3]`) and brightness (`[4]`)

Both are **global** — there is no per-key brightness channel. Per-key
brightness is simply a darker colour on the `0x0B` frame.

- **brightness `[4]`**: write `v`, read back `v`, range 0..5 — 0 = off,
  5 = full. Confirmed by eye; this is the control that visibly
  brightens the board.
- **speed `[3]`**: reads back `4 - written` (write 0 → reads 4, write 4
  → reads 0, write 5 → reads 255). The tool decodes it as `4 - raw` and
  encodes by writing the level directly, so set/get round-trip exactly
  for 0..4. Static `0x13` ignores it — only the animated effects use it,
  and which direction is "faster" has **not** been confirmed (needs an
  Fn-cycled animated mode).

Because `[3]` inverts on read, a read-modify-write of `0x0A` has to
re-encode it: echoing the raw byte back flips it on every write, which
used to drag the reported brightness along with it and make the
brightness slider jump whenever the other field was touched.
`rgbset.apply_settings()` writes both fields decoded, in one
read-modify-write, to avoid that.

`rgbset.py --brightness N` / `--speed N`, and `POST /api/settings` in
the editor.

### byte `[2]`

Swept `00 / 40 / 80 / C0 / FF` while `0x0B` held white → colour never
changed. It is **not** a colour/palette register. It just tracks `0x0B[0]`
(off-by-one echo of the frame buffer's first byte) and is a red herring.

---

## 3. Report `0x0B` — per-key RGB frame buffer (**solved**)

378 bytes = **126 slots × 3 planes**, laid out **planar (channel-major)**,
**not** interleaved RGB triples:

```
bytes   0..125  = RED   of slots 0..125
bytes 126..251  = GREEN of slots 0..125
bytes 252..377  = BLUE  of slots 0..125
```

Verified end-to-end:

| payload | result |
|---|---|
| R plane = 255 | **all keys red** |
| G plane = 255 | all keys green |
| B plane = 255 | all keys blue |
| all planes 255 | all keys white |
| all zero | nothing lit |

### Why this was hard to find

The intuitive layout — `for key: emit RGB` — produces garbage:

- solid white (`FF FF FF …`) → white, which *looks* right
- solid red (`FF 00 00 FF 00 00 …`) → every 3rd key white, in a different
  set than solid green / solid blue

Because with the interleaved layout, a uniform colour is a repeating 3-byte
pattern, and each plane ends up receiving a sampled subset of it.

### Colourspace: the wire is LINEAR, designs are sRGB

Confirmed after `designs/example.json` was pushed:

| design asks for | what the board did |
|---|---|
| `esc = #ff3030` = `(255,48,48)` | rendered clearly **pink**, not red |
| `fn = background #0a0a14` = `(10,10,20)` | rendered a **visible light blue**, not near-black |

Both are explained if the board treats `0..255` as **linear intensity
(PMW duty)** rather than sRGB code values:

- linear `48/255 = 0.19` ≈ sRGB `125` → pink instead of red
- linear `10,10,20` ≈ sRGB `#34344E` → clearly visible blue-grey

Under an sRGB reading both would have been nearly solid red and nearly
black. `rgbset.py` therefore converts sRGB → linear on the way to the
wire (LUT of 183 distinct output levels), with `--raw` to bypass.

### Build helper

```python
def frame(colors):          # colors = {slot: (r, g, b)}
    r = [colors.get(i, (0,0,0))[0] for i in range(126)]
    g = [colors.get(i, (0,0,0))[1] for i in range(126)]
    b = [colors.get(i, (0,0,0))[2] for i in range(126)]
    return bytes(r + g + b)          # 378 bytes
```

---

## 4. Key map — slot index → physical key

Keyboard is **87 keys**, no numpad: F-row, number row, QWERTY block,
nav cluster (`prtsc scrlk pause / ins home pgup / del end pgdn`), arrows.

### The model

The board is a grid of columns × 6 rows, stored **column-major with
stride 6**, starting at **slot 1**:

```
slot = 1 + col * 6 + row

row 0 = F-row        row 1 = number row    row 2 = QWERTY row
row 3 = ASDF row     row 4 = ZXCV row      row 5 = bottom row
```

**Slot 0 is unused** (proved: lighting it lights nothing).

**Row 0 has a phantom slot at col 1** — the physical gap between `esc`
and `f1`. So `f1` sits at col 2, `f2` at col 3, … `f12` at col 13.
This is why the F-row appeared "off by one" until `modelcheck.py`.

### Evidence (every one confirmed by a probe)

| slot | key | slot | key | slot | key |
|---|---|---|---|---|---|
| 1 | esc | 19 | **f2** | 79 | f12 |
| 2 | `` ` `` | 20 | **3** | 80 | backspace |
| 3 | tab | 40 | **h** | 81 | `` \ `` |
| 10 | a | 41 | **n** | 82 | **enter** |
| 13 | **f1** | 61 | **f9** | 83 | **rshift** |
| 18 | lalt | 62 | **0** | 90 | **← left** |
| 31 | **f4** | 63 | p | 95 | **↑ up** |
| 52 | k | 64 | `;` | 96 | **↓ down** |
| 70 | `'` | 65 | `/` | 102 | **→ right** |

Bold = settled by `modelcheck.py` (run A/B/C/D) rather than assumed.

`verify.py` cross-checks, all matching: V2 → `19`=f2, `20`=3, `1`=esc,
`2`=tilde, `18`=lalt; V3 → `63`=p, `64`=;, `65`=/, and **77 & 78 are
empty**; V4 → `10`=a, `31`=f4, `52`=k, `70`=', `90`=left-arrow.

### Column contents

`·` = confirmed unused. Bold = settled by `modelcheck`/`finalmap`.

| col | row0 | row1 | row2 | row3 | row4 | row5 | slots |
|---|---|---|---|---|---|---|---|
| 0 | esc | `` ` `` | tab | caps | lshift | lctrl | 1–6 |
| 1 | **·**(7) | 1 | q | a | z | win | 7–12 |
| 2 | f1 | 2 | w | s | x | lalt | 13–18 |
| 3 | f2 | 3 | e | d | c | ·(24) | 19–24 |
| 4 | f3 | 4 | r | f | v | ·(30) | 25–30 |
| 5 | f4 | 5 | t | g | b | space | 31–36 |
| 6 | f5 | 6 | y | h | n | ·(42) | 37–42 |
| 7 | f6 | 7 | u | j | m | ·(48) | 43–48 |
| 8 | f7 | 8 | i | k | `,` | ralt | 49–54 |
| 9 | f8 | 9 | o | l | `.` | **fn**(60) | 55–60 |
| 10 | f9 | 0 | p | `;` | `/` | **option**(66) | 61–66 |
| 11 | f10 | – | `[` | `'` | ·(71) | ·(72) | 67–72 |
| 12 | f11 | = | `]` | ·(76) | ·(77) | ·(78) | 73–78 |
| 13 | f12 | backspace | `\` | **enter**(82) | **rshift**(83) | **rctrl**(84) | 79–84 |
| 14 | prtsc | ins | del | ·(88) | ·(89) | ← | 85–90 |
| 15 | scrlk | home | end | ·(94) | ↑ | ↓ | 91–96 |
| 16 | pause | pgup | pgdn | ·(100) | ·(101) | → | 97–102 |
| 17+ | (unused) | | | | | | 103–125 |

Notes on the irregular columns:

- Wide keys are mapped to the **rightmost** grid column they cover:
  `enter` (2.25u) → col13, `rshift` → col13. That is why `col12 row4/5`
  and `col11 row4` are empty while `'` stays at col11.
- `space` occupies a single slot (36) — one LED regardless of key width.
- Bottom row: `lctrl(6) win(12) lalt(18) space(36) ralt(54) fn(60)
  option(66) rctrl(84)`. Slots 24, 30, 42, 48 are confirmed empty, so
  `space` does **not** span them — one LED, slot 36.
- Arrows form the standard cross: `←`=90 (col14 row5), `↑`=95
  (col15 row4), `↓`=96 (col15 row5), `→`=102 (col16 row5).
- Nav cluster: `prtsc/ins/del` in col14, `scrlk/home/end` in col15,
  `pause/pgup/pgdn` in col16. `modelcheck` runs C and D lit exactly
  9 keys in 85–96 and 4 keys in 97–125 — matching this table precisely.

### Complete — 87 keys / 39 unused slots

`finalmap.py` closed the last nine slots:

| slot | key | how |
|---|---|---|
| 60 | **fn** | run F, cyan |
| 66 | **option** (menu) | run F, magenta |
| 82 | **enter** | run F, green (also V1 gap list) |
| 83 | **rshift** | run F, yellow (also V1 gap list) |
| 84 | **rctrl** | run G, blue; confirmed by run H bottom row |
| 7, 71, 72, 76, 77, 78, 88, 89, 94, 100, 101 | **unused** | run F/G/H showed nothing; V3 showed 77 & 78 empty |

Run H (whole bottom row, slots 24–84) lit exactly
`space ralt fn option rctrl` — matching the table, nothing extra.

Key count: **16 + 17 + 17 + 13 + 13 + 11 = 87**, which is exactly the
board's key count. Unused slots total 39: `0, 7, 24, 30, 42, 48, 71, 72,
76, 77, 78, 88, 89, 94, 100, 101, 103–125`.

### Machine-readable layout

`docs/keyboard-layout.json` — generated by `layout.py`, validated on
every run (`slot == 1 + col*6 + row` for all 87 keys, no duplicate
slots/ids, no row overflow). Each entry:

```json
{"id": "esc", "label": "Esc", "slot": 1, "col": 0, "row": 0,
 "x": 0.0, "y": 0, "w": 1.0, "h": 1.0}
```

`x`/`y`/`w` are physical positions in key units (1u = one alpha key,
board is 18.25u wide) — enough for the GUI app to lay out a real
keyboard drawing and address each key's LED.

```python
from layout import slot_of, key_of, BY_ID, BY_SLOT, KEYS, UNUSED
slot_of("f1")     # 13
key_of(82)        # "enter"
```

---

## 5. Known issues / history

### Degradation of the built-in reactive effects (pre-existing, before any probing)

User's timeline on modes other than the always-lit ones:

1. day one — full RGB
2. after ~days — only **red** visible
3. after ~months — **orange-tinted red**
4. after our first (read-only) probe run — **no light at all**

The always-lit modes were unaffected throughout. This started before we
wrote anything, so it is a separate fault — most likely a colour/palette
table in firmware flash degrading, or genuinely failing LEDs in the
reactive modes' path.

Note: **`0x0B` writes are not the cause** — mode `0x13` reads `0x0B`
happily and renders it. Whatever broke the reactive modes lives elsewhere.

### The 13 dark modes were already dark during `survey.py`

`probes/survey.json` holds a description for all 19 modes, recorded by
pressing Fn and reading `0x0A[1]` back. Six lit, thirteen did not:

| readback | lit | description recorded at survey time |
|---|---|---|
| `0x03` | yes | full-keyboard colour cycle, all keys change together |
| `0x06` | yes | rainbow ripples, left → right |
| `0x08` | yes | circular ripples, counter-clockwise |
| `0x0A` | yes | row RGB, top → bottom (full lit) |
| `0x0C` | yes | circle out from centre (full lit) |
| `0x13` | yes | static partial — the specific lit key list |
| `0x01 0x02 0x04 0x05 0x07 0x09 0x0B 0x0D 0x0E 0x0F 0x10 0x11 0x12` | **no** | "now i see no light at all" |

So the thirteen `?` entries in `MODE_NAMES` are not unidentified — they
are *unlit at the moment of survey*. That survey already sat inside our
first session, so it cannot separate "killed by us" from "finished
dying".

### Why they look dead: nobody watched them while typing

Every survey entry also carries `readback_after_typing` — the register
bytes after typing on the board. They never moved. **That field only
proves the register is inert; it never recorded whether light appeared
while the keys were being pressed.**

These are the modes RESEARCH.md calls *reactive effects*, and your own
phrasing was "cool interactive animations". A reactive effect with an
idle keyboard renders black, which is indistinguishable from broken.

`tool/reactive_test.py` closes that gap: it lands on each of the
thirteen dark modes with brightness forced to full, optionally sweeps
speed (`byte [3]`, whose meaning is still unconfirmed), waits while you
mash keys, then restores the original mode. It writes `0x0A` only.

**Result: still dark.** Key presses, held keys, and every speed `0..4`
produced nothing in `0x07`, `0x0D` or `0x12`, with brightness pinned at
`5`. Replugging did not help either.

### The 13 modes came alive on 2026-09-27 — and were lost again

For ~16 hours after the first write probes, the 13 modes were dark.
Then, with **no host writes happening at all**, they came back:

| time | what happened | 13 modes |
|---|---|---|
| 09-26 19:15–20:10 | `hunt.py` / `round2.py` write black and white into `0x0B` | dark |
| 09-26 21:28 | `survey.py` records "no light at all" ×13 | dark |
| 09-27 11:29–12:41 | force-push, palette, latch and reactive probes | dark |
| 09-27 12:41 | last write of the day | dark |
| 09-27 ~12:45 | board moved to the 2.4G dongle — host cannot write | dark |
| 09-27 ~13:00 | **cord plugged while the switch was still on dongle**, then Fn cycled — **all 13 lit** | **LIT** |
| 09-27 13:08–14:05 | `mode_namer.py` runs read-only; all 13 named by eye | **LIT** |
| 09-27 14:09–14:27 | `colour_source.py` + `mode_lab.py` write `0x0A`/`0x0B`/`0x0C` | dark |
| 09-27 14:27–14:55 | 28 minutes with the server killed, zero writes | still dark |
| 09-27 14:59–15:00 | `0x0C` restored to the exact lit-state image, and to zeros | still dark |

While lit, all 10 `blue` modes ran **perfectly** — correct geometry,
correct trails, correct reactive response — in **blue only**. The
`reactive` trio lit on keypress as designed. So the effect engine and
the animations are intact in firmware; only the palette is wrong.

**This is not "dead modes".** It is two separate facts:

1. **Palette: blue only.** Matches the user's original degradation
   timeline (full RGB → red → orange → dark), i.e. a colour table in
   flash losing channels. The always-lit modes were never affected.
2. **Effect engine: switches off and does not come back.** Something
   turns the 13 modes dark; nothing we can send brings them back.

### What was ruled out after the revival

All negative, on 2026-09-27 between 14:09 and 15:00. Recorded so they
are not repeated.

| suspect | test | result |
|---|---|---|
| `0x0B` feeds the colour | `mode_lab.py 2 3 4` — solid white, red, blue written **while inside** the mode, then Fn'd in to check | **inert.** Static mode changed correctly each time; the 13 stayed dark |
| `0x0B` blue plane (hypothesis that black→dark / white→blue) | same three writes | **dead** — red and green did not darken them further; they were already dark |
| `0x0C` content | `mode_lab.py 7` — restored byte-for-byte the image held at 13:08 while LIT (`0A 7A 01` + 1917×`FF`), tested **in-mode** and **on re-entry** | **no effect** |
| `0x0C` factory image | `mode_lab.py 9` — 1920×`00`, in-mode and re-entry | **no effect** |
| `0x0A` register contents | the 42-byte image at 13:08 (LIT) and at 14:18 (DARK) are **identical**: `0a 13 ff 03 05` | **cannot be the cause** — same state, different outcome |
| time with no writes | 14:27 → 14:55, server killed, zero traffic | **still dark** — falsifies the "self-recovers after ~27 min" theory that the 12:41→13:08 gap suggested |
| MCU power cycle | connection switch dongle→USB and back | **no effect** |
| `0x09` key map | restored to the `snap.json` factory image | no effect (already recorded above) |
| `0x0C` header variants | bare, `[0A 7D 07]`, `[0A 7A 01]` — and now again with re-entry | no effect (twice) |
| `0x0A[2]` flag | swept `00/01/40/80/FF` inside a dark mode | no effect |
| OUTPUT transport | `HIDIOCSOUTPUT` | `EPIPE` / `ETIMEDOUT` — does not exist |

**A trap worth remembering:** a byte-for-byte echo of `0x0A` is *not* a
no-op. `0x0A[3]` is stored as a *level*, so the register's raw `03`
means level `1`; writing `03` back makes the device store level `3` and
read back `01`. The first `mode_lab.py 5` silently changed the speed
and therefore proved nothing. Use `rgbset.apply_settings(fd)` with no
fields set — that is a genuine no-op write.

Also note: `colour_source.py` was run with `--mode 10`, but parsed it as
**decimal 10 = `0x0A`** rather than hex `0x10`, so its whole payload
sweep happened inside a working mode. That run tested nothing. Both
bugs are fixed.

### Verdict on the 13 modes

Every host-reachable write path is now closed, twice over:

| report | state |
|---|---|
| `0x05` | write-only, **forbidden** (the ISP/bootloader report — see §8) |
| `0x09` | restored to factory — no effect |
| `0x0A` | fully decoded; bytes `5..41` zero in the factory image; register byte-identical between the LIT and DARK states, so its contents are exonerated |
| `0x0B` | frame; white/red/blue pushed while inside a dark mode — inert for these modes |
| `0x0C` | restored to both the lit-state image and zeros, in-mode and on re-entry — inert |

The one remaining suspect is `0x05` — but that is the ISP bootloader
report, not a lighting register, and writing it risks the bootloader.
There is also exactly one thing never done: **read the firmware itself.**

Not yet tried, and free: Fn long-press / Fn+arrow combos, and repeating
the original revival sequence exactly (cord plugged *while* the switch
still sits on dongle, Fn cycled there, *then* flipped to USB).

### Things we broke / changed along the way

- Several runs left the board in mode `0` (all-dark) or at brightness `0`
  after restoring `0x0A`. Recover with the Fn lighting key.
- `0x0B` and `0x0C` have been overwritten with test patterns many times.
  The original factory content of the mode-`0x13` pattern is **gone**.
- `0x0C` was rewritten again (green/white/red/ramp/white, with and
  without headers) during the palette and latch experiments, on
  explicit request. Its factory content was already lost.
- `0x09` was rewritten with the `snap.json` factory image. The
  overwritten content is saved at `probes/map09-<ts>.bin`.

### Safety rules

- **Never write report `0x05`.** It is the command/flash register.
- `0x0C` cannot be backed up (no readback). It is also now known to be
  inert, so do not write it unless a specific hypothesis is being
  tested — and record what was written.
- Always send `0x0B` at exactly 378 bytes (379 with report id).
- Always send `0x0A` at exactly 41 bytes.
- Run `tool/backup.py` before any experiment that writes `0x0A`, and
  restore that image (mode byte encoded through `MODE_TO_WIRE`) when
  the probe finishes.
- Back up `0x09` before writing it; `tool/keymap_restore.py` does both
  and saves the previous image to `probes/`.

---

## 6. Tooling

All under `~/projects/keyboard_rgb/` (`tool/`, `probes/`, `app/`).
Scripts touching the board need `sudo` until the udev rule below lands.

| script | purpose |
|---|---|
| `hidparse.py` | decode a HID report descriptor |
| `hidtool.py` | `list` / `id` / `resolve` / `get` / `set` / `all` / `snapshot` / `diff` |
| `ledtest.py` | early LED frame sender (interleaved layout — **obsolete**, kept for `frames()`/`GRID`) |
| `probe.sh`, `probe_kb.sh` | full device dump → `snap.json` |
| `hunt.py` | report-id / mode hunt → `hunt_result.json` |
| `round2.py` | Fn differential + header-in-payload frames → `phase1.json`, `round2.json` |
| `diag.py` | per-step variable isolation → `diag.json` |
| `survey.py` | byte writability + 19-mode survey → `survey.json` |
| `static.py` | drift test + buffer probes in mode `0x13` → `static.json` |
| `pattern.py` | spatial quarters / colour / byte2 sweep → `pattern.json` |
| `map.py` | plane confirmation + colour-band mapping → `map.json` |
| `verify.py` | offset/contiguity checks → `verify.json` |
| `modelcheck.py` | validates the stride-6 model (F-row, nav, bottom) → `modelcheck.json` |
| `finalmap.py` | last 9 untested slots → `finalmap.json` |
| `layout.py` | validates + emits `docs/keyboard-layout.json`; imports `slot_of`/`key_of` |
| `rgbset.py` | **the actual tool** — set per-key colours from a design file |
| `watch.py` | polls `0x0A` and prints every byte that changes |
| `backup.py` | read-only snapshot of all 42 `0x0A` bytes to `probes/` |
| `reactive_test.py` | walk the 13 dark modes while you press keys, then restore |
| `palette_test.py` | write candidate `0x0C` payloads, watch a working mode as the control |
| `latch_test.py` | write `0x0B`/`0x0C` *inside* a dark mode, sweep the flag byte, re-enter |
| `keymap_restore.py` | put `0x09` back to the `snap.json` factory image (revertible) |
| `designs/*.json` | example designs for `rgbset.py` |

Outputs are JSON alongside the scripts.

### `rgbset.py`

```bash
sudo python3 rgbset.py --status                 # mode, brightness, speed
sudo python3 rgbset.py --list                   # key ids, slots, groups
sudo python3 rgbset.py --solid '#ff8000'         # every key one colour
sudo python3 rgbset.py --keys 'esc=red,wasd=white,frow=blue'
sudo python3 rgbset.py --brightness 4           # 0..5, global (0=off)
sudo python3 rgbset.py --speed 3                # 0..4, global
sudo python3 rgbset.py designs/example.json
```

Colours refuse to write unless `0x0A[1] == 0x13` (override with
`--force`) and go out on report `0x0B` (378 B, exact); `0x05` is never
touched. `--brightness` / `--speed` write `0x0A` through
`apply_settings()`, which encodes both fields decoded and inverts the
mode byte so the effect does not move.

### `watch.py`

```bash
python3 tool/watch.py                        # poll every 100 ms
python3 tool/watch.py --interval 0.05 --seconds 30
python3 tool/watch.py --out /tmp/opencode/watch.log
```

Read-only: prints one line per observed change, with the raw image and
which byte moved. Use it while dragging the editor's sliders or pressing
Fn.

**Colourspace.** Colours in designs / `--solid` / `--keys` are sRGB and
are converted to the board's **linear** wire format automatically. Use
`--raw` (or `"colorspace": "raw"` in the file) to send bytes untouched —
that is the behaviour that produced the pink `esc` and light-blue
`fn` in the first test run.

Design file format:

```json
{
  "background": "#0a0a14",
  "keys": {
    "esc": "#ff3030",
    "wasd": "#ffffff",
    "arrows": "off",
    "numbers": ["#ff4000", "#ff8000", "..."],
    "frow": "#3060ff"
  }
}
```

- values are `"#rrggbb"` / `"rrggbb"` / a named colour / `"off"`
- names are key ids from `keyboard-layout.json` or a group
  (`all main rightside esc frow numbers qwerty homerow shiftrow mods
  nav arrows wasd esdf`)
- **key ids win over group names** — a name that is a real key always
  means that key. `right`/`home` used to be group names too and were
  shadowing the Right-arrow and Home keys, which made the whole nav
  cluster unaddressable; the groups are now `rightside` and `homerow`.
- a **list** cycles through the group's keys in layout order
- `0x0B` is write-only, so a design defines the **whole** frame —
  anything not mentioned becomes `background` (or off)

### `backup.py`

```bash
python3 tool/backup.py                    # probes/backup-0x0A-<ts>.json
python3 tool/backup.py --tag before-probe
```

Read-only. Dumps all 42 `0x0A` bytes plus a decoded summary before an
experiment, and reports which of bytes 5..41 are non-zero so you can
tell at a glance whether there is any undiscovered state at stake.
Measured so far, **bytes 5..41 are all zero** — the only live fields
are mode, flag, speed and brightness.

### `mode_namer.py`

```bash
python3 tool/mode_namer.py              # poll 0x0A, you press Fn
python3 tool/mode_lab.py --redo 7,13    # re-ask specific modes
```

**Zero writes.** Opens the board, polls `0x0A[1]`, and every time the
byte holds still for 0.6 s it asks what is on the screen: lit idle?
reacts to keys? colour? description? Appends to
`probes/mode-names.json` after *every* entry, so Ctrl-C loses nothing.

This is what named all 20 modes on 2026-09-27 (§2 table). Because it
never writes, it is also the only probe that can observe the board's
natural state — which is how the 13 modes were caught alive.

### `colour_source.py`

Superseded by `mode_lab.py`. First attempt at finding where the blue
modes get their colour. **Its results are void**: `--mode 10` was
parsed as decimal `10` = `0x0A`, not hex `0x10`, so the entire payload
sweep ran inside a working mode that reads neither `0x0B` nor `0x0C`.
Kept for the hypothesis write-up in its docstring.

### `mode_lab.py`

```bash
python3 tool/mode_lab.py 1         # read-only baseline
python3 tool/mode_lab.py 2 3 4     # 0x0B white/red/blue, in place
python3 tool/mode_lab.py 5         # true no-op write of 0x0A
python3 tool/mode_lab.py 7         # 0x0C lit-state image, in + re-entry
python3 tool/mode_lab.py r         # 0x0B back to solid white
```

One step per invocation, so a result is never ambiguous. **Never writes
`0x0A` except in step 5**, whose whole purpose is to test whether the
*act* of writing `0x0A` is what kills the effect engine. The mode is
always chosen by your Fn key; the tool only reads the register to
confirm which mode you reached, and **aborts if the mode moved during a
write** so a result cannot be attributed to the wrong effect.

Steps 7/8/9 reconstruct `latch_test.py`'s header variants exactly
(`[0A 7A 01]`, `[0A 7D 07]` over a solid-white base) plus a 1920×`00`
factory candidate, and test each **while inside** the mode and **after
leaving and re-entering it**.

> A raw byte-for-byte echo of `0x0A` is not a no-op — `0x0A[3]` is
> stored as a level. Step 5 therefore uses `apply_settings(fd)` with no
> fields set, which is the genuine no-op. See §5.

### Web app (`app/`)

A stdlib-only editor — no framework, no build step, no `tkinter`.

```bash
python3 app/server.py            # http://127.0.0.1:8787
python3 app/server.py --no-board # UI only (board absent / no hidraw access)
sudo python3 app/server.py       # until the udev rule is active
```

Rendered from `docs/keyboard-layout.json` (each key has `x/y/w/h` in
key units, board is 18.25u wide), so adding a key never means touching
the UI. Paint / erase / eyedropper, drag-paint, group chips, fills,
undo-redo (Ctrl+Z / Ctrl+Shift+Z), design save/open, srgb/raw toggle.

API (`127.0.0.1:8787`):

| method | path | body |
|---|---|---|
| GET | `/api/layout` | — |
| GET | `/api/status` | mode/brightness/speed, or 503 |
| GET | `/api/groups` | — |
| GET | `/api/designs`, `/api/designs/<name>` | — |
| POST | `/api/designs/<name>` | design JSON |
| GET | `/api/state` | last design pushed to the board |
| GET | `/api/modes` | 20 modes with hex, name, `static` flag |
| POST | `/api/apply` | design JSON → report `0x0B`, then persisted; `force: true` pushes in any mode |
| POST | `/api/settings` | `{mode?: 0..19, brightness?: 0..5, speed?: 0..4}` → `0x0A` |
| DELETE | `/api/designs/<name>` | renames to `.deleted` (never `rm`) |

The apply path is `rgbset.py.frame()` + `rgbset.py.resolve()` — the
board never sees a second implementation. It refuses unless
`0x0A[1] == 0x13` (unless `force` is set), writes only `0x0B`, never
touches `0x05`.

**Mode switch.** The board group has a mode selector that replaces the
Fn key: it posts `{mode}` to `/api/settings`, and `apply_settings()`
writes `MODE_TO_WIRE[mode]` so the requested effect actually lands
(verified 20/20). Switching to `0x13` enables editing; anything else
disables apply unless the *push frame even in non-static modes* box is
ticked — that flag exists to test whether any other effect reads
`0x0B`.

**State on reload.** `0x0B` cannot be read back (GET stalls with
`EPIPE`), so the board's colours are unknowable from software. The
server therefore records every applied design to
`~/.local/state/keyboard_rgb/last.json` and the editor rehydrates from
`GET /api/state` on load — it shows what *it* last pushed, not what the
hardware reports. The `auto` toggle and colourspace live in
`localStorage`.

**hidraw access without sudo.** `system/jinnnn/keyboard-rgb.nix` in the
nixconfig repo adds a udev rule (`GROUP="users" MODE="0660"
TAG+="uaccess"` for `258a:0049` and `25a7:fa70`). Take it with:

```bash
sudo nixos-rebuild switch --flake ~/nixconfig#jinnnn
```

### Reference projects (different hardware, useful protocol hints)

- <https://github.com/EvanSunde/Sinodragon> — `keyboard_controller.py`,
  header `[0x08, 0x0A, 0x7A, 0x01]`, 382 B, 16×6 grid.
- <https://github.com/chancellor1101/redragon-ks82b-rgb> — `ks82rgb`,
  report id `0x08`, header `0x0A 0x7A 0x01` + 126 triples.
- Header decode hypothesis: `0x0A` = cmd, `7A 01` = length `0x017A = 378`
  LE. **Tested and did not work on this board** — this device wants a bare
  378-byte planar payload with no header.

---

## 7. Next steps

1. ~~Frame format~~, ~~mode register~~, ~~87-key slot map~~,
   ~~layout JSON~~, ~~rgbset.py~~, ~~udev rule~~, ~~web editor~~ —
   **all done.**
2. `sudo nixos-rebuild switch --flake ~/nixconfig#jinnnn` to activate
   the udev rule, then confirm non-root hidraw:
   `python3 tool/hidtool.py resolve 0003:258A:0049`.
3. Open `http://127.0.0.1:8787`, apply a design end-to-end from the
   browser (keyboard must be on **USB** — BT / 2.4G are unimplemented).
4. The 13 modes (§5) are **closed from the host side** — every
   reachable register written and observed, both transports tried,
   `0x09` restored to factory, the lit-state `0x0C` image restored,
   and a 28-minute no-write window tried. Two free things remain
   before the firmware route: Fn long-press / Fn+arrow combos, and
   repeating the original revival sequence exactly (cord plugged
   *while* the switch still sits on dongle, Fn cycled there, then
   flipped to USB). **Do not write `0x05`.**
5. **Dump the firmware** — see §8. This is the only remaining way to
   find the palette those 10 modes read, and to see whether the
   blue-only colour table is a flash fault or by design.
6. Optional: read the vendor channel over BT (`000E:3412`) so the
   editor works wirelessly too.

---

## 8. Firmware dump via the ISP bootloader (planned)

The `0x0B`/`0x0C`/`0x0A` routes are exhausted. The one thing never
done is reading the flash itself.

**Tool:** [`sinowisp`](https://github.com/carlossless/sinowisp)
(formerly `sinowealth-kb-tool`), Rust, v2.1.0, actively maintained.
Reads and writes flash on Sinowealth 8051 devices through the built-in
ISP bootloader. Linux binary already downloaded to
`/tmp/opencode/sinowisp`.

> **This is where report `0x05` comes from.** The tool takes
> `--isp_report_id 5`. So `0x05` is the *ISP bootloader's* report ID —
> the long-standing "never write `0x05`" rule is not superstition:
> writing it in normal operation hands the MCU to the in-system
> programmer, which is where the bricking reports come from. The rule
> stands, but `sinowisp` is the tool that is *supposed* to use it.

**Exact command** (our device is not in the supported list, so custom
mode is required; the keyboard must be on **USB**, not the dongle):

```sh
sinowisp read \
    --platform sh68f90 \
    --vendor_id 0x258a --product_id 0x0049 \
    --isp_iface_num 1 --isp_report_id 5 \
    -s full full.hex
```

Unknowns, in order of risk:

- **MCU family.** `--platform` must be right. Candidates in the
  supported list are `sh68f90` (most common — SH68F90/SH68F90A) and
  `sh68f881`. Wrong platform means wrong `firmware_size` /
  `bootloader_size` / `page_size`.
- **Whether our board's bootloader matches a known ISP MD5.** If it
  does not, the tool has no protocol for it.
- **Entering ISP re-enumerates the device**, probably under a
  different VID:PID (`0603:1020` and friends). Our udev rule only
  covers `258a:0049`, so the read may need root or a new rule.
- **Getting out.** If the read fails mid-way the board may sit in the
  bootloader. The tool has `--reboot false` to avoid rebooting, and
  `sinowisp write` can always put the image back — so take the dump
  first, and keep the machine plugged in.

Per the tool's own docs: a read sets an `LJMP` (`0x02`) at
`<firmware_size-5>` if it is not already there, which should already be
the case, so a read *should* be non-destructive. It also redirects
`0x0001–0x0002`, so the produced hex differs from the true flash
layout — remember that when disassembling.

**What we are looking for in the dump:**

1. the palette / colour table the 10 `blue` modes read — is it
   physically blue-only, or does something gate it?
2. the effect table, to confirm the mode permutation
   (`MODE_FROM_WIRE`) is a firmware table and not a hash.
3. whether there is a flag that turns the effect engine off — the
   thing that put the 13 modes dark and never let them back.
