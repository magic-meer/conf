{ ... }: {
   programs.nixvim.imports = [
      ./nix.nix
      ./qml.nix
      ./kotlin.nix
         ./java.nix
      ./python.nix
      ./csharp.nix
   ];
   programs.nixvim.plugins.lsp = { enable = true; };
}
