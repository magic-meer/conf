{
  description = "Yet another dumb things of mine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    zen-browser,
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

        modules = [
          ./system/${systemName}/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${userName} = import ./home/${userName};
          }
        ];
      };
    };
}
