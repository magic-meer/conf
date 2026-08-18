{ 
   inputs,
   ...
}: {
   
imports = [
       # ./colorscheme.nix
       ./options.nix
       # ./keybinds.nix
       # ./commands.nix
       # ./wildmenu.nix
       ./plugins
       ./lsp
    ];

   programs.nixvim = {
      enable = true;
      defaultEditor = true;
   };
}
