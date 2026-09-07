{ ... }: {
   plugins.blink-cmp = {
      enable = true;
      setupLspCapabilities = true;
      settings = {
         cmdline = {
            keymap = {
               preset = "default";
               "<Tab>" = [
                  "accept"
                  "fallback"
               ];
               "<S-Tab>" = [
                  "select_prev"
                  "fallback"
               ];
            };
         };
         sources.default = [
            "lsp"
            "ripgrep"
            "path"
            "buffer"
            "snippets"
         ];
         # Expand LSP-provided snippets with LuaSnip (the snippet engine).
         snippets.preset = "luasnip";
         # Enable LSP completion inside opencode.nvim's Ask prompt (so @context
         # placeholders and agent names autocomplete while typing a prompt).
         sources.per_filetype.opencode_ask = [
            "lsp"
            "buffer"
         ];
         keymap = {
            preset = "default";
            "<Tab>" = [
               "accept"
               "fallback"
            ];
            "<S-Tab>" = [
               "select_prev"
               "fallback"
            ];
         };
         completion.ghost_text.enabled = true;
         # Show the type signature + docs of the selected completion item in a
         # side panel (VS Code-style "detail").
         completion.documentation = {
            auto_show = true;
            auto_show_delay_ms = 300;
            window = {
               border = "padded";
               max_height = 20;
               max_width = 60;
            };
         };
         # Show the function's parameter signature popup while typing args (like VS Code).
         signature = {
            enabled = true;
            window = {
               border = "padded";
            };
         };
      };
   };
}
