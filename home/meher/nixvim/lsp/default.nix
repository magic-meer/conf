{ ... }: {
   programs.nixvim.imports = [
      ./nix.nix
      ./qml.nix
   ];
   programs.nixvim.plugins.lsp = { enable = true; };
}
