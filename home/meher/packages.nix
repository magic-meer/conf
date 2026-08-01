{
   pkgs,
   ...
}: {
home.packages = with pkgs; [
       fuzzel
       waybar
       overskride
       zed-editor
       opencode
       awww
       swaynotificationcenter
       brightnessctl
       power-profiles-daemon
    ];
}
