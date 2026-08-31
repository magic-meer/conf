{ pkgs, ... }: {
   programs.ghostty = {
      enable = true;
      package = pkgs.ghostty;

      enableFishIntegration = true;

   settings = {
      font-family = [ "Spleen 16x32" "JetBrainsMono Nerd Font" ];
      background-opacity = 0;
      background-blur = true;
         scrollbar = "never";
         window-decoration = "none";
         window-padding-x = 10;
         window-padding-y = 5;
         confirm-close-surface = false;
   };
   };
}
