{ ... }: {
  programs.nixvim = {
    # Python IDE — LSP: pyright for typing/intelligence, ruff for linting + formatting
    lsp.servers = {
      pyright = {
        enable = true;
        config.python.analysis = {
          typeCheckingMode = "basic";
          autoImportCompletions = true;
          autoSearchPaths = true;
          useLibraryCodeForTypes = true;
          inlayHints = {
            functionReturnTypes = true;
            parameterNames = "none";
            variableTypes = false;
          };
        };
      };
      ruff = {
        enable = true;
        config = {
          format.preview = true;
          lint.preview = true;
        };
      };
    };

    # Format on save through the LSP (restricted to ruff so nixd formatting stays manual)
    plugins.lsp-format = {
      enable = true;
      lspServersToEnable = [ "ruff" ];
      settings.python = {
        order = [ "ruff" ];
        sync = true;
      };
    };
    globals.lsp_format_filetype_map = { python = "ruff"; };
  };
}
