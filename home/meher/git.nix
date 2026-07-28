{
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Meher Ali";
        email = "meherali.meer@gmail.com";
      };
    };
    # init.defaultBranch = "main";
    aliases = {
      ci = "commit";
      com = "commit -m";
      co = "checkout";
      s = "status";
      ad = "add .";
    };
  };
}
