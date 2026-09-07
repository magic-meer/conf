{ pkgs, ... }: {
   # LuaSnip snippet engine, wired into blink-cmp (which uses it to expand LSP
   # snippets via `snippets.preset = "luasnip"`, see blink-cmp.nix).
   plugins.luasnip = {
      enable = true;
      settings = {
         # Keep a history so we can jump back into finished snippets.
         history = true;
         # Refresh dynamic/function nodes on every keystroke, not just InsertLeave.
         update_events = "TextChanged,TextChangedI";
         enable_autosnippets = true;
      };
      # Load VS Code-style snippets (friendly-snippets below) and any lua
      # snippets on the runtimepath.
      fromVscode = [ { } ];
      fromLua = [ { } ];
   };

   # Standard library of VS Code-style snippets for most languages.
   extraPlugins = [ pkgs.vimPlugins.friendly-snippets ];

   # Snippet navigation:
   #   <C-j> next placeholder, <C-k> previous, <C-l> cycle choices.
   keymaps = [
      {
         mode = "i";
         key = "<C-j>";
         action.__raw = "function() require('luasnip').jump(1) end";
         options.desc = "Next snippet placeholder";
      }
      {
         mode = "s";
         key = "<C-j>";
         action.__raw = "function() require('luasnip').jump(1) end";
         options.desc = "Next snippet placeholder";
      }
      {
         mode = "i";
         key = "<C-k>";
         action.__raw = "function() require('luasnip').jump(-1) end";
         options.desc = "Previous snippet placeholder";
      }
      {
         mode = "s";
         key = "<C-k>";
         action.__raw = "function() require('luasnip').jump(-1) end";
         options.desc = "Previous snippet placeholder";
      }
      {
         mode = "i";
         key = "<C-l>";
         action.__raw = ''
           function()
             local ls = require("luasnip")
             if ls.choice_active() then
               ls.change_choice(1)
             end
           end
         '';
         options.desc = "Cycle snippet choice";
      }
      {
         mode = "s";
         key = "<C-l>";
         action.__raw = ''
           function()
             local ls = require("luasnip")
             if ls.choice_active() then
               ls.change_choice(1)
             end
           end
         '';
         options.desc = "Cycle snippet choice";
      }
   ];
}