{ ... }: {
  # ALTERNATIVE for undo-glow.nvim (visual undo history)
  programs.nixvim.plugins.undotree.enable = true;

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>u";
      action = "<cmd>UndotreeToggle<CR>";
      options.desc = "Undo tree";
    }
  ];
}
