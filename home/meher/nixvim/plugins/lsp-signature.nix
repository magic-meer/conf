{ ... }: {
  # Shows function signatures in a floating window while typing
  programs.nixvim.plugins.lsp-signature = {
    enable = true;
    settings = {
      handler_opts.border = "rounded";
      hint_enable = true;
    };
  };
}
