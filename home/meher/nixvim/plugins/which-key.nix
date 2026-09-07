{ ... }: {
   plugins.which-key = {
      enable = true;
settings = {
          layout = {
             spacing = 3;
          };
          win = {
             # Fixed container width → single-column popup. Without it, which-key
             # 3.x splits the popup into N boxes that span the full editor width.
             width = 60;
             border = "rounded";
             # Anchor the popup flush against the right edge (row stays bottom).
             col.__raw = "math.huge";
          };
       };
   };
}