{inputs, ...}: {
  imports = [
    ./boot.nix
    ./hardware_configuration.nix
    ./locale.nix
    ./networking.nix
    ./pakcages.nix
    ./users.nix
  ];
}
