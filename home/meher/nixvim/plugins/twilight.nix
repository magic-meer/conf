{ ... }: {
   plugins.twilight = {
      enable = true;
   };

   # Dim code outside the active region by default (runs after setup()).
   extraConfigLua = ''
      require("twilight").enable()
   '';
}