{
  ...
}:
{
  imports = [
    ./packages.nix
    ./git.nix
    ./fish.nix
    ./zed.nix
    ./zen-browser.nix
    ./shell.nix
    ./nixvim
    ./niri
    ./kitty
    ./fuzzel.nix
    ./gtk.nix
    ./waybar
    ./swaync
  ];

  home = {
    # username = userName;
    username = "meher";
    homeDirectory = "/home/meher";

    # Don't change this after the initial install unless you know why.
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
