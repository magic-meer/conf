{ lib, ... }: {
  programs.opencode = {
    enable = true;
    tui = {
      theme = lib.mkForce "system";
    };
  };
}