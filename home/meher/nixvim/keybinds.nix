{ ... }: {

  programs.nixvim.globals.mapleader = " ";

  programs.nixvim.keymaps = [
    {
      mode = "i";
      key = "jk";
      action = "<ESC>";
      options.desc = "Escape insert mode";
    }
    {
      mode = "n";
      key = "<ESC>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlights";
    }

    # ---- window movement: Shift + motions (replaces the old ctrl group) ----
    {
      mode = "n";
      key = "<S-h>";
      action = "<C-w>h";
      options.desc = "Move to left window";
    }
    {
      mode = "n";
      key = "<S-j>";
      action = "<C-w>j";
      options.desc = "Move to lower window";
    }
    {
      mode = "n";
      key = "<S-k>";
      action = "<C-w>k";
      options.desc = "Move to upper window";
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<C-w>l";
      options.desc = "Move to right window";
    }

    # ---- window management: <leader>w ----
    {
      mode = "n";
      key = "<leader>wh";
      action = "<C-w>v<C-w>h";
      options.desc = "Split left";
    }
    {
      mode = "n";
      key = "<leader>wj";
      action = "<C-w>s<C-w>j";
      options.desc = "Split below";
    }
    {
      mode = "n";
      key = "<leader>wk";
      action = "<C-w>s<C-w>k";
      options.desc = "Split above";
    }
    {
      mode = "n";
      key = "<leader>wl";
      action = "<C-w>v<C-w>l";
      options.desc = "Split right";
    }
    {
      mode = "n";
      key = "<leader>wx";
      action = "<C-w>q";
      options.desc = "Close window";
    }
    {
      mode = "n";
      key = "<leader>wo";
      action = "<C-w>o";
      options.desc = "Close all other windows";
    }

    # ---- tabs: only two keys <leader>+shift+h/l ----
    {
      mode = "n";
      key = "<leader><S-h>";
      action = "<cmd>tabprevious<CR>";
      options.desc = "Previous tab";
    }
    {
      mode = "n";
      key = "<leader><S-l>";
      action = "<cmd>tabnext<CR>";
      options.desc = "Next tab";
    }

    # ---- formatting: single key + :format (LSP per filetype) ----
    {
      mode = "n";
      key = "<leader>f";
      action = "<cmd>format<CR>";
      options.desc = "Format file";
    }

    # ---- LSP ----
    {
      mode = "n";
      key = "gd";
      action.__raw = "function() vim.lsp.buf.definition() end";
      options.desc = "Go to definition";
    }
    {
      mode = "n";
      key = "K";
      action.__raw = "function() vim.lsp.buf.hover() end";
      options.desc = "Hover documentation";
    }
    {
      mode = "n";
      key = "<leader>ca";
      action.__raw = "function() require('actions-preview').code_actions() end";
      options.desc = "Code actions (preview)";
    }
    {
      mode = "n";
      key = "<leader>rn";
      action.__raw = "function() vim.lsp.buf.rename() end";
      options.desc = "Rename symbol";
    }

    # ---- telescope ----
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<CR>";
      options.desc = "Find files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<CR>";
      options.desc = "Live grep";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<CR>";
      options.desc = "Find buffers";
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<CR>";
      options.desc = "Help tags";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>bdelete<CR>";
      options.desc = "Close buffer";
    }
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree toggle<CR>";
      options.desc = "Toggle file tree";
    }
    {
      mode = "n";
      key = "<leader>?";
      action = "<cmd>Legendary<CR>";
      options.desc = "Keymap cheatsheet";
    }
  ];
}