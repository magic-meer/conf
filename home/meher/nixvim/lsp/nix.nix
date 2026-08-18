{ ... }:
{
  plugins.lsp.servers.nixd = {
    enable = true;
    package = pkgs.nixd;

    autostart = true;

    filetypes = [ "nix" ];

    rootMarkers = [ "flake.nix" ".git" ];

    settings = {
      nixd = {
        nixpkgs = {
          expr = "import <nixpkgs> { }";
        };

        formatting = {
          command = [ "nixfmt" ];
        };

        options = {
          nixos = {
            expr = '(builtins.getFlake (toString ./.)).nixosConfigurations.<hostname>.options';
          };

          home-manager = {
            expr = '(builtins.getFlake (toString ./.)).homeConfigurations."<username>@<hostname>".options';
          };
        };
      };
    };

    extraOptions = {
      "offset_encoding" = "utf-8";
    };
  };
}