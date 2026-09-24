{ pkgs, lib, ... }: {
   programs.foot = {
      enable = true;
      package = pkgs.foot;

      settings = {
         main = {
            font = lib.mkForce "Spleen 16x32:size=8, JetBrainsMono Nerd Font:size=8";
            dpi-aware = lib.mkForce "yes";
            pad = "10x5 center";
            resize-by-cells = "no";
         };
         scrollback = {
            lines = 10000;
            indicator-position = "none";
         };
         cursor = {
            style = "beam";
         };
         mouse = {
            hide-when-typing = "yes";
         };
         csd = {
            preferred = "none";
            size = 0;
            border-width = 0;
         };
         "colors-dark" = {
            alpha = lib.mkForce 0;
         };
         "colors-light" = {
            alpha = lib.mkForce 0;
         };
      };
   };
}
