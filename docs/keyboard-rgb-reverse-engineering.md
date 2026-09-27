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
3     brightness (0..4)               NO
4     speed (0..5)                    YES
```

### mode (`[1]`)

- `0x00` = lights off.
- `0x01..0x13` = 19 effects.
- Changes **only** via the Fn key on the keyboard. Writing it has no effect.
- Does **not** drift on its own — verified stable for 20 s with zero writes.
- Earlier apparent "random jumping" during probing was caused by our own
  `0x0A` writes perturbing state, not by the device.

Observed behaviour map (user descriptions, `readback mode` → what is shown):

| mode | description |
|---|---|
| `0x03` | all keys same colour, cycling together (full lit) |
| `0x06` | horizontal rainbow ripples L→R |
| `0x08` | circular clockwise ripples |
| `0x0a` | row RGB top→bottom (full lit) |
| `0x0c` | circle out from centre (full lit) |
| **`0x13`** | **STATIC PARTIAL — renders the `0x0B` frame buffer** |
| others | currently dark (see §5) |

Mode `0x13` is the important one: it is the static per-key mode that
displays whatever is in `0x0B`.

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

### Things we broke / changed along the way

- Several runs left the board in mode `0` (all-dark) or at brightness `0`
  after restoring `0x0A`. Recover with the Fn lighting key.
- `0x0B` and `0x0C` have been overwritten with test patterns many times.
  The original factory content of the mode-`0x13` pattern is **gone**.

### Safety rules

- **Never write report `0x05`.** It is the command/flash register.
- Always send `0x0B` at exactly 378 bytes (379 with report id).
- Always send `0x0A` at exactly 41 bytes.
- Restore `0x0A` to the value read at start when a probe finishes.

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
| `designs/*.json` | example designs for `rgbset.py` |

Outputs are JSON alongside the scripts.

### `rgbset.py`

```bash
sudo python3 rgbset.py --status                 # mode, brightness, speed
sudo python3 rgbset.py --list                   # key ids, slots, groups
sudo python3 rgbset.py --solid '#ff8000'         # every key one colour
sudo python3 rgbset.py --keys 'esc=red,wasd=white,frow=blue'
sudo python3 rgbset.py designs/example.json
```

It refuses to write unless `0x0A[1] == 0x13` (override with `--force`),
writes only report `0x0B` (378 B, exact), and never touches `0x05` or
`0x0A`.

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
| POST | `/api/apply` | design JSON → report `0x0B` |
| DELETE | `/api/designs/<name>` | renames to `.deleted` (never `rm`) |

The apply path is `rgbset.py.frame()` + `rgbset.py.resolve()` — the
board never sees a second implementation. It refuses unless
`0x0A[1] == 0x13`, writes only `0x0B`, never touches `0x05`.

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
4. Optional: investigate the degraded reactive modes (§5) — or treat
   mode `0x13` + `0x0B` as sufficient, since it already gives full
   per-key control of all 87 keys.
5. Optional: read the vendor channel over BT (`000E:3412`) so the
   editor works wirelessly too.
