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
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Move to left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Move to lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Move to upper window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Move to right window";
    }
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>bprevious<CR>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>bnext<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>bdelete<CR>";
      options.desc = "Close buffer";
    }
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
      key = "<leader>e";
      action = "<cmd>Neotree toggle<CR>";
      options.desc = "Toggle file tree";
    }
  ];
}
