{
   ...
}: {
   services.openssh = {
      enable = true;

      settings = {
         PasswordAuthentication = false;
         # PermitRootlogin = false;
         MaxAuthTries = 2;
      };
   };
}
