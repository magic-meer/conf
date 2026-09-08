{ osConfig, pkgs, ... }: {
  # Hermes CLI on PATH + HERMES_HOME for your shell
  programs.hermes-agent = {
    enable = true;
  };

  services.hermes-agent = {
    enable = true;

    # Provider + model (swap model freely here)
    settings.model = {
      base_url = "https://openrouter.ai/api/v1";
      default = "deepseek/deepseek-chat-v3-0324:free";
    };

    # Secrets -> ~/.hermes/.env (from agenix)
    environmentFiles = [
      osConfig.age.secrets.hermes-env.path
    ];

    # Web dashboard, reachable from LAN, with auth
    backend = {
      mode = "dashboard";
      host = "0.0.0.0";
      port = 9119;
      sessionTokenFile = osConfig.age.secrets.hermes-dashboard-token.path;
    };

    # Minimal toolset for the agent
    extraPackages = with pkgs; [
      git
      ripgrep
      fd
      jq
      curl
    ];
  };
}