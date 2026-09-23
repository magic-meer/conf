{ inputs, ... }:

let
  sharedPlugins = {
    "ponytail" = inputs.ponytail;
    "superpowers" = inputs.superpowers;
    "impeccable" = inputs.impeccable;
  };

  sharedSkills = {
    "linkedin-agent" = inputs.linkedin-agent;
  };

  mapPluginsToTool = basePath:
    builtins.mapAttrs' (name: src: { name = "${basePath}/plugins/${name}"; value = { source = src; }; }) sharedPlugins;

  mapSkillsToTool = basePath:
    builtins.mapAttrs' (name: src: { name = "${basePath}/skills/${name}"; value = { source = src; }; }) sharedSkills;

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
