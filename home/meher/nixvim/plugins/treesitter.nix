{ config, ... }: {
   plugins.treesitter = {
      enable = true;
      # folding.enable = true;
      highlight.enable = true;
      indent.enable = true;
   };

   plugins.treesitter-context = {
      enable = true;
   };
}

