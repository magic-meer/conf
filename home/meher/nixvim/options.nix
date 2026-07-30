{ ... }: {
  programs.nixvim.opts = {
    number = true;
    relativenumber = true;
    tabstop = 3;
    shiftwidth = 3;
    expandtab = true;
    smartindent = true;
    hlsearch = true;
    incsearch = true;
    ignorecase = true;
    smartcase = true;
    cursorline = true;
    splitright = true;
    splitbelow = true;
    mouse = "a";
    clipboard = "unnamedplus";
    scrolloff = 8;
    signcolumn = "yes";
    timeoutlen = 300;
  };
}
