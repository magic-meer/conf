{ ... }: {
   plugins.blink-cmp = {
      enable = true;
      setupLspCapabilities = true;
      settings.sources.default = [
         "lsp"
	 "ripgrep"
	 "path"
	 "buffer"
      ];
   };
}
