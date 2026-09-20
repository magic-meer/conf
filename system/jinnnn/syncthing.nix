{
   config,
   ...
}: {
   services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "meher";
      group = "users";
      dataDir = "/home/meher/.local/share/syncthing";
      guiPasswordFile = config.age.secrets.syncthing-pass.path;
   settings = {
      gui.user = "meher";
   devices = {
      "balail" = { id = "LIZW3OF-4M55GVF-NUVOQYR-5PDBWAJ-FABKLVS-SNYUQH7-QENZ53C-N6X6KAZ"; };
      };
   folders = {
   "things" = {
      path = "/home/meher/things";
      devices = [ "balail" ];
      };
   "documents" = {
      path = "/home/meher/documents";
      devices = [ "balail" ];
   };
   };
   };
   };
}
