{
  inputs,
  ...
}: {
  
  imports = [
    inputs.niri.homeModules.config

    ./layout.nix
    ./appearance.nix
    ./keybinds.nix
    ./statup.nix
  ];

  # programs.niri = {
  #   enable = true;
  # };
}
