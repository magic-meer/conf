{ ... }: {
  # File explorer. Replaces nvim-tree (disabled in plugins/default.nix — they collide).
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = true;
      filesystem.follow_current_file.enabled = true;
    };
  };
}
