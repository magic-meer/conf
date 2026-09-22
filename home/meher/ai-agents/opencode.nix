{ osConfig, inputs, ... }: {
  stylix.targets.opencode.enable = false;

  programs.opencode = {
    enable = true;

    tui = {
      theme = "system";
    };

    settings = {
      server = {
        port = osConfig.services.opencode.port;
        hostname = "0.0.0.0";
      };
      plugin = [
        "${inputs.superpowers}/.opencode/plugins/superpowers.js"
        "${inputs.ponytail}/.opencode/plugins/ponytail.mjs"
      ];
      skills = {
        paths = [ "${inputs.impeccable}/.opencode/skills" "${inputs.linkedin-agent}/skills" ];
      };
    };

    web = {
      enable = true;
      environmentFile = osConfig.age.secrets.opencode-server-pass.path;
    };
  };
}
