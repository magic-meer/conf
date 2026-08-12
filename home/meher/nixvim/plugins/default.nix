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
      ];
   };
}
