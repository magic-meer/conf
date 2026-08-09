{ ... }: {
  imports = [
    ./nix.nix
    ./qml.nix
    ./python.nix
  ];

  # The modern LSP manager backend that `lsp.servers.*` builds on (also silences
  # the lsp-format "requires plugins.lsp" warning)
  programs.nixvim.plugins.lsp.enable = true;
}