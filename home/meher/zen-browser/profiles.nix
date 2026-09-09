{ ... }: {
  programs.zen-browser.profiles.default = {
    id = 0;
    path = "tumg9xef.Default Profile";
    isDefault = true;
    pinsForce = true;
    pinsForceAction = "remove";
    pins = {
      "Fiverr Dashboard" = {
        id = "c89c3a3b-9d0d-43bd-a8d2-dd7af68b900b";
        url = "https://www.fiverr.com/users/themeerop/seller_dashboard";
        isEssential = true;
        position = 1;
      };
      "Gmail Personal" = {
        id = "2ad8e2c8-63cd-4cb9-844f-aa3027dd7bf7";
        url = "https://mail.google.com";
        isEssential = true;
        position = 2;
      };
      "opencode" = {
        id = "befeb72b-2bc0-40c1-aec6-5057b7739164";
        url = "http://localhost:4096/";
        isEssential = true;
        position = 3;
      };
      "syncthing" = {
        id = "dc24eb67-0213-41bc-b87e-8c9fdeb38f22";
        url = "http://127.0.0.1:8384/";
        isEssential = true;
        position = 4;
      };
      "WhatsApp" = {
        id = "1eb28d99-6100-4c6b-a087-8a574aa6bfeb";
        url = "https://web.whatsapp.com";
        isEssential = true;
        position = 5;
      };
      "Hermes" = {
        id = "488dd2e3-9b75-4f9d-bd04-c6410722e124";
        url = "http://127.0.0.1:9119/";
        isEssential = true;
        position = 6;
      };
    };
    mods = [
      "642854b5-88b4-4c40-b256-e035532109df"  # Transparent Zen
      "bc25808c-a012-4c0d-ad9a-aa86be616019"  # sleekborder
      "f7c71d9a-bce2-420f-ae44-a64bd92975ab"  # betterunloadedtabs
      "72f8f48d-86b9-4487-acea-eb4977b18f21"  # betterctrltab menu
      "906c6915-5677-48ff-9bfc-096a02a72379"  # floating status bar
      "5941aefd-67b0-453d-9b62-9071a31cbb0d"  # smaller compact mode
      "c8d9e6e6-e702-4e15-8972-3596e57cf398"  # zen back forward
      "f4866f39-cfd6-4498-ab92-54213b8279dc"  # AnimationPlus
      "87196c08-8ca1-4848-b13b-7ea41ee830e7"  # enhanced tab preview
    ];
  };

  programs.zen-browser.profiles.School = {
    id = 1;
    pinsForce = true;
    pinsForceAction = "remove";
    pins = {
      "Gmail School" = {
        id = "c3d44307-dd7f-4ee2-89a4-2b09bb84d4f0";
        url = "https://mail.google.com";
        isEssential = true;
        position = 1;
      };
    };
    mods = [
      "642854b5-88b4-4c40-b256-e035532109df"  # Transparent Zen
      "bc25808c-a012-4c0d-ad9a-aa86be616019"  # sleekborder
      "f7c71d9a-bce2-420f-ae44-a64bd92975ab"  # betterunloadedtabs
      "72f8f48d-86b9-4487-acea-eb4977b18f21"  # betterctrltab menu
      "906c6915-5677-48ff-9bfc-096a02a72379"  # floating status bar
      "5941aefd-67b0-453d-9b62-9071a31cbb0d"  # smaller compact mode
      "c8d9e6e6-e702-4e15-8972-3596e57cf398"  # zen back forward
      "f4866f39-cfd6-4498-ab92-54213b8279dc"  # AnimationPlus
      "87196c08-8ca1-4848-b13b-7ea41ee830e7"  # enhanced tab preview
    ];
  };
}
