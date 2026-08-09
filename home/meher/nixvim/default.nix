{ 
   inputs,
   ...
}: {
   
   imports = [
      inputs.nixvim.homeModules.nixvim
      ./colorscheme.nix
      ./options.nix
      ./keybinds.nix
      ./commands.nix
      ./plugins
      ./lsp
   ];

   programs.nixvim = {
      enable = true;
      defaultEditor = true;
   };
}
