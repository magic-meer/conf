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
    ./window-rules.nix
    ./xwayland.nix
  ];

  # programs.niri = {
  #   enable = true;
  # };
}
