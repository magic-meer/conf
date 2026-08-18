{
   inputs,
  pkgs,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
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
      nautilus
      inputs.agenix.packages.${pkgs.system}.default
  ];

  programs.fish.enable = true;
  programs.niri.enable = true;

  # for the waybar power profile module
  services.power-profiles-daemon.enable = true;
}
