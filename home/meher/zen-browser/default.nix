{ pkgs, ... }: {
  imports = [
    ./policies.nix
    ./profiles.nix
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    nativeMessagingHosts = [ pkgs.keepassxc ];
  };
}