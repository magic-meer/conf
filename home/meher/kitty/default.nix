{
   pkgs,
   ...
}: {
   programs.kitty = {
      enable = true;

      shellIntegration.enableFishIntegration = true;
      enableGitIntegration = true;

      settings = {
         font_family = "JetBrainsMono Nerd Font";
         font_size = 11;
         # foot's line-height 14pt at 11pt font ≈ 127%
         adjust_line_height = "127%";
         # NOTE: foot's letter-spacing "1px" has no kitty equivalent.

         window_padding_width = 8;

         # foot's 100x30 chars
         initial_window_width = "100c";
         initial_window_height = "30c";

         # foot csd preferred = "none"
         hide_window_decorations = "yes";

         cursor_shape = "underline";
         cursor_blink_interval = 0.5;
         cursor_stop_blinking_after = "5.0";

         # foot hide-when-typing
         mouse_hide_wait = 0.1;

         # foot alternate-scroll-mode
         alternate_scroll_multiplier = 5;

         # foot colors-dark alpha 0.35 + blur
         background_opacity = 0.35;
         background_blur = 5;
         dynamic_background_opacity = true;

         # cursor trail animation (ms the cursor must stay put before a
         # trail follows it on the next jump; 0 = off)
         cursor_trail = 200;
         cursor_trail_decay = "0.1 0.4";
         cursor_trail_start_threshold = 2;
         cursor_trail_color = "#7aa2f7";

         confirm_on_window_close = 0;
         enable_audio_bell = false;
      };
   };
}
