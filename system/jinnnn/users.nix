{
  pkgs,
  userName,
  ...
}: {
  users.users.${userName} = {
    isNormalUser = true;
    description = "Meher Ali";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.fish; ##reserarch if this sets fish as login shell, setting fish as login shell is dangerous!!
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
    linger = true;
  };
}
