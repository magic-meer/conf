{ osConfig, pkgs, ... }: {
  # Hermes CLI on PATH + HERMES_HOME for your shell
  programs.hermes-agent = {
    enable = true;
  };

  services.hermes-agent = {
    enable = true;

    # Register providers (current format; not the legacy custom_providers key)
    settings = {
      providers = {
        groq = {
          api = "https://api.groq.com/openai/v1";
          key_env = "GROQ_API_KEY";
        };
        nvidia = {
          api = "https://integrate.api.nvidia.com/v1";
          key_env = "NVIDIA_API_KEY";
        };
        openrouter = {
          api = "https://openrouter.ai/api/v1";
          key_env = "OPENROUTER_API_KEY";
        };
      };

      # Approvals / Permissions
      approvals = {
        mode = "manual"; # "manual" prompts on dangerous actions; "smart" uses guardian LLM; "off" auto-approves
        timeout = 300;
      };

      # Toolsets
      platform_toolsets = {
        cli = [ "hermes-cli" ];
      };
    };

    # Export SHELL for subprocesses
    environment = {
      SHELL = "${pkgs.fish}/bin/fish";
    };

    # Secrets -> ~/.hermes/.env (from agenix, not globalized)
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
      fish
      git
      ripgrep
      fd
      jq
      curl
    ];
  };
}
