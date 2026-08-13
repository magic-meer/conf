{ ... }: {
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

      #scro
   };
}
