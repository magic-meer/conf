{
  ...
}: {
  programs.niri.settings = {
    layout = {
      gaps = 8;

      center-focused-column = "on-overflow";

      preset-column-widths = [
        { proportion = 1. / 3.; }
        { proportion = 0.5; }
        { proportion = 2. / 3.; }
      ];

      default-column-width = { proportion = 0.5; };

      always-center-single-column = true;

      tab-indicator = {
        enable = true;
        position = "left";
        width = 4;
        active = { color = "#83a598"; };
        inactive = { color = "#504945"; };
      };

      struts = {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };
    };

    input = {
      focus-follows-mouse = {
        enable = true;
      };

      keyboard.xkb = {
        layout = "us";
        options = "ctrl:nocaps";
      };

      touchpad = {
        natural-scroll = true;
        tap = true;
      };
    };
  };
}
