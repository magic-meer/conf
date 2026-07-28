{
  pkgs,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    neovim
    git
    tree
    bat
    fastfetch
    btop
    chromium
    tmux
    usbutils
    pciutils
    lm_sensors
    file
    psmisc
  ];

  programs.fish.enable = true;
}
