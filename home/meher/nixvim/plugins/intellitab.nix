{ ... }: {
   plugins.intellitab = {
      enable = true;
   };

   # Only config this plugin needs: rebind Tab to intellitab's smart indent.
   keymaps = [
      {
         mode = "i";
         key = "<Tab>";
         action.__raw = "require('intellitab').indent";
      }
   ];
}