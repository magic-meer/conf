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
  };
}
