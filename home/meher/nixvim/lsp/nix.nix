{ ... }: {
  programs.nixvim.lsp.servers.nixd = {
    enable = true;
    config = {
      nixd = {
        nixpkgs.expr = "import <nixpkgs> { }";
        formatting.command = [ "nixfmt" ];
        options = {
          nixos.expr = ''(builtins.getFlake (toString ./.)).nixosConfigurations.jinnnn.options'';
          home_manager.expr = ''(builtins.getFlake (toString ./.)).homeConfigurations."meher".options'';
        };
      };
    };
  };
}