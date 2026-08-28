{ ... }: {
  programs.zen-browser.profiles.default = {
    id = 0;
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
    };
    mods = [
      "642854b5-88b4-4c40-b256-e035532109df"
    ];
  };

  programs.zen-browser.profiles.School = {
    id = 2;
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
      "642854b5-88b4-4c40-b256-e035532109df"
    ];
  };
}