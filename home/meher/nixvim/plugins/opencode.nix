{ ... }: {
  plugins.opencode = {
    enable = true;

    settings = {
      # Connect to the existing opencode web/TUI server on 4096
      # (started by `programs.opencode.web` in home/meher/opencode.nix).
      server = {
        connect = true;
        url = "http://localhost:4096";
        # Username defaults to "opencode"; keep it explicit.
        username = "opencode";
        # The password comes from the OPENCODE_SERVER_PASSWORD env var, which
        # is populated at startup from the age secret (see extraConfigLua below).
      };

      # Enhanced prompt input via snacks.input (better completion/highlight).
      ask = {
        prompt = "Ask OpenCode: ";
      };

      # Built-in prompt templates + commands/servers available via select().
      select = {
        prompt = "OpenCode: ";
      };

      # Reload edited buffers, surface session events, and (mostly) approve/deny
      # permission + edit requests interactively.
      events = {
        enabled = true;
        reload = {
          enabled = true;
        };
        permissions = {
          enabled = true;
          edits = {
            enabled = true;
          };
        };
      };
    };
  };

  # opencode.nvim (nickjvandyke v1.x) reads the server password from the
  # OPENCODE_SERVER_PASSWORD env var at config-load time. Read the age-decrypted
  # secret here (before any `require("opencode")`) so the secret never lands in
  # the nix store or the source.
  extraConfigLuaPre = ''
    local pass_file = "/run/agenix/opencode-server-pass"
    if not vim.env.OPENCODE_SERVER_PASSWORD and vim.fn.filereadable(pass_file) == 1 then
      local f = assert(io.open(pass_file, "r"))
      vim.env.OPENCODE_SERVER_PASSWORD = vim.fn.trim(f:read("*a"))
      f:close()
    end
  '';
}
