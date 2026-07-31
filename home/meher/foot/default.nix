{
   pkgs,
   ...
}: {
   programs.foot = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshInetegration = true;

      settings = {
         main = {
               font = "JetBrainsMono Nerd Font:size=11";
               line-height = "14";
               letter-spacing = "1px";
               pad = "8x8 center";
               initial-window-size-chars = "100x30";
               initial-window-mode = "windowed";
               dpi-aware = "yes";
            };
            cursor = {
               style = "underline";
               blink = true;
               blink-rate = 500;
            };
            mouse = {
               hide-when-typing = true;
               alternate-scroll-mode = true;
            };
            csd = {
               preferred = "none";
               size = 0;
               border-width = 0;
            };
            "colors-dark" = {
               alpha = "0.35";
               blur = true;
            };
         };
      };
   };
}
