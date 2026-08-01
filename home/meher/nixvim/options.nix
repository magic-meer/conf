{ ... }: {
   programs.nixvim.opts = {
      #line numbers
      number = true;
      relativenumber = true;

      #more colors
      termguicolors = true;

      #better completion
      completeopt = [
         "menuone"
         "noselect"
         "noinsert"
      ];

      #idk what this is but it does not work
      # signcolumn = true;

      #mouse
      mouse = "a";

      #search
      ignorecase = true;
      smartcase = true;

      #splits
      splitright = true;
      splitbelow = true;

      list = true;
      # NOTE: .__raw here means that this field is raw lua code
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

      expandtab = true;
      tabstop = 3;
      shiftwidth = 3;
      softtabstop = 0;
      smarttab = true;

      #clipboard
      clipboard = "unnamedplus";

      # Set encoding
      encoding = "utf-8";
      fileencoding = "utf-8";

      # Save undo history
      undofile = true;
      swapfile = true;
      backup = true;
      autoread = true;

      # Highlight the current line for cursor
      cursorline = true;

      # Show line and column when searching
      ruler = true;

      # Global substitution by default
      gdefault = true;

      # Start scrolling when the cursor is X lines away from the top/bottom
      scrolloff = 5;
   };
}
