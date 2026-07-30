{
  pkgs,
  ...
}:

let
  inherit (pkgs) lib;

  generateIni = sections:
    lib.concatStringsSep "\n\n" (lib.mapAttrsToList (sectionName: values:
      let
        kvps = lib.mapAttrsToList (key: value:
          if lib.isList value then
            "${key}=${lib.concatStringsSep " " (map toString value)}"
          else if value == true then
            "${key}=yes"
          else if value == false then
            "${key}=no"
          else
            "${key}=${toString value}"
        ) values;
      in
      "[${sectionName}]\n" + lib.concatStringsSep "\n" kvps
    ) (lib.filterAttrs (_: v: v != {}) sections));

  keybinds = import ./keybinds.nix;

  allSections =
    if keybinds == {}
    then footConfig
    else footConfig // { "key-bindings" = keybinds; };

  footConfig = {
    main = {
      font = "JetBrainsMono Nerd Font:size=11";
      line-height = "14";
      letter-spacing = "1px";
      pad = "8x8 center";
      initial-window-size-chars = "100x30";
      initial-window-mode = "windowed";
      dpi-aware = "yes";
    };
    cursor = {
      style = "underline";
      blink = true;
      blink-rate = 500;
    };
    mouse = {
      hide-when-typing = true;
      alternate-scroll-mode = true;
    };
    csd = {
      preferred = "none";
      size = 0;
      border-width = 0;
    };
    "colors-dark" = {
      alpha = "0.35";
      blur = true;
    };
  };
in {
  xdg.configFile."foot/foot.ini".text = generateIni allSections;
}
