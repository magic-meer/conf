{ pkgs, lib, ... }: {
   programs.foot = {
      enable = true;
      package = pkgs.foot;

      settings = {
         main = {
            font = lib.mkForce "Spleen 16x32:size=8, JetBrainsMono Nerd Font:size=8";
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
