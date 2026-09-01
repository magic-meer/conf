{ ... }: {
   plugins.showkeys = {
      enable = true;
      # Load at startup (not lazy on :ShowkeysToggle) so it can auto-open below.
      autoLoad = true;
      settings = {
         # Keys linger ~4s (default 3)
         timeout = 4;
         # Show the last 5 keys (default 3)
         maxkeys = 5;
         show_count = false;
         # Visible in insert mode too (good for demos/recordings)
         excluded_modes = [ ];
         # Bottom-right, above the global lualine (matches your error/notification corner)
         position = "bottom-right";
         winopts = {
            relative = "editor";
            style = "minimal";
            border = "rounded";
            height = 1;
            zindex = 90;
         };
         winhl = "Normal:Normal,FloatBorder:FloatBorder";
         keyformat = {
            "<BS>" = "󰁮 ";
            "<CR>" = "󰘌";
            "<Space>" = "󱁐";
            "<Up>" = "󰁝";
            "<Down>" = "󰁅";
            "<Left>" = "󰁍";
            "<Right>" = "󰁔";
            "<PageUp>" = "Page 󰁝";
            "<PageDown>" = "Page 󰁅";
            "<M>" = "Alt";
            "<C>" = "Ctrl";
         };
      };
   };

   # Show the keystroke overlay by default (runs after the setup() call above).
   extraConfigLua = ''
      require("showkeys").open()
   '';
}