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
    ./swaylock.nix
    ./waybar
    ./swaync
    ./tlauncher
    ./quickshell
  ];

  home = {
    # username = userName;
    username = "meher";
    homeDirectory = "/home/meher";

    # Don't change this after the initial install unless you know why.
    stateVersion = "26.05";

    sessionVariables = {
      TERMINAL = "kitty";
      BROWSER = "zen";
      FILE_MANAGER = "superfile";
      DISPLAY = ":0";
    };

    sessionPath = [ "$HOME/.local/bin" ];
  };

  programs.home-manager.enable = true;
}
