{ pkgs, ... }: {
   programs.ghostty = {
      enable = true;
      package = pkgs.ghostty;

      enableFishIntegration = true;

   settings = {
      background-opacity = 0.1;
      background-blur = true;
         scrollbar = "never";
         window-decoration = "none";
         window-padding-x = 10;
         window-padding-y = 10;
         confirm-close-surface = false;
   };
   };
}
