{ inputs, lib, ... }:

let
  sharedPlugins = {
    "ponytail" = inputs.ponytail;
    "superpowers" = inputs.superpowers;
    "impeccable" = inputs.impeccable;
  };

  sharedSkills = {
    "linkedin-agent" = inputs.linkedin-agent;
    "qpdf-pdf-ops" = inputs.qpdf-pdf-ops;
  };

  mapPluginsToTool = basePath:
    lib.mapAttrs' (name: src: { name = "${basePath}/plugins/${name}"; value = { source = src; }; }) sharedPlugins;

  mapSkillsToTool = basePath:
    lib.mapAttrs' (name: src: { name = "${basePath}/skills/${name}"; value = { source = src; }; }) sharedSkills;

in
{
  home.file =
    # Antigravity
    (mapPluginsToTool ".gemini/config") //
    (mapSkillsToTool ".gemini/config") //

    # OpenCode
    (mapPluginsToTool ".opencode") //
    (mapSkillsToTool ".opencode") //

    # Hermes
    (mapPluginsToTool ".hermes") //
    (mapSkillsToTool ".hermes") //

    # Standard .agents directory for future tools
    (mapPluginsToTool ".agents") //
    (mapSkillsToTool ".agents");
}
