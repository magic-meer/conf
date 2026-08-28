{ pkgs, lib, ... }: {
   stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
      targets = {
         gtk.enable = true;
         qt = {
            enable = true;
            platform = lib.mkForce "gnome";
         };
      };
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      fonts = {
       monospace = {
          package = pkgs.ankacoder;
          name = "Anka/Coder";
          };
       };
    };
 }
