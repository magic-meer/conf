{
  userName,
  ...
}: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";

    daemon.settings = {
      ipv6 = true;
      experimental = true;
      "userland-proxy" = false;
    };

    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        ipv6 = true;
        experimental = true;
        "userland-proxy" = false;
      };
    };
  };
}