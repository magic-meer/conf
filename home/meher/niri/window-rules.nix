{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  niri-src = inputs.niri;
  kdl = import "${niri-src}/kdl.nix" { inherit lib; };
  settings = import "${niri-src}/settings.nix" {
    inherit kdl lib;
    inputs = {
      niri-stable = niri-src.inputs.niri-stable;
      niri-unstable = niri-src.inputs.niri-unstable;
    };
    docs = null;
    binds = null;
    settings = null;
  };

  blur = {
    passes = 4;
    offset = 6;
    noise = 0;
    saturation = 1;
  };

  background-effect = children: kdl.node "background-effect" [ ] children;
  blur-behind = background-effect [
    (kdl.leaf "blur" true)
    (kdl.leaf "xray" false)
  ];

  # rounded window corners; clip-to-geometry applies the radius to the
  # actual window surface instead of just the decorations
  corners = kdl.leaf "geometry-corner-radius" 12.0;

  rules = [
    (kdl.node "window-rule" [ ] [
      (kdl.leaf "open-floating" true)
    ])
    (kdl.node "window-rule" [ ] [
      corners
      (kdl.leaf "clip-to-geometry" true)
      blur-behind
      (kdl.leaf "draw-border-with-background" false)
    ])
    (kdl.node "layer-rule" [ ] [
      (kdl.node "match" { layer = "overlay"; } [ ])
      blur-behind
    ])
    # waybar sits on the "top" layer, so blur its cards explicitly
    (kdl.node "layer-rule" [ ] [
      (kdl.node "match" { namespace = "^waybar$"; } [ ])
      blur-behind
    ])

    # terminal apps launched at startup: size + position them around the screen
    (kdl.node "window-rule" [ ] [
      (kdl.node "match" { app-id = "^peaclock$"; } [ ])
      (kdl.node "default-column-width" [ ] [ (kdl.leaf "fixed" 500) ])
      (kdl.node "default-window-height" [ ] [ (kdl.leaf "fixed" 300) ])
      (kdl.node "default-floating-position" { x = 16; y = 16; relative-to = "top-left"; } [ ])
    ])
    (kdl.node "window-rule" [ ] [
      (kdl.node "match" { app-id = "^cava$"; } [ ])
      (kdl.node "default-column-width" [ ] [ (kdl.leaf "fixed" 500) ])
      (kdl.node "default-window-height" [ ] [ (kdl.leaf "fixed" 300) ])
      (kdl.node "default-floating-position" { x = 16; y = 16; relative-to = "top-right"; } [ ])
    ])
    (kdl.node "window-rule" [ ] [
      (kdl.node "match" { app-id = "^cmatrix$"; } [ ])
      (kdl.node "default-column-width" [ ] [ (kdl.leaf "fixed" 500) ])
      (kdl.node "default-window-height" [ ] [ (kdl.leaf "fixed" 300) ])
      (kdl.node "default-floating-position" { x = 16; y = 16; relative-to = "bottom-left"; } [ ])
    ])
    (kdl.node "window-rule" [ ] [
      (kdl.node "match" { app-id = "^pipes$"; } [ ])
      (kdl.node "default-column-width" [ ] [ (kdl.leaf "fixed" 500) ])
      (kdl.node "default-window-height" [ ] [ (kdl.leaf "fixed" 300) ])
      (kdl.node "default-floating-position" { x = 16; y = 16; relative-to = "bottom-right"; } [ ])
    ])
  ];
in {
  programs.niri.package = pkgs.niri;

  programs.niri.config =
    (settings.render config.programs.niri.settings)
    ++ rules
    ++ [
      (kdl.node "blur" [ ] [
        (kdl.leaf "passes" blur.passes)
        (kdl.leaf "offset" blur.offset)
        (kdl.leaf "noise" blur.noise)
        (kdl.leaf "saturation" blur.saturation)
      ])
    ];
}
