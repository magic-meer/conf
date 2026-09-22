{
  ...
}: {
  programs.niri.settings = {
    layout = {
      gaps = 4;

      center-focused-column = "on-overflow";

      preset-column-widths = [
        { proportion = 1. / 3.; }
        { proportion = 0.7; }
        { proportion = 2. / 3.; }
      ];

      default-column-width = { proportion = 0.5; };

      always-center-single-column = true;

      tab-indicator = {
        enable = true;
        position = "left";
        width = 4;
      };

      struts = {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };

      focus-ring = {
        enable = true;
        width = 2;
        active = { color = "#9a9a9a"; };
        inactive = { color = "#555555"; };
        urgent = { color = "#fb4934"; };
      };

      border = {
        enable = true;
        width = 1;
        active = { color = "#9a9a9a"; };
        inactive = { color = "#555555"; };
        urgent = { color = "#fb4934"; };
      };

      shadow = {
        enable = true;
      };
    };

    cursor = {
      theme = "Adwaita";
      size = 24;
    };

    animations = {
      window-open = {
        kind = {
          easing = {
            "duration-ms" = 250;
            curve = "ease-out-expo";
          };
        };
      };
      window-close = {
        kind = {
          easing = {
            "duration-ms" = 200;
            curve = "ease-out-cubic";
          };
        };
      };
      window-movement = {
        kind = {
          easing = {
            "duration-ms" = 200;
            curve = "ease-out-cubic";
          };
        };
      };
      window-resize = {
        kind = {
          easing = {
            "duration-ms" = 200;
            curve = "ease-out-cubic";
          };
        };
      };
      workspace-switch = {
        kind = {
          easing = {
            "duration-ms" = 250;
            curve = "ease-out-cubic";
          };
        };
      };
      horizontal-view-movement = {
        kind = {
          easing = {
            "duration-ms" = 250;
            curve = "ease-out-cubic";
          };
        };
      };
    };

    input = {
      mod-key = "Super";

      focus-follows-mouse = {
        enable = true;
      };

      keyboard.xkb = {
        layout = "us";
      };

      touchpad = {
        natural-scroll = true;
        tap = true;
      };
    };
  };
}
