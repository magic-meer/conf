{
  programs.nixvim.plugins.mini = {
    enable = true;

    modules.animate = {
      # cursor path animation
      cursor = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 80, unit = 'total' })";
      };

      # smooth scrolling is handled by neoscroll
      scroll = {
        enable = false;
      };

      # animate window resizing
      resize = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 100, unit = 'total' })";
      };

      # animate window open/close with a fading preview window
      open = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 150, unit = 'total' })";
      };
      close = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 100, unit = 'total' })";
      };
    };
  };
}
