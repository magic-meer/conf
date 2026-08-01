{ ... }: {
  # ALTERNATIVE for fzf-lsp (LSP symbols through fzf instead of telescope)
  # telescope keeps <leader>ff/fg/fb/fh; fzf-lua takes the LSP pickers
  # border colors come from the colorscheme's FloatBorder/FzfLuaBorder highlights
  programs.nixvim.plugins.fzf-lua = {
    enable = true;
    settings.winopts.border = "rounded";
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>fd";
      action = "<cmd>FzfLua lsp_definitions<CR>";
      options.desc = "fzf: definitions";
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = "<cmd>FzfLua lsp_references<CR>";
      options.desc = "fzf: references";
    }
    {
      mode = "n";
      key = "<leader>fs";
      action = "<cmd>FzfLua lsp_document_symbols<CR>";
      options.desc = "fzf: document symbols";
    }
    {
      mode = "n";
      key = "<leader>fw";
      action = "<cmd>FzfLua lsp_workspace_symbols<CR>";
      options.desc = "fzf: workspace symbols";
    }
  ];
}
