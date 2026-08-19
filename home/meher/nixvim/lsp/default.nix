{ ... }: {
   programs.nixvim = {
      imports = [
         ./nix.nix
      ];
   };
}