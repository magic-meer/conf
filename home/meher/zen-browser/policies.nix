{ pkgs, ... }: {
  programs.zen-browser.policies = {
    ExtensionSettings = {
      # KeepassXC Browser
      "keepassxc-browser@keepassxc.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser@keepassxc.org/latest.xpi";
        installation_mode = "force_installed";
        managed_storage = {
          settings = {
            autoFillSingleEntry = true;
            autoRetrieveCredentials = true;
            connectionMethod = "nativemessaging";
            showLoginFormIcon = true;
            showOTPIcon = true;
            showNotifications = true;
          };
        };
      };

      # Dark Reader
      "addon@darkreader.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/addon@darkreader.org/latest.xpi";
        installation_mode = "force_installed";
        managed_storage = {
          enabled = true;
          enableForProtectedPages = true;
          enabledByDefault = true;
        };
      };

      # uBlock Origin
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
        managed_storage = {
          toOverwrite = {
            filterLists = [
              "user-filters"
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-unbreak"
              "adguard-spyware-url"
            ];
          };
        };
      };

      # Vimium C
      "vimium-c@gdh1995" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
        installation_mode = "force_installed";
        managed_storage = {
          blacklist = [ "monkeytype.com" ];
        };
      };

      # Zen Internet
      "{91aa3897-2634-4a8a-9092-279db23a7689}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/{91aa3897-2634-4a8a-9092-279db23a7689}/latest.xpi";
        installation_mode = "force_installed";
      };

      # UltraScreen (Screenshot)
      "ultrascreen@addon.one" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ultrascreen/latest.xpi";
        installation_mode = "force_installed";
      };
    };
  };
}