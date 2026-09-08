{ osConfig, ... }: {
  stylix.targets.opencode.enable = false;

  programs.opencode = {
    enable = true;

    tui = {
      theme = "system";
    };

    settings.server = {
      port = osConfig.services.opencode.port;
      hostname = "0.0.0.0";
    };

    web = {
      enable = true;
      environmentFile = osConfig.age.secrets.opencode-server-pass.path;
    };
  };
}
