{
  ...
}: {
  programs.niri.settings.spawn-at-startup = [
    { argv = ["quickshell" "-c" "shell"]; }
    { argv = ["swaync"]; }
    { argv = ["awww-daemon"]; }
    { argv = ["bash" "-c" "for i in $(seq 10); do awww img ../assets/wallpaper.jpg 2>/dev/null && break; sleep 0.5; done"]; }
  ];
}
