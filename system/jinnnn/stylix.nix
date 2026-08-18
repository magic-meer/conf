{ pkgs, ... }: {
   stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
      targets = {
         gtk.enable = true;
         qt.enable = true;
      };
      fonts = {
      monospace = {
         package = pkgs.ankacoder;
         name = "Anka/Coder";
         };
      };
   };
}
