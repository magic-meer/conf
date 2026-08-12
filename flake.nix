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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode.url = "github:GutMutCode/opencode-nix";

    windscribe-nixos = {
      url = "github:Varmisanth/windscribe-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    zen-browser,
    niri,
    opencode,
    windscribe-nixos,
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
	  nixvim.nixosModules.nixvim
          ./system/${systemName}/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.${userName} = import ./home/${userName};
            home-manager.backupFileExtension = "home.backup";
          }
        ];
      };
    };
}
