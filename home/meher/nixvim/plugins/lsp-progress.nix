{ ... }: {
  # LSP loading progress indicator (kept over lsp-status — they collide)
  programs.nixvim.plugins.lsp-progress = {
    enable = true;
    settings.decay = 1200;
  };
}