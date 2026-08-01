{ ... }: {
  # opencode.nvim — AI pair programmer inside Neovim.
  # Requires the `opencode` CLI, which is already in home.packages.
  programs.nixvim.plugins.opencode.enable = true;
}
