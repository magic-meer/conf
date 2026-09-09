# nixconfig - NixOS Configuration

<sub><font color="red"><b>WARNING: This is a personal NixOS config not meant for copying. Copying may cause unexpected issues or broken configurations.</b></font></sub>

---

## Description

My very own NixOS configuration for the `jinnnn` host (x86_64-linux). Contains device-specific system configuration and user home-manager configuration for `meher`.

## Structure

### System Configuration (`system/jinnnn/`)

- Boot, hardware, locale, networking, packages, and user modules
- Auto-generated via `nixos-generate-config`
- `android-dev.nix` — Kotlin Multiplatform toolchain (Android SDK via androidenv + `android-dev-env` FHS shell + device udev rules; no emulator/Android Studio). Guide: `docs/kotlin-multiplatform-dev.md`

### Home Manager (`home/meher/`)

User-specific configuration organized by application:

| Directory | Description |
|---|---|
| `assets/` | Static assets |
| `default.nix` | Entry point for home-manager |
| `fish.nix` | Fish shell configuration |
| `keybinds/` | Central symlinks to all app keybind files |
| `kitty/` | Kitty terminal config |
| `niri/` | Niri window manager config |
| `nixvim/` | NixVim configuration |
| `packages.nix` | **All user packages must be declared here and nowhere else** |
| `quickshell/` | Quick shell configuration |
| `shell.nix` | Shell.nix entry point |
| `starship.nix` | Starship prompt config |
| `stylix.nix` | Stylix (theme) config |
| `swaync/` | SwayNC notification config |
| `tlauncher/` | TLauncher config |
| `waybar/` | Waybar config |
| `zed.nix` | ZED editor config |
| `ghostty.nix` | Ghostty terminal config |
| `git.nix` | Git configuration |
| `gtk.nix` | GTK theming |
| `swaylock.nix` | Sway lock config |
| `waybar/` | Waybar bar config |

### Keybinds

- `home/meher/keybinds/` - Central directory of symlinks to per-app keybind files

## rebuild

```bash
sudo nixos-rebuild switch --flake ~/nixconfig#jinnnn
```

## Inputs

- `nixpkgs` - Nixos unstable / stable
- `home-manager` - nix-community home-manager
- `niri`, `nixvim`, `zen-browser`, `opencode`, `windscribe-nixos`, `agenix`, `stylix`

## Notes

- ⚠️ **Do not copy this config blindly** - it is tailored to my specific hardware and workflow
- System `stateVersion` and home `stateVersion` both pinned to `"26.05"`
- Single host (`jinnnn`), single user (`meher`)
- Shell: fish (user default), aliases defined in `home/meher/shell.nix`