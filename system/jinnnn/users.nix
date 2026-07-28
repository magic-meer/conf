{pkgs, userName ...}: {
  users.users.${userName} = {
    isNormalUser = true;
    description = "Meher Ali";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.fish; ##reserarch if this sets fish as login shell, setting fish as login shell is dangerous!!
  };
}
