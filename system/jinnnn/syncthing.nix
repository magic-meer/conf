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
      "balail" = { id = "ZYGZK2F-3HFWTY4-7OOTCUB-N72WOUQ-YNCRGSR-ULKJMTR-V63HYGR-N23XYA5"; };
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
