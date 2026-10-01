{lib, pkgs, ...}: let
   opencode-port = 4096;
 in {
   imports = [
    ./boot.nix
    ./docker.nix
    ./fonts.nix
    ./hardware_configuration.nix
    ./kanata.nix
    ./keyboard-rgb.nix
    ./locale.nix
    ./networking.nix
    ./packages.nix
    ./users.nix
    # ./windscribe.nix
    ./openssh.nix
    ./syncthing.nix
    ./stylix.nix
  ];

  options.services.opencode.port = lib.mkOption {
    type = lib.types.port;
    default = opencode-port;
    description = "OpenCode web server port";
  };

  config = {
    services.opencode.port = opencode-port;

    system.stateVersion = "26.05"; ## leave this alone

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
        hermes-env = {
          file = ../../secrets/hermes-env.age;
          owner = "meher";
          group = "users";
          mode = "0400";
        };
        hermes-dashboard-token = {
          file = ../../secrets/hermes-dashboard-token.age;
          owner = "meher";
          group = "users";
          mode = "0400";
        };
      };
    };

    # KVM for Android Emulator acceleration
    boot.kernelModules = [ "kvm-amd" ];

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

    # Allow generic dynamically linked binaries (Android SDK tools, Gradle/AGP
    # aapt2, the Kotlin Toolchain's JetBrains Runtime, ...) to run outside the
    # store (stub-ld). The X11/graphics/font libs are what a downloaded JBR's
    # AWT + Skia need on NixOS.
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      libX11
      libXext
      libXrender
      libXtst
      libXi
      libXcursor
      libXinerama
      libXrandr
      freetype
      fontconfig
      glib
      libGL
      ncurses
    ];
  };
}
