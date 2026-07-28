{...}: {

  system.stateVersion = "26.05"; ## leave this alone

  imports = [
    ./boot.nix
    ./hardware_configuration.nix
    ./locale.nix
    ./networking.nix
    ./packages.nix
    ./users.nix
  ];

  #Enabling flakes and nix command
  nix.settings.experimental-features = [
	"nix-command"
	"flakes"
  ];
}
