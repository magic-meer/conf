{...}: {

  system.stateVersion = "26.05"; ## leave this alone

  imports = [
    ./boot.nix
    ./fonts.nix
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

  # Auto-cleanup old generations after 15 days
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };
}
