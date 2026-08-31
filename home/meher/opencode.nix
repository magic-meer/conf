{ osConfig, ... }: {
  stylix.targets.opencode.enable = false;

  programs.opencode = {
    enable = true;

    tui = {
      theme = "system";
    };

    settings.server = {
      port = 8384;
      hostname = "0.0.0.0";
    };

    web = {
      enable = true;
      environmentFile = osConfig.age.secrets.opencode-server-pass.path;
    };
  };
}