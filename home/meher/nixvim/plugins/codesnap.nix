{ ... }: {
  # ALTERNATIVE for code-shot.nvim (pretty code screenshots)
  programs.nixvim.plugins.codesnap = {
    enable = true;
    settings.save_path = "~/Pictures/Screenshots/";
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>sc";
      action = "<cmd>CodeSnap<CR>";
      options.desc = "CodeSnap: screenshot";
    }
  ];
}
