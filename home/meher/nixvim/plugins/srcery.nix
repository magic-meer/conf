{ pkgs, ... }: {
  extraPlugins = [ pkgs.vimPlugins.srcery-vim ];
  colorscheme = "srcery";
}
