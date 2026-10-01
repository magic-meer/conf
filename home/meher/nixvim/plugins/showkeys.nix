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
# Top-right so it doesn't overlap the bottom-right notification stack.
          position = "top-right";
         winopts = {
            relative = "editor";
            style = "minimal";
            border = "rounded";
            height = 1;
            zindex = 90;
         };
         # Fully see-through: "Normal" is cleared by transparent.nvim, and
         # FloatBorderTransparent is the border twin defined in transparent.nix.
         # Pointing this at plain FloatBorder would paint two opaque bars above
         # and below the (invisible) text row, which is what still looked like a
         # solid background box.
         winhl = "Normal:Normal,FloatBorder:FloatBorderTransparent,FloatTitle:FloatTitleTransparent";
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