{...}: {system.stateVersion = "26.05";

  system.stateVersion = "26.05"; ## leave this alone

  imports = [
    ./boot.nix
    ./hardware_configuration.nix
    ./locale.nix
    ./networking.nix
    ./packages.nix
    ./users.nix
  ];
}
