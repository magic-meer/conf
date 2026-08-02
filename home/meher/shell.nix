{
  ...
}: {
  home.shellAliases = {
    ll = "ls -l";
    la = "ls -al";
    lh = "ls -h";
    lha = "ls -alh";
    cdd = "cd ..";
    update = "sudo nixos-rebuild switch --flake ~/nixconfig#jinnnn";
    gita = "git add .";
    gitc = "git commit -m";
    gits = "git status";
    vi = "nvim";
    vim = "nvim";
      hibernate = "systemctl hibernate";
  };
}
