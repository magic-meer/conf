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
      ./openssh.nix
      ./syncthing.nix
      ./stylix.nix
  ];

   #secrets
   age = {
      identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      secrets = {
            meher-default-pass.file = ../../secrets/meher-default-pass.age;
            syncthing-pass = {
               file = ../../secrets/syncthing-pass.age;
               owner = "meher";
               group = "users";
               mode = "0400";
            };
            opencode-server-pass = {
               file = ../../secrets/opencode-server-pass.age;
               owner = "meher";
               group = "users";
               mode = "0400";
            };
         };
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
