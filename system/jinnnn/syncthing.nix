{
   config,
   ...
}: {
   services.syncthing = {
      enable = true;
      opendefaultPorts = true;
      guiPasswordFile = config.age.secrets.meher-default-pass.path;
   setttings = {
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
