{ config, lib, ... }:
let
  # Live path to this repo's quickshell config (NOT the nix store).
  # We hardcode the flake checkout path on purpose: `./shell` would resolve
  # to the read-only nix store source at eval time, which breaks quickshell's
  # hot reload (it watches files for changes and store paths can't be edited).
  liveShell = "${config.home.homeDirectory}/nixconfig/home/meher/quickshell/shell";
in {
  # Symlink the config directly to the live source dir instead of copying it
  # into the nix store, so editing these files hot-reloads the shell via
  # `qs -c shell` (config dir: ~/.config/quickshell/shell/shell.qml).
  xdg.configFile."quickshell/shell" = {
    source = config.lib.file.mkOutOfStoreSymlink liveShell;
  };
}