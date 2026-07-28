{inputs, ...}: {
  imports = [
    ./boot.nix
    ./hardware_configuration.nix
    ./locale.nix
    ./networking.nix
    ./packages.nix
    ./users.nix
  ];
}
