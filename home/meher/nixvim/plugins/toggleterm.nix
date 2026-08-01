{ ... }: {
  # ALTERNATIVE for nvim-luxterm (floating terminal)
  programs.nixvim.plugins.toggleterm.enable = true;

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>t";
      action = "<cmd>ToggleTerm<CR>";
      options.desc = "Toggle terminal";
    }
  ];
}
