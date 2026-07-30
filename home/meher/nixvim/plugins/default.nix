{ config, ... }: {
  programs.nixvim = {
    nixpkgs.config.allowUnfree = true;

    plugins.lualine.enable = true;

    plugins.transparent.enable = true;

    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      folding.enable = false;
    };

    plugins.telescope.enable = true;
    plugins.which-key.enable = true;
    plugins.nvim-autopairs.enable = true;
    plugins.gitsigns.enable = true;
    plugins.bufferline.enable = true;
    plugins.nvim-tree.enable = true;
    plugins.web-devicons.enable = true;

    lsp.servers.nixd = {
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
  };
}
