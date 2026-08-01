{ ... }: {
  # Pretty diagnostics / references / quickfix list
  programs.nixvim.plugins.trouble = {
    enable = true;
    settings.auto_close = true;
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options.desc = "Trouble: diagnostics";
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>Trouble quickfix toggle<CR>";
      options.desc = "Trouble: quickfix";
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>Trouble loclist toggle<CR>";
      options.desc = "Trouble: location list";
    }
    {
      mode = "n";
      key = "<leader>xr";
      action = "<cmd>Trouble lsp_references toggle<CR>";
      options.desc = "Trouble: LSP references";
    }
  ];
}
