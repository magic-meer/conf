{
  ...
}: {
  programs.zed-editor = {
    enable = true;
    extensions = ["nix"];
    userSettings = {
      theme = {
        mode = "dark";
        dark = "Gruvbox Dark";
        light = "Gruvbox Light";
      };
      hour_format = "hour24";
      vim_mode = true;
    };
  };
}
