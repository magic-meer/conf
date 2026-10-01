{ ... }: {
   plugins.transparent = {
      enable = true;
      settings = {
         # noice popups (cmdline, bottom-right, confirm) and nvim-notify toasts
         # should show the terminal through them, so strip their backgrounds too.
         extra_groups = [
            "NoiceCmdlinePopup"
            "NoiceCmdlinePopupBorder"
            "NoiceCmdlinePopupTitle"
            "NoicePopup"
            "NoicePopupBorder"
            "NoicePopupMenu"
            "NoicePopupMenuSelected"
            "NoicePopupMenuBorder"
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
      -- srcery's FloatBorder has a fg (gray3) but no bg, and srcery links
      -- FloatTitle to Title, which has neither. That left the top border row of
      -- every titled/rounded float (blink.cmp docs, noice popups, K hover) with
      -- no background at all, so the terminal showed through the corners.
      --
      -- Copy NormalFloat's background -- read from the active colorscheme, never
      -- hardcoded -- onto both groups whenever the colorscheme changes, so float
      -- edges are seamless while the editor stays transparent.
      local function sync_float_bg()
        vim.schedule(function()
          local nf = vim.api.nvim_get_hl(0, { name = "NormalFloat" })
          if not (nf and nf.bg) then
            return
          end
          for _, group in ipairs({ "FloatBorder", "FloatTitle" }) do
            local hl = vim.api.nvim_get_hl(0, { name = group })
            vim.api.nvim_set_hl(0, group, { fg = hl.fg, bg = nf.bg, default = true })
          end

          -- Fully see-through twins of the two groups above, for overlays that
          -- should be invisible apart from their text (showkeys). Border glyphs
          -- keep their colour but must not paint a background, otherwise a
          -- "transparent" overlay still shows up as a dark bar top and bottom.
          for _, group in ipairs({ "FloatBorder", "FloatTitle" }) do
            local hl = vim.api.nvim_get_hl(0, { name = group })
            vim.api.nvim_set_hl(0, group .. "Transparent", { fg = hl.fg, bg = "NONE" })
          end
        end)
      end
      vim.api.nvim_create_autocmd("ColorScheme", { callback = sync_float_bg })
      -- plugin/transparent.vim only clears on VimEnter/ColorScheme, and the
      -- colorscheme is applied before this file runs, so nothing would sync the
      -- float groups until the colorscheme is reloaded.
      vim.api.nvim_create_autocmd("VimEnter", { callback = sync_float_bg })
      sync_float_bg()
   '';
}
