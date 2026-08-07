{
  ...
}: {
  programs.niri.settings = {
    layout = {
      focus-ring = {
        enable = true;
        width = 2;
        active = { color = "#9a9a9a"; };
        inactive = { color = "#555555"; };
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

    # kitty handles terminal-side looks; window-level animations live here
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
  };
}
