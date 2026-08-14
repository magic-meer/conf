{...}: {

  system.stateVersion = "26.05"; ## leave this alone

  imports = [
    ./boot.nix
    ./docker.nix
    ./fonts.nix
    ./hardware_configuration.nix
    ./kanata.nix
    ./locale.nix
    ./networking.nix
    ./packages.nix
    ./users.nix
    ./windscribe.nix
  ];

   #secrets
   age.secrets = {
      meher-default-pass.file = ../../secrets/meher-default-pass.age;
   };

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
