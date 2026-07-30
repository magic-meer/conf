{
   pkgs,
   ...
}: {
   home.packages = with pkgs; [
      fuzzel
      waybar
      foot
      overskride
      zed-editor
      opencode
   ];
}
