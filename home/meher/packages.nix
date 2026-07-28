{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rofi
    waybar
    kitty
    pkgs.overskride
    pkgs.zed-editor

    #nix development tools
    nil nixd
  ];
}
