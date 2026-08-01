{ ... }: {
  # ALTERNATIVE for nvim-luaclip.lua (clipboard history)
  programs.nixvim.plugins.neoclip.enable = true;
  programs.nixvim.plugins.telescope.enabledExtensions = [ "neoclip" ];

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>fc";
      action.__raw = "function() require('telescope').extensions.neoclip.default() end";
      options.desc = "Clipboard history";
    }
  ];
}
