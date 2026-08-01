{ ... }: {
  # Preview LSP code actions before applying them.
  # <leader>ca is remapped to this in keybinds.nix
  programs.nixvim.plugins.actions-preview = {
    enable = true;
    settings.telescope.sorting_strategy = "ascending";
  };
}
