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
