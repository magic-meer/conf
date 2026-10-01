{
   ...
}: {
   plugins.notify = {
      enable = true;
      settings = {
         timeout = 5000;
         top_down = false;
         # Only used by NotifyBufHighlights:set_opacity to blend the *text* while
         # it fades in. It is not a backdrop, see extraConfigLua below.
         background_colour = "#000000";
      };
   };

    # noice's notify view hands nvim-notify a `keep` callback that returns true
    # whenever the UI counts as "blocking" (insert mode, an open cmdline, a live
    # noice cmdline view). nvim-notify stops *and discards* its dismiss timer the
    # first time `keep()` is true, so every toast raised while typing stays on
    # screen forever. Forcing `keep` to false lets the timer always fire.
    #
    # The second problem was stacking. nvim-notify is built for many concurrent
    # toasts: each new one gets its own window, they are laid out in a column
    # (WindowAnimator.available_slot), and a dismissing toast keeps its row while
    # it animates out. An LSP that reports "working" then "done" (basedpyright on
    # every keystroke) therefore produced two overlapping toasts, and the pile-up
    # was still visible after the first one had gone.
    #
    # So: tear down whatever is on screen before raising the next toast, which
    # makes the display strictly last-one-wins. `dismiss()` uses
    # nvim_win_close(win, true) -- an immediate, unanimated close -- so there is
    # no slide-out window for the next toast to overlap, and `pending = true`
    # drains the FIFO queue so nothing pops out late. Stale animator state is not
    # a concern: WindowAnimator:_apply_win_state calls util.get_win_config and
    # runs _remove_win for any window that is already gone.
   extraConfigLua = ''
      -- Make the toast body genuinely transparent.
      --
      -- nvim-notify seeds its body groups with `hi default link Notify<LVL>Body
      -- Normal`, and NotificationBuf:_create_highlights then reads that link back
      -- with `nvim_get_hl(..., link = false)` and *freezes* the resolved table --
      -- background included -- into a per-buffer "Notify<LVL>Body<bufnr>" group.
      -- That copy is what the window actually paints through, and it is captured
      -- once, so it cannot be fixed afterwards: NotifyBufHighlights:set_opacity
      -- keeps re-blending that stale `bg` towards background_colour on every
      -- animation frame and puts it straight back.
      --
      -- So the fix has to land on the base groups, before any buffer copies them.
      -- This runs after nvim-notify's setup (nixvim emits every setup() before
      -- extraConfigLua), so the `hi default link ... Normal` has already run; an
      -- explicit definition wins over a `default` one, and notify's
      -- ColorScheme refresh will not undo it. Keeping the resolved foreground
      -- preserves the text colour, only the background goes away.
      --
      -- This is not cosmetic: transparent.nvim does not make Normal transparent
      -- immediately. M.clear() fires on VimEnter and then re-fires at 500ms, 1s,
      -- 3s and 5s, so for the first few seconds of a session Normal still carries
      -- its colorscheme background -- long enough for the very first toast to
      -- bake it in and stay opaque for its whole 5s life.
      for _, level in ipairs({ "ERROR", "WARN", "INFO", "DEBUG", "TRACE" }) do
        local name = "Notify" .. level .. "Body"
        local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        hl.bg, hl.ctermbg = nil, nil
        vim.api.nvim_set_hl(0, name, hl)
      end

      local notify = require("notify")
      local notify_notify = notify.notify
      notify.notify = function(msg, level, opts)
        opts = vim.tbl_extend("force", opts or {}, { keep = function() return false end })
        notify.dismiss({ pending = true, silent = true })
        return notify_notify(msg, level, opts)
      end
      -- noice calls the module itself (require("notify")(...)), whose __call
      -- metamethod dispatches through the `notify` field patched above.
   '';
}


