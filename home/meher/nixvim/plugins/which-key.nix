{ ... }: {
   plugins.which-key = {
      enable = true;
      settings = {
         layout = {
            spacing = 3;
         };
         win = {
            # Fixed container width → single-column popup. Without it, which-key
            # 3.x splits the popup into N boxes that span the full editor width.
            width = 60;
            border = "rounded";
            # Anchor the popup flush against the right edge (row stays bottom).
            col.__raw = "math.huge";
         };
      };
   };

   # which-key maps its float through WhichKeyNormal / WhichKeyBorder /
   # WhichKeyTitle (which-key/win.lua:19). srcery only defines the first one, as
   # `hi! link WhichKeyNormal Normal` (srcery.vim:801), and NormalFloat is
   # excluded from transparent.nvim -- so the popup body came out see-through
   # while the border rows stayed opaque, i.e. a hollow frame.
   #
   # These are plain links, so they track the colorscheme on their own and stay
   # correct after a `:colorscheme` change without any re-application hook.
   # WhichKeyNormal picks up the same opaque gray1 that K hover and the blink
   # docs use, which is what makes the popup readable over a busy buffer.
   extraConfigLua = ''
      vim.api.nvim_set_hl(0, "WhichKeyNormal", { link = "NormalFloat" })
      vim.api.nvim_set_hl(0, "WhichKeyBorder", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "WhichKeyTitle", { link = "FloatTitle" })
   '';
}
