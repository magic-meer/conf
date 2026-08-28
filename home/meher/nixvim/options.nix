{ ... }: {
   programs.nixvim.globals.mapleader = " ";
  programs.nixvim.globals.maplocalleader = "\\";
   programs.nixvim.opts = {
      #numbers
      number = true;
      relativenumber = true;

      #tabs
     tabstop = 3;
      shiftwidth = 3;
      softtabstop = 3;
      expandtab = true;

      #indent
      autoindent = true;

      #search
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;

      #wrap
      wrap = false;
      linebreak = true;
      breakindent = true;

      #scroll
      sidescrolloff = 8;

      #cursor line
      cursorline = true;

      #split
      splitbelow = true;
      splitright = true;

      #sign column
      signcolumn = "yes";

      #misc

      undofile = true;
      termguicolors = true;
      wildmenu = true;
      showcmd = true;
   };
}
