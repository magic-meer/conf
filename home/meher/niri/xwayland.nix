{
  inputs,
  pkgs,
  ...
}: {
  programs.niri.settings.xwayland-satellite = {
    enable = true;
    path = "${inputs.niri.packages.${pkgs.system}.xwayland-satellite-unstable}/bin/xwayland-satellite";
  };
}