{ config, pkgs, inputs, ... }:
let
   c = config.lib.stylix.colors;
   cursorColors = {
      body = "#${c.base06}";
      outline = "#${c.base01}";
      accent = "#${c.base0D}";
   };
in {
   home.pointerCursor = {
      enable = true;
      package = inputs.nix-cursors.packages.${pkgs.system}.bibata-modern-cursor.override {
         background_color = cursorColors.body;
         outline_color = cursorColors.outline;
         accent_color = cursorColors.accent;
      };
      name = "Bibata-Modern-Custom";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
   };
   stylix = {
      targets = {
         gtk = {
            enable = true;
            extraCss = ''
              /* ============================================================
               * Full transparency for GTK apps so niri's blur shows through.
               * niri already provides the blurred background, so the app
               * itself should be fully see-through.
               * ============================================================ */

              /* --- Window-level transparency (GTK3 + GTK4) --- */
              window,
              window.background,
              window.background.csd,
              window.csd,
              .window,
              .window.background,
              window.default-decoration,
              window.default-decoration.background {
                background-color: transparent;
                background-image: none;
              }

              /* --- Libadwaita: override palette variables to transparent ---
               * libadwaita draws backgrounds on child widgets (sidebar,
               * headerbar, content view, cards, popovers, dialogs) using
               * these CSS variables, sitting on top of the window. We must
               * zero them out or the window stays opaque. */
              window.background,
              window.background.csd,
              window.csd {
                --window-bg-color: transparent;
                --window-backdrop-color: transparent;
                --window-fg-color: inherit;

                --sidebar-bg-color: transparent;
                --sidebar-backdrop-color: transparent;
                --sidebar-fg-color: inherit;
                --sidebar-shade-color: transparent;
                --sidebar-border-color: transparent;

                --headerbar-bg-color: transparent;
                --headerbar-backdrop-color: transparent;
                --headerbar-fg-color: inherit;
                --headerbar-shade-color: transparent;
                --headerbar-border-color: transparent;
                --headerbar-darker-shade-color: transparent;

                --view-bg-color: transparent;
                --view-fg-color: inherit;

                --card-bg-color: transparent;
                --card-fg-color: inherit;
                --card-shade-color: transparent;

                --dialog-bg-color: transparent;
                --dialog-fg-color: inherit;

                --popover-bg-color: transparent;
                --popover-fg-color: inherit;
                --popover-shade-color: transparent;

                --tooltip-bg-color: transparent;
                --tooltip-fg-color: inherit;

                --osd-bg-color: transparent;

                --shade-color: transparent;
                --backdrop-shade-color: transparent;
                --border-color: transparent;
                --borders: transparent;
              }

              /* --- Explicit structural selectors (GTK3 + edge cases) --- */
              .sidebar,
              .sidebar.background,
              .navigation-sidebar,
              placessidebar,
              placessidebar .view,
              headerbar,
              headerbar.titlebar,
              windowhandle,
              .titlebar,
              .view,
              content,
              popover,
              popover.background,
              .menu,
              .context-menu,
              menubar,
              dialog,
              dialog.background,
              messagedialog,
              .message-dialog,
              tooltip,
              tooltip.background {
                background-color: transparent;
                background-image: none;
              }

              /* Keyring / polkit / zenity prompts: strip dialog chrome too */
              dialog.background box,
              dialog.background grid,
              dialog.background viewport,
              messagedialog box,
              messagedialog grid {
                background-color: transparent;
                background-image: none;
              }
            '';
         };
          qt = {
             enable = true;
             platform = "adwaita";
          };
      };
   };
}