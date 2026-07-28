{
  userName,
  ...
}: {
  imports = [
    ./packages.nix
    ./git.nix
    ./fish.nix
    ./zed.nix
  ];

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";

    # Don't change this after the initial install unless you know why.
    stateVersion = "26.05";
  }

  programs.home-manager.enable = true;
}
