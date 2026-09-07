{ ... }: {
   plugins.gitsigns = {
      enable = true;
      settings = {
         signs = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "󰍵";
            topdelete.text = "󰍵";
            changedelete.text = "▎";
            untracked.text = "┆";
         };
         signcolumn = true;
         # Show a blame hint at the end of the current line (who changed this line).
         current_line_blame = true;
         current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 500;
         };
      };
   };

   keymaps = [
      {
         mode = "n";
         key = "]c";
         action.__raw = "function() require('gitsigns').next_hunk({ navigation_message = false }) end";
         options.desc = "Next git hunk";
      }
      {
         mode = "n";
         key = "[c";
         action.__raw = "function() require('gitsigns').prev_hunk({ navigation_message = false }) end";
         options.desc = "Previous git hunk";
      }
      {
         mode = "n";
         key = "<leader>gs";
         action.__raw = "function() require('gitsigns').stage_hunk() end";
         options.desc = "Git: stage hunk";
      }
      {
         mode = "v";
         key = "<leader>gs";
         action.__raw = "function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end";
         options.desc = "Git: stage selected hunks";
      }
      {
         mode = "n";
         key = "<leader>gr";
         action.__raw = "function() require('gitsigns').reset_hunk() end";
         options.desc = "Git: reset hunk";
      }
      {
         mode = "n";
         key = "<leader>gp";
         action.__raw = "function() require('gitsigns').preview_hunk() end";
         options.desc = "Git: preview hunk";
      }
      {
         mode = "n";
         key = "<leader>gb";
         action.__raw = "function() require('gitsigns').blame_line({ full = true }) end";
         options.desc = "Git: blame line";
      }
      {
         mode = "n";
         key = "<leader>gd";
         action.__raw = "function() require('gitsigns').diffthis() end";
         options.desc = "Git: diff this file";
      }
   ];
}