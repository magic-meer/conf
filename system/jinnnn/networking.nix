{systemName, config, ...}: {
  networking.hostName = systemName; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # OpenCode web server, accessible from LAN devices
  networking.firewall.allowedTCPPorts = [ config.services.opencode.port ];

  # Enable Bluetooth
  hardware.bluetooth = {
     enable = true;
     powerOnBoot = true;
  };

  services.pipewire = {
     enable = true;
     pulse.enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
  };
}
