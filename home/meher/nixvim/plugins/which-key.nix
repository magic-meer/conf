{ ... }: {
   plugins.which-key = {
      enable = true;
      settings = {
         # Single column, anchored in the bottom-right corner.
         layout = {
            # Narrow container = one column of bindings stacked vertically.
            width = {
               min = 40;
               max = 60;
            };
            # Tall enough that entries stack vertically instead of wrapping into
            # multiple columns spanning the whole bottom of the screen.
            height = {
               min = 20;
               max = 30;
            };
            spacing = 3;
         };
         win = {
            border = "rounded";
            # Anchor the popup flush against the right edge (row stays bottom).
            col.__raw = "math.huge";
         };
      };
   };
}