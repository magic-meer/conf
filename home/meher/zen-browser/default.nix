{ pkgs, ... }: {
  imports = [
    ./policies.nix
    ./profiles.nix
    ./bookmarks.nix
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    nativeMessagingHosts = [ pkgs.keepassxc ];
  };
}