{
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = true;
      window = {
        # sidebar on the right so the code buffer stays put
        position = "right";
        mappings = {
          # vim motions: l unfolds, h folds
          l = "open";
          h = "close_node";
        };
      };
      filesystem.follow_current_file.enabled = true;
    };
  };
}
