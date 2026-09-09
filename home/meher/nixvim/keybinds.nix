{ ... }: {
  programs.nixvim.keymaps = let
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

    # System clipboard
    (nmap "<leader>y" "\"+y" "Yank to system clipboard")
    (vmap "<leader>y" "\"+y" "Yank to system clipboard")
    (nmap "<leader>p" "\"+p" "Put from system clipboard")
    (vmap "<leader>p" "\"+p" "Put from system clipboard")

    # LSP info
    # Hover: show details of the symbol under the cursor (VS Code hover)
    (nmap "K" "<cmd>lua vim.lsp.buf.hover()<CR>" "LSP hover documentation")
    # Signature help: show the function's parameter signature manually
    (nmap "<C-Space>" "<cmd>lua vim.lsp.buf.signature_help()<CR>" "LSP signature help")
    (imap "<C-Space>" "<cmd>lua vim.lsp.buf.signature_help()<CR>" "LSP signature help")
    # Code actions previewed with actions-preview (quick-fixes, imports, etc.)
    (nmap "<leader>ca" "<cmd>lua require('actions-preview').code_actions()<CR>" "LSP code action (preview)")
    (vmap "<leader>ca" "<cmd>lua require('actions-preview').code_actions()<CR>" "LSP code action (preview)")
    # Rename symbol across the workspace (LSP)
    (nmap "<leader>rn" "<cmd>lua vim.lsp.buf.rename()<CR>" "LSP rename symbol")

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
    (nmap "<leader>td" "<cmd>Telescope diagnostics<CR>" "Diagnostics")
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
}