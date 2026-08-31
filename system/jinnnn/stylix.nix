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
fonts = {
           monospace = {
              package = pkgs.spleen;
              name = "Spleen 16x32";
           };
        };
    };
 }
