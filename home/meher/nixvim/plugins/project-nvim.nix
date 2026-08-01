{ ... }: {
  # DrKJeff16/project.nvim — project management with telescope integration
  programs.nixvim.plugins.project-nvim = {
    enable = true;
    enableTelescope = true;
    settings.patterns = [ ".git" ];
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>fp";
      action = "<cmd>Telescope projects<CR>";
      options.desc = "Find projects";
    }
  ];
}
