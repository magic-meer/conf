{ pkgs, ... }: {
  console = {
    font = "ter-132b";
    packages = [ pkgs.terminus_font ];
  };

  fonts.packages = with pkgs; [
    terminus_font
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nafees
    scheherazade-new
  ];
}
