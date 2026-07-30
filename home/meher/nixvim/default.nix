{ 
   inputs,
   ...
}: {
   
   imports = [
      inputs.nixvim.homeModules.nixvim
      ./colorscheme.nix
      ./options.nix
      ./keybinds.nix
      ./plugins
   ];

   programs.nixvim = {
      enable = true;
      defaultEditor = true;
   };
}
