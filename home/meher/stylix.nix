{ ... }: {
   stylix = {
      targets = {
         gtk = {
            enable = true;
            extraCss = ''
              /* Make all GTK windows fully transparent for niri blur */
              window,
              window.background,
              .window,
              .window.background,
              window.csd,
              window.csd.background {
                background-color: transparent;
                background-image: none;
              }

              /* GTK4 specific */
              window.default-decoration,
              window.default-decoration.background {
                background-color: transparent;
                background-image: none;
              }

              /* Popovers and menus */
              popover,
              popover.background,
              .popover,
              .popover.background {
                background-color: transparent;
                background-image: none;
              }

              /* Tooltips */
              tooltip,
              tooltip.background {
                background-color: transparent;
                background-image: none;
              }
            '';
         };
         qt = {
            enable = true;
            platform = "gnome";
         };
      };
   };
}