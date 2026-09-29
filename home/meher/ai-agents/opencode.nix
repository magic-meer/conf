{ osConfig, pkgs, ... }: {
  stylix.targets.opencode.enable = false;

  programs.opencode = {
    enable = true;

    # Wrap opencode CLI so it inherits agenix secrets without globalizing them to your shell
    package = pkgs.writeShellScriptBin "opencode" ''
      if [ -f "${osConfig.age.secrets.opencode-server-pass.path}" ]; then
        set -a
        . "${osConfig.age.secrets.opencode-server-pass.path}"
        set +a
      fi
      exec ${pkgs.opencode}/bin/opencode "$@"
    '';

    tui = {
      theme = "system";
    };

    settings = {
      server = {
        port = osConfig.services.opencode.port;
        hostname = "0.0.0.0";
      };

      # Use Fish shell for terminal and bash tool execution
      shell = "${pkgs.fish}/bin/fish";

      # Permissions configuration
      permission = {
        read = "allow";
        grep = "allow";
        glob = "allow";
        list = "allow";
        edit = "allow";
        bash = "allow";
        task = "allow";
        external_directory = "ask";
      };

      # Built-in Tools
      tools = {
        bash = true;
        edit = true;
        read = true;
        glob = true;
        grep = true;
        list = true;
        webfetch = true;
        websearch = true;
      };
    };

    extraPackages = with pkgs; [
      fish
      git
      ripgrep
      fd
      jq
      curl
    ];

    web = {
      enable = true;
      environmentFile = osConfig.age.secrets.opencode-server-pass.path;
    };
  };
}
