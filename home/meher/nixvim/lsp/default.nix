{ ... }: {
   imports = [
      ./nix.nix
   ];
   programs.nixvim.plugins.lsp = { enable = true; };
}
