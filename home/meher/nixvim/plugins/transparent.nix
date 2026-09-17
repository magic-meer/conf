{ ... }: {
   plugins.transparent = {
      enable = true;
      settings = {
         extra_groups = [
            # noice popups (cmdline, bottom-right, confirm)
            "NoiceCmdlinePopup"
            "NoiceCmdlinePopupBorder"
            "NoiceCmdlinePopupTitle"
            "NoicePopup"
            "NoicePopupBorder"
            "NoicePopupMenu"
            "NoicePopupMenuSelected"
            "NoicePopupMenuBorder"
            # nvim-notify
            "NotifyBackground"
            "NotifyBorder"
            "NotifyTitle"
            "NotifyErrorBorder"
            "NotifyWarnBorder"
            "NotifyInfoBorder"
            "NotifyDebugBorder"
            "NotifyTraceBorder"
            "NotifyErrorTitle"
            "NotifyWarnTitle"
            "NotifyInfoTitle"
            "NotifyDebugTitle"
            "NotifyTraceTitle"
         ];
         # srcery draws NormalFloat on its own background (gray1), which is
         # exactly what the K hover popup and the blink-cmp docs/signature
         # panes should use (they link NormalFloat).  If transparent.nvim
         # cleared them they would lose all background.
         exclude_groups = [
            "NormalFloat"
            "FloatBorder"
         ];
      };
   };

   extraConfigLua = ''
      -- FloatBorder has a fg (gray3) but no bg in srcery.  Give the float
      -- border the window's own background (taken from NormalFloat, i.e. the
      -- colorscheme background — never hardcoded) so rounded corners are
      -- seamless instead of showing the terminal behind the border glyphs.
      local function sync_float_border_bg()
        vim.schedule(function()
          local nf = vim.api.nvim_get_hl(0, { name = "NormalFloat" })
          if not (nf and nf.bg) then
            return
          end
          local fb = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
          vim.api.nvim_set_hl(0, "FloatBorder", { fg = fb.fg, bg = nf.bg, default = true })
        end)
      end
      vim.api.nvim_create_autocmd("ColorScheme", { callback = sync_float_border_bg })
      sync_float_border_bg()
   '';
}
