{ ... }: {
  # Highlights color codes (hex, names, CSS functions) in buffers
  programs.nixvim.plugins.colorizer = {
    enable = true;
    settings.user_default_options.css = true;
  };
}
