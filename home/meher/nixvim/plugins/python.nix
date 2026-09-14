{
  # === Python IDE tooling ===
  # Format with ruff (needs pkgs.ruff in home/meher/packages.nix).
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        python = [ "ruff_format" ];
      };
      # Format on save; non-python buffers fall back to the LSP formatter.
      format_on_save = {
        timeout_ms = 1000;
        lsp_format = "fallback";
      };
    };
  };

  # Lint with ruff on save.
  plugins.lint = {
    enable = true;
    lintersByFt = {
      python = [ "ruff" ];
    };
  };

  # Debugging: debugpy is bundled by nixvim (adapterPythonPath default).
  # resolvePython honours VIRTUAL_ENV/CONDA_PREFIX, so an activated venv is
  # used for launch/test sessions automatically.
  plugins.dap = {
    enable = true;
  };

  plugins.dap-python = {
    enable = true;
    testRunner = "pytest";
  };

  # Manual virtualenv picker (`:VenvSelect`). basedpyright auto-detects .venv
  # already; this lets you switch environments and syncs the LSP clients.
  plugins.venv-selector = {
    enable = true;
  };
}
