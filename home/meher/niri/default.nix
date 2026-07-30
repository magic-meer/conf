{
  inputs,
  ...
}: {
  
  imports = [
    inputs.niri.homeModules.config

    ./layout.nix
    ./appearance.nix
    ./keybinds.nix
    ./startup.nix
  ];

  programs.niri = {
    enable = true;
  };
}
