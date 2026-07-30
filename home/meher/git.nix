{ ... }: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Meher Ali";
        email = "meherali.meer@gmail.com";
      };
      alias = {
        ci = "commit";
        com = "commit -m";
        co = "checkout";
        s = "status";
        ad = "add .";
      };
    };
  };
}
