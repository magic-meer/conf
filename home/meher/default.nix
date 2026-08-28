{ inputs, pkgs, ... }: {
imports = [
    # inputs.nixvim.homeModules.nixvim  # Temporarily disabled due to keymaps format issue
    inputs.agenix.homeManagerModules.default
    inputs.zen-browser.homeModules.beta

    ./packages.nix
    ./git.nix
    ./fish.nix
    ./zed.nix
    ./zen-browser
    ./shell.nix
    # ./nixvim
    ./niri
    # ./kitty
    ./fuzzel.nix
    # ./gtk.nix
    ./swaylock.nix
    ./waybar
    ./swaync
    ./tlauncher
    ./quickshell
    ./stylix.nix
    ./ghostty.nix
    ./starship.nix
  ];

  programs.keepassxc = {
    enable = true;
    package = pkgs.keepassxc;
    settings = {
      Browser = {
        Enabled = true;
        UpdateBinaryPath = false;
      };
    };
  };

  age = {
    identityPaths = [ "~/.ssh/id_ed25519" ];
  };

  home = {
    # username = userName;
    username = "meher";
    homeDirectory = "/home/meher";

    # Don't change this after the initial install unless you know why.
    stateVersion = "26.05";

    sessionVariables = {
      TERMINAL = "ghostty";
      BROWSER = "zen-beta";
      FILE_MANAGER = "superfile";
      DISPLAY = ":0";

      # Qt transparency and theming
      QT_QPA_PLATFORMTHEME = "gnome";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    };

    sessionPath = [ "$HOME/.local/bin" ];
  };

  programs.home-manager.enable = true;
}