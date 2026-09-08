{
  ...
}: {
  programs.niri.settings.binds = {
    # Hotkey overlay
    "Mod+Shift+Slash".action.show-hotkey-overlay = [];

    # Launcher (Mod+Space re-press exits fuzzel, acting as a toggle)
    "Mod+D".action.spawn = "fuzzel";
    "Mod+Space".action.spawn-sh = "pkill -x fuzzel || fuzzel";

    # Terminal / browser / file manager (from env vars, with defaults)
    "Mod+T".action.spawn-sh = "\${TERMINAL:-kitty}";
    "Mod+B".action.spawn-sh = "\${BROWSER:-zen}";
    "Mod+E".action.spawn-sh = "\${TERMINAL:-kitty} -e \${FILE_MANAGER:-superfile}";

    # Lock screen
    "Mod+Shift+L" = {
      action.spawn = "swaylock";
      allow-when-locked = true;
    };

    # Overview
    "Mod+O" = {
      action.toggle-overview = [];
      repeat = false;
    };

    # Close window
    "Mod+Q" = {
      action.close-window = [];
      repeat = false;
    };

    # Window focus (vim-style arrow cluster: H/L horizontal, Y/N vertical)
    "Mod+Left".action.focus-column-left = [];
    "Mod+Down".action.focus-window-down = [];
    "Mod+Up".action.focus-window-up = [];
    "Mod+Right".action.focus-column-right = [];
    "Mod+H".action.focus-column-left = [];
    "Mod+Y".action.focus-window-up = [];
    "Mod+N".action.focus-window-down = [];
    "Mod+L".action.focus-column-right = [];

    # Move windows (mirrors the focus keys) — Mod+Alt acts as the "window" layer
    "Mod+Alt+Left".action.move-column-left = [];
    "Mod+Alt+Down".action.move-window-down = [];
    "Mod+Alt+Up".action.move-window-up = [];
    "Mod+Alt+Right".action.move-column-right = [];
    "Mod+Alt+H".action.move-column-left = [];
    "Mod+Alt+J".action.move-window-down = [];
    "Mod+Alt+K".action.move-window-up = [];
    "Mod+Alt+L".action.move-column-right = [];

    # Resize windows (Mod+Alt+Shift layer)
    "Mod+Alt+Shift+Left".action.set-column-width = "-10%";
    "Mod+Alt+Shift+Right".action.set-column-width = "+10%";
    "Mod+Alt+Shift+Up".action.set-window-height = "+10%";
    "Mod+Alt+Shift+Down".action.set-window-height = "-10%";
    "Mod+Alt+Shift+H".action.set-column-width = "-10%";
    "Mod+Alt+Shift+L".action.set-column-width = "+10%";
    "Mod+Alt+Shift+K".action.set-window-height = "+10%";
    "Mod+Alt+Shift+J".action.set-window-height = "-10%";

    # Column first/last
    "Mod+Home".action.focus-column-first = [];
    "Mod+End".action.focus-column-last = [];
    "Mod+Ctrl+Home".action.move-column-to-first = [];
    "Mod+Ctrl+End".action.move-column-to-last = [];

    # Workspace navigation (previous/next)
    "Mod+Page_Down".action.focus-workspace-down = [];
    "Mod+Page_Up".action.focus-workspace-up = [];
    "Mod+J".action.focus-workspace-down = [];
    "Mod+K".action.focus-workspace-up = [];
    "Mod+U".action.focus-workspace-down = [];
    "Mod+I".action.focus-workspace-up = [];
    "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [];
    "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [];
    "Mod+Ctrl+J".action.move-column-to-workspace-down = [];
    "Mod+Ctrl+K".action.move-column-to-workspace-up = [];
    "Mod+Ctrl+U".action.move-column-to-workspace-down = [];
    "Mod+Ctrl+I".action.move-column-to-workspace-up = [];

    # Scroll wheel workspace switching
    "Mod+WheelScrollDown" = {
      action.focus-workspace-down = [];
      cooldown-ms = 150;
    };
    "Mod+WheelScrollUp" = {
      action.focus-workspace-up = [];
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollDown" = {
      action.move-column-to-workspace-down = [];
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollUp" = {
      action.move-column-to-workspace-up = [];
      cooldown-ms = 150;
    };

    "Mod+WheelScrollRight".action.focus-column-right = [];
    "Mod+WheelScrollLeft".action.focus-column-left = [];
    "Mod+Ctrl+WheelScrollRight".action.move-column-right = [];
    "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [];

    "Mod+Shift+WheelScrollDown".action.focus-column-right = [];
    "Mod+Shift+WheelScrollUp".action.focus-column-left = [];
    "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = [];
    "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = [];

    # Workspace by number
    "Mod+1".action.focus-workspace = 1;
    "Mod+2".action.focus-workspace = 2;
    "Mod+3".action.focus-workspace = 3;
    "Mod+4".action.focus-workspace = 4;
    "Mod+5".action.focus-workspace = 5;
    "Mod+6".action.focus-workspace = 6;
    "Mod+7".action.focus-workspace = 7;
    "Mod+8".action.focus-workspace = 8;
    "Mod+9".action.focus-workspace = 9;

    "Mod+Ctrl+1".action.move-column-to-workspace = 1;
    "Mod+Ctrl+2".action.move-column-to-workspace = 2;
    "Mod+Ctrl+3".action.move-column-to-workspace = 3;
    "Mod+Ctrl+4".action.move-column-to-workspace = 4;
    "Mod+Ctrl+5".action.move-column-to-workspace = 5;
    "Mod+Ctrl+6".action.move-column-to-workspace = 6;
    "Mod+Ctrl+7".action.move-column-to-workspace = 7;
    "Mod+Ctrl+8".action.move-column-to-workspace = 8;
    "Mod+Ctrl+9".action.move-column-to-workspace = 9;

    # Consume/expel window
    "Mod+BracketLeft".action.consume-or-expel-window-left = [];
    "Mod+BracketRight".action.consume-or-expel-window-right = [];
    "Mod+Comma".action.consume-window-into-column = [];
    "Mod+Period".action.expel-window-from-column = [];

    # Column width presets
    "Mod+R".action.switch-preset-column-width = [];
    "Mod+Shift+R".action.switch-preset-column-width-back = [];
    "Mod+Ctrl+Shift+R".action.switch-preset-window-height = [];
    "Mod+Ctrl+R".action.reset-window-height = [];

    # Fullscreen / maximize
    "Mod+G".action.maximize-column = [];
    "Mod+F".action.toggle-window-floating = [];
    "Mod+Shift+F".action.fullscreen-window = [];
    "Mod+M".action.toggle-windowed-fullscreen = [];
    "Mod+Ctrl+F".action.expand-column-to-available-width = [];

    # Center column
    "Mod+C".action.center-column = [];
    "Mod+Ctrl+C".action.center-visible-columns = [];

    # Width/height adjustment
    "Mod+Minus".action.set-column-width = "-10%";
    "Mod+Equal".action.set-column-width = "+10%";
    "Mod+Shift+Minus".action.set-window-height = "-10%";
    "Mod+Shift+Equal".action.set-window-height = "+10%";

    # Floating
    "Mod+V".action.toggle-window-floating = [];
    "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [];

    # Tabbed display
    "Mod+W".action.toggle-column-tabbed-display = [];

    # Screenshots
    "Print".action.screenshot = [];
    "Ctrl+Print".action.screenshot-screen = [];
    "Alt+Print".action.screenshot-window = [];

    # Quit
    "Mod+Shift+E".action.quit = [];
    "Ctrl+Alt+Delete".action.quit = [];

    # Power off monitors
    "Mod+Shift+P".action.power-off-monitors = [];

    # Keyboard shortcuts inhibit toggle (escape hatch)
    "Mod+Escape" = {
      action.toggle-keyboard-shortcuts-inhibit = [];
      allow-inhibiting = false;
    };

    # Volume keys
    "XF86AudioRaiseVolume" = {
      action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" "-l" "1.0"];
      allow-when-locked = true;
    };
    "XF86AudioLowerVolume" = {
      action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
      allow-when-locked = true;
    };
    "XF86AudioMute" = {
      action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
      allow-when-locked = true;
    };
    "XF86AudioMicMute" = {
      action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
      allow-when-locked = true;
    };

    # Media keys
    "XF86AudioPlay" = {
      action.spawn = ["playerctl" "play-pause"];
      allow-when-locked = true;
    };
    "XF86AudioPause" = {
      action.spawn = ["playerctl" "play-pause"];
      allow-when-locked = true;
    };
    "XF86AudioStop" = {
      action.spawn = ["playerctl" "stop"];
      allow-when-locked = true;
    };
    "XF86AudioPrev" = {
      action.spawn = ["playerctl" "previous"];
      allow-when-locked = true;
    };
    "XF86AudioNext" = {
      action.spawn = ["playerctl" "next"];
      allow-when-locked = true;
    };

    # Brightness keys
    "XF86MonBrightnessUp" = {
      action.spawn = ["brightnessctl" "--class=backlight" "set" "+10%"];
      allow-when-locked = true;
    };
    "XF86MonBrightnessDown" = {
      action.spawn = ["brightnessctl" "--class=backlight" "set" "10%-"];
      allow-when-locked = true;
    };
  };
}
