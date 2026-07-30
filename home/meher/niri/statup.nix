{
  ...
}: {
  programs.niri.settings = {
    spawn-at-startup = [
     { command = "waybar" }
    ];
  };
}
