{ pkgs, ... }: {
   programs.foot = {
      enable = true;
      package = pkgs.foot;

      settings = {
         main = {
            font = "Spleen 16x32:size=8, JetBrainsMono Nerd Font:size=8";
            dpi-aware = "yes";
         };
         scrollback = {
            lines = 0;
         };
         cursor = {
            style = "beam";
         };
      };
   };
}
