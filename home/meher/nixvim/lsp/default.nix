{ ... }: {
   programs.nixvim.imports = [
      ./nix.nix
      ./qml.nix
      ./kotlin.nix
   ];
   programs.nixvim.plugins.lsp = { enable = true; };
}
