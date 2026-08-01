{
  programs.nixvim.plugins.which-key = {
    enable = true;

    settings = {
      win = {
        # anchored to the bottom-right corner.
        # NOTE: width is the window width in columns; with the default
        # layout.width.min = 20 the popup always renders a single column.
        col.__raw = "math.huge";
        row.__raw = "math.huge";
        width = 40;
        # border colors come from the colorscheme's WhichKeyBorder highlight
        border = "rounded";
      };
    };
  };
}
