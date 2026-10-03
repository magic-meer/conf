{
  ...
}: {
  programs.niri.settings.spawn-at-startup = [
    # Qt theming is pinned off for the shell: no platform theme (which would
    # hand the window's look to GTK/adwaita/gnome) and Fusion as the base
    # style, which is compiled into qtbase so there is no plugin to load.
    # The shell's own colours come from Settings.qml.
    { argv = ["bash" "-c" "unset QT_QPA_PLATFORMTHEME; export QT_STYLE_OVERRIDE=Fusion; while true; do /etc/profiles/per-user/meher/bin/quickshell -c shell; sleep 2; done"]; }
    { argv = ["swaync"]; }
    { argv = ["awww-daemon"]; }
    { argv = ["bash" "-c" "for i in $(seq 10); do awww img ../assets/wallpaper.jpg 2>/dev/null && break; sleep 0.5; done"]; }
  ];
}
