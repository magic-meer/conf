{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    rofi
    waybar
    kitty
    pkgs.overskride
    pkgs.zed-editor
    nixd
  ];
}
