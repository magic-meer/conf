{ config, ... }: {
   plugins.treesitter = {
      enable = true;
      # folding.enable = true;
      highlight.enable = true;
      indent.enable = true;

      settings = {
         ensure_installed = [
            "qmljs"
            "nix"
            "kotlin"
            "java"
            "python"
            "c-sharp"
         ];
      };
   };



   plugins.treesitter-context = {
      enable = true;
   };
}

