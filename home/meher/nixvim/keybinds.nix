{ ... }: {
  programs.nixvim = rec {
    keymaps = let
    # Helper function to create keymaps with less boilerplate
    # Usage: map "n" "<leader>e" ":Neotree toggle<CR>" "Toggle file tree"
    map = mode: key: action: desc:
      {
        mode = mode;
        key = key;
        action = action;
        options = { desc = desc; };
      };

    # Convenience wrappers for common modes
    nmap = key: action: desc: map "n" key action desc;
    vmap = key: action: desc: map "v" key action desc;
    imap = key: action: desc: map "i" key action desc;
    xmap = key: action: desc: map "x" key action desc;
    omap = key: action: desc: map "o" key action desc;
    tmap = key: action: desc: map "t" key action desc;
  in [
    # File explorer
    (nmap "<leader>e" "<cmd>Neotree toggle<CR>" "Toggle file tree")

    # File management
    (nmap "<leader>q" "<cmd>q<CR>" "Quit")
    (nmap "<leader>w" "<cmd>w<CR>" "Write")
    # Run the current file with code_runner.nvim (floating snacks terminal);
    # :q in the terminal closes it. Use <leader>rc to stop a running job.
    (nmap "<leader>r" "<cmd>RunFile<CR>" "Run current file")
    (nmap "<leader>rc" "<cmd>RunClose<CR>" "Close / stop runner")

    # System clipboard
    (nmap "<leader>y" "\"+y" "Yank to system clipboard")
    (vmap "<leader>y" "\"+y" "Yank to system clipboard")
    (nmap "<leader>p" "\"+p" "Put from system clipboard")
    (vmap "<leader>p" "\"+p" "Put from system clipboard")

    # LSP info
# Hover: toggleable docs popup (see Hover in extraConfigLua below). K opens the
# docs AND moves the cursor into the popup; K again (or <Esc>/q inside) closes.
     (nmap "K" "<cmd>lua Hover.toggle()<CR>" "LSP hover documentation")
    # Signature help: show the function's parameter signature manually
    (nmap "<C-Space>" "<cmd>lua vim.lsp.buf.signature_help()<CR>" "LSP signature help")
    (imap "<C-Space>" "<cmd>lua vim.lsp.buf.signature_help()<CR>" "LSP signature help")

    # === OpenCode (AI agent) — all under <leader>op ===
    # Ask the agent, scoped to the current selection/range
    (nmap "<leader>opa" "<cmd>lua require('opencode').ask('@this: ')<CR>" "OpenCode: ask (current scope)")
    (vmap "<leader>opa" "<cmd>lua require('opencode').ask('@this: ')<CR>" "OpenCode: ask (selection)")
    # Free-form new prompt. Deliberately NOT `<leader>op` alone: that would be a
    # prefix of `<leader>opa`/`<leader>ops`/... and Neovim would wait `timeoutlen`
    # then fire, blocking the longer binds. `<leader>op<CR>` is unambiguous.
    (nmap "<leader>op<CR>" "<cmd>lua require('opencode').ask()<CR>" "OpenCode: ask (new)")
    # Global picker: prompts / commands / servers
    (nmap "<leader>ops" "<cmd>lua require('opencode').select()<CR>" "OpenCode: select prompt/command/server")
    # Operator form (dot-repeatable): send a motion/range
    (nmap "<leader>opp" "<cmd>lua require('opencode').operator('@this ')<CR>" "OpenCode: operator range")
    # Session control
    (nmap "<leader>opn" "<cmd>lua require('opencode').command('session.new')<CR>" "OpenCode: new session")
    (nmap "<leader>opu" "<cmd>lua require('opencode').command('session.undo')<CR>" "OpenCode: undo")
    (nmap "<leader>opr" "<cmd>lua require('opencode').command('session.redo')<CR>" "OpenCode: redo")
    (nmap "<leader>opi" "<cmd>lua require('opencode').command('session.interrupt')<CR>" "OpenCode: interrupt")
    (nmap "<leader>opc" "<cmd>lua require('opencode').command('session.compact')<CR>" "OpenCode: compact session")
    (nmap "<leader>opl" "<cmd>lua require('opencode').command('session.last')<CR>" "OpenCode: jump to last message")
    (nmap "<leader>opf" "<cmd>lua require('opencode').command('session.first')<CR>" "OpenCode: jump to first message")
    # Scroll agent output
    (nmap "<S-C-u>" "<cmd>lua require('opencode').command('session.half.page.up')<CR>" "OpenCode: scroll up")
    (nmap "<S-C-d>" "<cmd>lua require('opencode').command('session.half.page.down')<CR>" "OpenCode: scroll down")

    # Telescope (<leader>t prefix)
    (nmap "<leader>tf" "<cmd>Telescope find_files<CR>" "Find files")
    (nmap "<leader>tg" "<cmd>Telescope live_grep<CR>" "Live grep")
    (nmap "<leader>tb" "<cmd>Telescope buffers<CR>" "Buffers")
    (nmap "<leader>th" "<cmd>Telescope help_tags<CR>" "Help tags")
    (nmap "<leader>tr" "<cmd>Telescope oldfiles<CR>" "Recent files")
    (nmap "<leader>tgf" "<cmd>Telescope git_files<CR>" "Git files")
    (nmap "<leader>ts" "<cmd>Telescope grep_string<CR>" "Grep word under cursor")
    (nmap "<leader>td" "<cmd>lua require('actions-preview').code_actions()<CR>" "Code actions (preview)")
    (nmap "<leader>tlr" "<cmd>Telescope lsp_references<CR>" "LSP references")
    (nmap "<leader>tls" "<cmd>Telescope lsp_document_symbols<CR>" "Document symbols")
    (nmap "<leader>tlw" "<cmd>Telescope lsp_workspace_symbols<CR>" "Workspace symbols")
    (nmap "<leader>tc" "<cmd>Telescope commands<CR>" "Commands")
    (nmap "<leader>tk" "<cmd>Telescope keymaps<CR>" "Keymaps")
    (nmap "<leader>tp" "<cmd>Telescope colorscheme<CR>" "Colorscheme")
    (nmap "<leader>tt" "<cmd>Telescope resume<CR>" "Resume last picker")

    # Showkeys: toggle the keystroke screencaster
    (nmap "<leader>sk" "<cmd>ShowkeysToggle<CR>" "Toggle showkeys")

    # Git UI (fugit2) — full git GUI in a popup
    (nmap "<leader>git" "<cmd>Fugit2<CR>" "Git (fugit2)")

    # Color picker / highlighter (ccc)
    (nmap "<leader>cp" "<cmd>lua require('ccc').picker()<CR>" "Color picker")
    ];

    extraConfigLua = ''
    -- Toggleable LSP hover:
    --   * K opens the docs AND moves the cursor into the popup
    --   * K again (or <Esc>/q inside) closes the whole popup
    --   * it never auto-closes when the cursor moves in the source buffer
    Hover = {}

    function Hover.close()
      if Hover.win and vim.api.nvim_win_is_valid(Hover.win) then
        vim.api.nvim_win_close(Hover.win, true)
      end
      Hover.win, Hover.buf = nil, nil
    end

    function Hover.toggle()
      if Hover.win and vim.api.nvim_win_is_valid(Hover.win) then
        Hover.close()
        return
      end

      local client = vim.lsp.get_clients({ bufnr = 0 })[1]
      if not client then
        return
      end
      local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
      vim.lsp.buf_request(0, 'textDocument/hover', params, function(err, result)
        if err then
          vim.notify(('Hover request failed: %s'):format(err.message), vim.log.levels.WARN)
          return
        end
        if Hover.win and vim.api.nvim_win_is_valid(Hover.win) then
          return
        end
        local contents = result and result.contents
        if contents == nil or vim.tbl_isempty(contents) then
          return
        end

        local lines = vim.lsp.util.convert_input_to_markdown_lines(contents)
        lines = vim.lsp.util.trim_empty_lines(lines)
        if vim.tbl_isempty(lines) then
          return
        end

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
        vim.bo[buf].wrap = true
        pcall(function()
          vim.bo[buf].syntax = 'markdown'
        end)

        local width = 20
        for _, line in ipairs(lines) do
          width = math.max(width, vim.fn.strdisplaywidth(line) + 4)
        end
        width = math.min(width, math.floor(vim.o.columns * 0.5))
        local height = math.min(#lines + 2, 20)

        local win = vim.api.nvim_open_win(buf, false, {
          relative = 'cursor',
          row = 1,
          col = 0,
          width = width,
          height = height,
          border = 'rounded',
          style = 'minimal',
          focusable = true,
        })

        local keymap = { silent = true, noremap = true, nowait = true }
        vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>lua Hover.close()<CR>', keymap)
        vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>lua Hover.close()<CR>', keymap)
        vim.api.nvim_buf_set_keymap(buf, 'i', '<Esc>', '<cmd>lua Hover.close()<CR>', keymap)

        Hover.win, Hover.buf = win, buf
        -- Move the cursor into the docs popup (j/k scroll it, K/q/<Esc> close).
        vim.api.nvim_set_current_win(win)
      end)
    end
  '';
  };
}