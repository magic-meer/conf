{
  programs.nixvim.plugins.neoscroll = {
    enable = true;

    settings = {
      hide_cursor = true;
      easing_function = "quadratic";
      performance_mode = false;
    };
  };
}
