{
  ...
}: {
  programs.niri.settings = {
    layout = {
      focus-ring = {
        enable = true;
        width = 4;
        active = { color = "#83a598"; };
        inactive = { color = "#504945"; };
      };

      border = {
        enable = true;
        width = 2;
        active = { color = "#d3869b"; };
        inactive = { color = "#3c3836"; };
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

    # foot has no built-in animations, so window-level ones live here
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
