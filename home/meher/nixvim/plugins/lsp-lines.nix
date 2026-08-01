{ ... }: {
  # Renders diagnostics as virtual lines under the code instead of virtual text.
  # Also disables vim.diagnostic virtual_text to avoid duplication.
  programs.nixvim.plugins.lsp-lines.enable = true;
}
