{ pkgs, lib, ... }: {
   programs.foot = {
      enable = true;
      package = pkgs.foot;

      settings = {
         main = {
            font = lib.mkForce "Spleen 16x32:size=8, JetBrainsMono Nerd Font:size=8";
            pad = "10x5";
            # keep the exact requested pixel size so niri's fixed-size window
            # rules don't resize the window after the app (e.g. cmatrix) starts
            resize-by-cells = "no";
         };
         scrollback = {
            lines = 0;
         };
         cursor = {
            style = "beam";
         };
         csd = {
            preferred = "none";
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
