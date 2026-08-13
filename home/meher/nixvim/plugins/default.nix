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
         ./intellitab.nix
         ./zen-mode.nix
         ./which-key.nix
         ./twilight.nix
         ./treesitter.nix
         ./telescope.nix
         ./showkeys.nix
         ./rainbow.nix
         ./precognition.nix   
         ./lualine.nix
         ./neoscroll.nix
         ./nix.nix
         ./notify.nix
         ./nui.nix
         ./opencode.nix
         ./dashboard.nix
      ];
   };
}
