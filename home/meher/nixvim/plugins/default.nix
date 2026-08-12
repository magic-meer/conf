{ ... }: {
   programs.nixvim = {
      imports = [
         ./actions-preview.nix
      ];
   };
}
