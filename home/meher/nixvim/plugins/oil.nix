{ ... }: {
  # ALTERNATIVE for nvim-file-operations (move/copy/rename/delete files)
  programs.nixvim.plugins.oil = {
    enable = true;
    settings.skip_confirm_for_simple_edits = true;
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>o";
      action = "<cmd>Oil<CR>";
      options.desc = "Oil: file manager";
    }
  ];
}
