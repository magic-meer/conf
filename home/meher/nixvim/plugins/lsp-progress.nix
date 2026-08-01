{ ... }: {
  # LSP loading progress indicator (kept over lsp-status — they collide)
  programs.nixvim.plugins.lsp-progress = {
    enable = true;
    settings.decay = 1200;
  };

  # Show LSP progress in the statusline
  programs.nixvim.plugins.lualine.settings.sections.lualine_c = [
    "lsp_progress"
    "filename"
  ];
}
