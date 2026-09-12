{
  inputs,
  config,
  lib,
  ...
}:
let
  niri-src = inputs.niri;
  kdl = import "${niri-src}/kdl.nix" { inherit lib; };

  # Startup windows on the first workspace.
  #
  # Each entry spawns an app at login, as a floating window at the given
  # size and screen position. To add/remove an app, edit this list.
  #
  # Fields per app:
  #   name     - app-id used for matching the window rule. For terminal apps
  #              this is also the program run inside foot, unless `program`
  #              is given.
  #   type     - "terminal" (runs in a foot window) or "gui" (launched directly)
  #   width/height - window size in logical pixels
  #   position - screen edge/corner to anchor to: top-left, top-right,
  #              bottom-left, bottom-right, top, bottom, left, right
  #   margin   - gap (px) from the anchored edge/corner (default 16)
  startupApps = [
    {
      name = "peaclock";
      type = "terminal";
      width = 500;
      height = 300;
      position = "top-left";
    }
    {
      name = "cava";
      type = "terminal";
      width = 500;
      height = 300;
      position = "top-right";
    }
    {
      name = "cmatrix";
      type = "terminal";
      width = 500;
      height = 300;
      position = "bottom-left";
    }
    {
      name = "pipes";
      type = "terminal";
      width = 500;
      height = 300;
      position = "bottom-right";
    }
  ];

  # Spawn the app. Terminal apps start in foot pre-sized to the target window
  # size so niri does not have to resize the window after the app (e.g.
  # cmatrix, which cannot handle live resizes) has started.
  mkSpawn =
    app:
    if app.type == "terminal" then
      {
        argv = [
          "foot"
          "--app-id"
          app.name
          "--window-size-pixels=${toString app.width}x${toString app.height}"
          (app.program or app.name)
        ];
      }
    else
      { argv = [ app.name ]; };

  # Size + anchor the floating window once it opens.
  mkRule = app:
    kdl.node "window-rule" [ ] [
      (kdl.node "match" { app-id = "^${app.name}$"; } [ ])
      (kdl.node "default-column-width" [ ] [ (kdl.leaf "fixed" app.width) ])
      (kdl.node "default-window-height" [ ] [ (kdl.leaf "fixed" app.height) ])
      (kdl.node "default-floating-position" {
        x = app.margin or 16;
        y = app.margin or 16;
        relative-to = app.position;
      } [ ])
    ];

  rules = map mkRule startupApps;
in {
  programs.niri.settings.spawn-at-startup = lib.mkAfter (map mkSpawn startupApps);
  programs.niri.config = lib.mkAfter rules;
}