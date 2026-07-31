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
    passes = 2;
    offset = 2;
    noise = 0.02;
    saturation = 1.2;
  };

  background-effect = children: kdl.node "background-effect" [ ] children;
  blur-behind = background-effect [
    (kdl.leaf "blur" true)
    (kdl.leaf "xray" false)
  ];

  rules = [
    (kdl.node "window-rule" [ ] [
      blur-behind
      (kdl.leaf "draw-border-with-background" false)
    ])
    (kdl.node "layer-rule" [ ] [
      (kdl.node "match" { layer = "overlay"; } [ ])
      blur-behind
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
