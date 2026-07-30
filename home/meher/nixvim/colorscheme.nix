{ ... }: {
  programs.nixvim.colorschemes.gruvbox = {
    enable = true;
    settings = {
      italic = true;
      bold = true;
      contrast = "hard";
    };
  };
}
