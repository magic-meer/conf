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
      "vimium-c@gdh1995.cn" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
        installation_mode = "force_installed";
      };

      # Zen Internet
      # The policy key is the add-on ID; only install_url takes the AMO slug,
      # AMO's /downloads/latest/ endpoint 404s on a braced GUID.
      "{91aa3897-2634-4a8a-9092-279db23a7689}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/zen-internet/latest.xpi";
        installation_mode = "force_installed";
      };

      # Ambient light for YouTube
      "{60493d8c-aec8-448e-a247-5d2cfa047d69}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ambient-light-for-youtube/latest.xpi";
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