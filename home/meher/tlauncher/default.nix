{ pkgs, ... }:

{
  home.file.".local/share/tlauncher/TLauncher.jar".source =
    ./TLauncher.jar;

  home.file.".local/bin/tlauncher" = {
    executable = true;

    text = ''
      #!/usr/bin/env bash

      exec ${pkgs.steam-run}/bin/steam-run \
        ${pkgs.jdk}/bin/java \
        -jar "$HOME/.local/share/tlauncher/TLauncher.jar" "$@"
    '';
  };

  xdg.dataFile."applications/tlauncher.desktop".text = ''
    [Desktop Entry]
    Name=TLauncher
    Comment=Minecraft Launcher
    Exec=/home/meher/.local/bin/tlauncher
    Terminal=false
    Type=Application
    Categories=Game;
  '';
}
