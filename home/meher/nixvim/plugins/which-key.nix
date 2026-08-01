{
  programs.nixvim.plugins.which-key = {
    enable = true;

    settings = {
      win = {
        # single column, anchored to the bottom-right corner
        col.__raw = "math.huge";
        row.__raw = "math.huge";
        width = 1;
      };
    };
  };
}
