{ ... }: {
  # Preview LSP results in floating windows instead of jumping away.
  # Default mappings: gpd (definition), gpi (implementation), gpr (references), gP (close)
  programs.nixvim.plugins.goto-preview = {
    enable = true;
  };
}
