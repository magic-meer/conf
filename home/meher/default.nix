{
  inputs,
  ...
}:
{
  imports = [
  	inputs.nixvim.homeModules.nixvim
    inputs.agenix.homeManagerModules.default
      inputs.zen-browser.homeModules.beta

    ./packages.nix
    ./git.nix
    ./fish.nix
    ./zed.nix
    ./zen-browser
    ./shell.nix
    ./nixvim
    ./niri
    # ./kitty
    ./fuzzel.nix
    # ./gtk.nix
    ./swaylock.nix
    ./waybar
    ./swaync
    ./tlauncher
    ./quickshell
      # ./stylix.nix
      ./ghostty.nix
      ./starship.nix
  ];

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
    };

    sessionPath = [ "$HOME/.local/bin" ];
  };

  programs.home-manager.enable = true;
}
