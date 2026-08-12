{ ... }: {
   programs.nixvim.plugins = {
      imports = [
         ./actions-preview.nix
	 ./blink-indent.nix
      ];
   };
}
