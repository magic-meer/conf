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
    ./window-rules.nix
  ];

  # programs.niri = {
  #   enable = true;
  # };
}
