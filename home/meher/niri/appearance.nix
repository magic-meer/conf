{ ... }: {
  programs.niri.settings = {
    layout = {
      focus-ring = {
        enable = true;
        width = 0;
      };

      border = {
        enable = true;
        width = 0;
      };

      shadow = {
        enable = true;
      };
    };

    cursor.size = 24;
  };
}
