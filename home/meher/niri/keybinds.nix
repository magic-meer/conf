{
  ...
}: {
  programs.niri.settings.binds = {
    # Hotkey overlay
    "Mod+Shift+Slash".action.show-hotkey-overlay = null;

    # Launcher
    "Mod+D".action.spawn = "fuzzel";

    # Terminal
    "Mod+T".action.spawn = "foot";

    # Lock screen
    "Super+Alt+L" = {
      action.spawn = "swaylock";
      allow-when-locked = true;
    };

    # Overview
    "Mod+O" = {
      action.toggle-overview = null;
      repeat = false;
    };

    # Close window
    "Mod+Q" = {
      action.close-window = null;
      repeat = false;
    };

    # Window focus
    "Mod+Left".action.focus-column-left = null;
    "Mod+Down".action.focus-window-down = null;
    "Mod+Up".action.focus-window-up = null;
    "Mod+Right".action.focus-column-right = null;
    "Mod+H".action.focus-column-left = null;
    "Mod+J".action.focus-window-down = null;
    "Mod+K".action.focus-window-up = null;
    "Mod+L".action.focus-column-right = null;

    # Move windows
    "Mod+Ctrl+Left".action.move-column-left = null;
    "Mod+Ctrl+Down".action.move-window-down = null;
    "Mod+Ctrl+Up".action.move-window-up = null;
    "Mod+Ctrl+Right".action.move-column-right = null;
    "Mod+Ctrl+H".action.move-column-left = null;
    "Mod+Ctrl+J".action.move-window-down = null;
    "Mod+Ctrl+K".action.move-window-up = null;
    "Mod+Ctrl+L".action.move-column-right = null;

    # Column first/last
    "Mod+Home".action.focus-column-first = null;
    "Mod+End".action.focus-column-last = null;
    "Mod+Ctrl+Home".action.move-column-to-first = null;
    "Mod+Ctrl+End".action.move-column-to-last = null;

    # Monitor focus
    "Mod+Shift+Left".action.focus-monitor-left = null;
    "Mod+Shift+Down".action.focus-monitor-down = null;
    "Mod+Shift+Up".action.focus-monitor-up = null;
    "Mod+Shift+Right".action.focus-monitor-right = null;
    "Mod+Shift+H".action.focus-monitor-left = null;
    "Mod+Shift+J".action.focus-monitor-down = null;
    "Mod+Shift+K".action.focus-monitor-up = null;
    "Mod+Shift+L".action.focus-monitor-right = null;

    # Move column to monitor
    "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = null;
    "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = null;
    "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = null;
    "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = null;
    "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = null;
    "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = null;
    "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = null;
    "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = null;

    # Workspace navigation (previous/next)
    "Mod+Page_Down".action.focus-workspace-down = null;
    "Mod+Page_Up".action.focus-workspace-up = null;
    "Mod+U".action.focus-workspace-down = null;
    "Mod+I".action.focus-workspace-up = null;
    "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = null;
    "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = null;
    "Mod+Ctrl+U".action.move-column-to-workspace-down = null;
    "Mod+Ctrl+I".action.move-column-to-workspace-up = null;

    # Move workspace between monitors
    "Mod+Shift+Page_Down".action.move-workspace-down = null;
    "Mod+Shift+Page_Up".action.move-workspace-up = null;
    "Mod+Shift+U".action.move-workspace-down = null;
    "Mod+Shift+I".action.move-workspace-up = null;

    # Scroll wheel workspace switching
    "Mod+WheelScrollDown" = {
      action.focus-workspace-down = null;
      cooldown-ms = 150;
    };
    "Mod+WheelScrollUp" = {
      action.focus-workspace-up = null;
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollDown" = {
      action.move-column-to-workspace-down = null;
      cooldown-ms = 150;
    };
    "Mod+Ctrl+WheelScrollUp" = {
      action.move-column-to-workspace-up = null;
      cooldown-ms = 150;
    };

    "Mod+WheelScrollRight".action.focus-column-right = null;
    "Mod+WheelScrollLeft".action.focus-column-left = null;
    "Mod+Ctrl+WheelScrollRight".action.move-column-right = null;
    "Mod+Ctrl+WheelScrollLeft".action.move-column-left = null;

    "Mod+Shift+WheelScrollDown".action.focus-column-right = null;
    "Mod+Shift+WheelScrollUp".action.focus-column-left = null;
    "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = null;
    "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = null;

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
    "Mod+BracketLeft".action.consume-or-expel-window-left = null;
    "Mod+BracketRight".action.consume-or-expel-window-right = null;
    "Mod+Comma".action.consume-window-into-column = null;
    "Mod+Period".action.expel-window-from-column = null;

    # Column width presets
    "Mod+R".action.switch-preset-column-width = null;
    "Mod+Shift+R".action.switch-preset-column-width-back = null;
    "Mod+Ctrl+Shift+R".action.switch-preset-window-height = null;
    "Mod+Ctrl+R".action.reset-window-height = null;

    # Fullscreen / maximize
    "Mod+F".action.maximize-column = null;
    "Mod+Shift+F".action.fullscreen-window = null;
    "Mod+M".action.maximize-window-to-edges = null;
    "Mod+Ctrl+F".action.expand-column-to-available-width = null;

    # Center column
    "Mod+C".action.center-column = null;
    "Mod+Ctrl+C".action.center-visible-columns = null;

    # Width/height adjustment
    "Mod+Minus".action.set-column-width = "-10%";
    "Mod+Equal".action.set-column-width = "+10%";
    "Mod+Shift+Minus".action.set-window-height = "-10%";
    "Mod+Shift+Equal".action.set-window-height = "+10%";

    # Floating
    "Mod+V".action.toggle-window-floating = null;
    "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = null;

    # Tabbed display
    "Mod+W".action.toggle-column-tabbed-display = null;

    # Screenshots
    "Print".action.screenshot = null;
    "Ctrl+Print".action.screenshot-screen = null;
    "Alt+Print".action.screenshot-window = null;

    # Quit
    "Mod+Shift+E".action.quit = null;
    "Ctrl+Alt+Delete".action.quit = null;

    # Power off monitors
    "Mod+Shift+P".action.power-off-monitors = null;

    # Keyboard shortcuts inhibit toggle (escape hatch)
    "Mod+Escape" = {
      action.toggle-keyboard-shortcuts-inhibit = null;
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
