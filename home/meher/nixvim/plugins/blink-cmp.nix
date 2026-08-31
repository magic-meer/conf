{ ... }: {
   plugins.blink-cmp = {
      enable = true;
      setupLspCapabilities = true;
      settings = {
         sources.default = [
            "lsp"
            "ripgrep"
            "path"
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
      };
   };
}
