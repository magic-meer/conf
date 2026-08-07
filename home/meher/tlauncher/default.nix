{
  pkgs,
  config,
  lib,
  ...
}:

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

  # Read-only game assets, symlinked into the minecraft game dir so they are
  # managed declaratively here and removed/updated on rebuild.
  home.file.".minecraft/mods".source = ./mods;
  home.file.".minecraft/resourcepacks".source = ./resourcepacks;
  home.file.".minecraft/shaderpacks".source = ./shaderpacks;

  # Worlds must stay writable, so `saves` links straight back to this repo
  # folder instead of the (read-only) nix store.
  home.activation.linkTlauncherSaves = lib.hm.dag.entryAfter [
    "linkGeneration"
  ] ''
    repoDir="${config.home.homeDirectory}/nixconfig/home/meher/tlauncher/saves"
    target="${config.home.homeDirectory}/.minecraft/saves"

    $DRY_RUN_CMD mkdir -p "$repoDir"
    if [[ ! -L "$target" && -e "$target" ]]; then
      $DRY_RUN_CMD mv "$target" "$target.home-backup.$(date +%s)"
    fi
    $DRY_RUN_CMD ln -sfn "$repoDir" "$target"
  '';

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
