{ ... }: {
   programs.nixvim = {
      imports = [
         ./actions-preview.nix
         ./blink-indent.nix
         ./blink-cmp.nix
         ./blink-pairs.nix
         ./blink-ripgrep.nix
         ./bufferline.nix
         ./ccc.nix
         ./chadtree.nix
         ./transparent.nix
         ./fugit2.nix
         ./gitsigns.nix
         ./web-devicons.nix
         ./hardtime.nix
      ];
   };
}
