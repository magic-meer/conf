{
  ...
}: {
  programs.niri.settings.spawn-at-startup = [
    { argv = ["bash" "-c" "while true; do /etc/profiles/per-user/meher/bin/quickshell -c shell; sleep 2; done"]; }
    { argv = ["swaync"]; }
    { argv = ["awww-daemon"]; }
    { argv = ["bash" "-c" "for i in $(seq 10); do awww img ../assets/wallpaper.jpg 2>/dev/null && break; sleep 0.5; done"]; }
  ];
}
