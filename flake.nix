{
  description = "Yet another dumb things of mine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Stable fallback
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    niri.url = "github:sodiboo/niri-flake";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

      stylix = {
         url = "github:nix-community/stylix";
         inputs.nixpkgs.follows = "nixpkgs";
      };

    nixvim = {
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
            nixpkgs.follows = "nixpkgs";
            home-manager.follows = "home-manager";
         };
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode.url = "github:GutMutCode/opencode-nix";

    windscribe-nixos = {
      url = "github:Varmisanth/windscribe-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
   };

   nix-cursors.url = "github:LilleAila/nix-cursors";
};


  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    agenix,
    zen-browser,
    firefox-addons,
    niri,
    opencode,
    windscribe-nixos,
      stylix,
    nix-cursors,
    ...
  }@inputs:
    let
      system = "x86_64-linux";
      systemName = "jinnnn";
      userName = "meher";
    in {
      nixosConfigurations.${systemName} = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs userName systemName;
        };

        # nixpkgs.overlays = [ opencode.overlays.default ];

        modules = [
          windscribe-nixos.nixosModules.windscribe
          ./system/${systemName}/default.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
               stylix.nixosModules.stylix

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
              users.${userName} = import ./home/${userName};
              backupFileExtension = "home.backup";
            };
          }
        ];
      };
    };
}
