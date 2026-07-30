{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rofi
    waybar
    kitty
    overskride
    zed-editor
    opencode
  ];
}
