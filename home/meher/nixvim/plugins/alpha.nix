{
  programs.nixvim.plugins.alpha = {
    enable = true;

    settings.layout = [
      {
        type = "padding";
        val = 3;
      }
      {
        type = "text";
        val = [
          "   󰊠   "
        ];
        opts = {
          position = "center";
          hl = "Type";
        };
      }
      {
        type = "padding";
        val = 1;
      }
      {
        type = "group";
        val = [
          {
            type = "button";
            val = "  󰈞  Find File";
            on_press.__raw = "function() vim.cmd [[Telescope find_files]] end";
            opts = {
              shortcut = "f";
              keymap = [
                "n"
                "f"
                ":Telescope find_files<CR>"
                { nowait = true; }
              ];
              position = "center";
              hl = "Keyword";
              hl_shortcut = "Type";
              width = 40;
              align_shortcut = "right";
              padding = { right = 2; };
            };
          }
          {
            type = "button";
            val = "  󰃢  Recent Files";
            on_press.__raw = "function() vim.cmd [[Telescope oldfiles]] end";
            opts = {
              shortcut = "r";
              keymap = [
                "n"
                "r"
                ":Telescope oldfiles<CR>"
                { nowait = true; }
              ];
              position = "center";
              hl = "Keyword";
              hl_shortcut = "Type";
              width = 40;
              align_shortcut = "right";
              padding = { right = 2; };
            };
          }
          {
            type = "button";
            val = "  󰦨  New File";
            on_press.__raw = "function() vim.cmd [[enew]] end";
            opts = {
              shortcut = "n";
              keymap = [
                "n"
                "n"
                ":enew<CR>"
                { nowait = true; }
              ];
              position = "center";
              hl = "Keyword";
              hl_shortcut = "Type";
              width = 40;
              align_shortcut = "right";
              padding = { right = 2; };
            };
          }
          {
            type = "button";
            val = "  󰈙  Quit";
            on_press.__raw = "function() vim.cmd [[qa]] end";
            opts = {
              shortcut = "q";
              keymap = [
                "n"
                "q"
                ":qa<CR>"
                { nowait = true; }
              ];
              position = "center";
              hl = "Keyword";
              hl_shortcut = "Type";
              width = 40;
              align_shortcut = "right";
              padding = { right = 2; };
            };
          }
        ];
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "text";
        val = "vim is my home";
        opts = {
          position = "center";
          hl = "Comment";
        };
      }
    ];
  };
}
