{ pkgs, lib, ... }: {
   stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
      targets = {
         gtk.enable = true;
         # Off: the QML shell paints everything from its own Settings.qml
         # palette, and this only injected QT_QPA_PLATFORMTHEME=gnome +
         # QT_STYLE_OVERRIDE=adwaita-dark into every Qt process.
         qt.enable = false;
         nixvim.enable = false;
      };
fonts = {
           monospace = {
              package = pkgs.spleen;
              name = "Spleen 16x32";
           };
        };
    };
 }
