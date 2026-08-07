{
  userName,
  ...
}: {
  programs.windscribe = {
    enable = true;
    users = [ "${userName}" ];
    app.autoStart = false;
  };
}