{ ... }: {
  plugins.opencode = {
    enable = true;

    settings = {
      # Connect to the existing opencode web/TUI server on 4096
      # (started by `programs.opencode.web` in home/meher/opencode.nix).
      server = {
        connect = true;
        url = "http://localhost:4096";
        # Username/password as configured on the server (see
        # `programs.opencode.web`; the env file is the age secret below).
        # The server-side credentials are `meher`/soka — keep username in sync.
        username = "meher";
        # The password is NOT set here (avoid the secret landing in the nix
        # store); it comes from the OPENCODE_SERVER_PASSWORD env var which is
        # populated at startup from the age secret (see extraConfigLua below).
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
  # the nix store or the source. The secret file is a set of `KEY=value` lines.
  extraConfigLuaPre = ''
    local pass_file = "/run/agenix/opencode-server-pass"
    if vim.fn.filereadable(pass_file) == 1 then
      for line in io.lines(pass_file) do
        local k, v = line:match("^([%w_]+)=(.*)$")
        if k == "OPENCODE_SERVER_PASSWORD" and not vim.env.OPENCODE_SERVER_PASSWORD then
          vim.env.OPENCODE_SERVER_PASSWORD = v
        end
        if k == "OPENCODE_SERVER_USERNAME" and not vim.env.OPENCODE_SERVER_USERNAME then
          vim.env.OPENCODE_SERVER_USERNAME = v
        end
      end
    end
  '';
}
