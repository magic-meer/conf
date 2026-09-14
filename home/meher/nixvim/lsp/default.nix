{ ... }: {
   programs.nixvim.imports = [
      ./nix.nix
      ./qml.nix
      ./kotlin.nix
      ./python.nix
   ];
   programs.nixvim.plugins.lsp = { enable = true; };
}
