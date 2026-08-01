{ ... }: {
  # Dims the parts of the code you aren't working on (treesitter-aware)
  programs.nixvim.plugins.twilight = {
    enable = true;
    settings = {
      dimming.alpha = 0.25;
      context = 10;
    };
  };
}
