{ ... }: {
  # ALTERNATIVE for grapple (quickly jump to marked files)
  programs.nixvim.plugins.harpoon.enable = true;

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<C-e>";
      action.__raw = "function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end";
      options.desc = "Harpoon: quick menu";
    }
    {
      mode = "n";
      key = "<leader>ha";
      action.__raw = "function() require('harpoon'):list():add() end";
      options.desc = "Harpoon: add file";
    }
  ];
}
