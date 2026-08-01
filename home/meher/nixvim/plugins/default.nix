{ config, ... }: {
  imports = [
    ./lsp-status.nix
    ./nvim-lightbulb.nix
    ./lsp-signature.nix
    ./goto-preview.nix
    ./actions-preview.nix
    ./lsp-progress.nix
    ./trouble.nix
    ./wtf.nix
    ./lsp-lines.nix
    ./coq-nvim.nix
    ./opencode.nix
    ./luasnip.nix
    ./telescope.nix
    ./neo-tree.nix
    ./project-nvim.nix
    ./colorizer.nix
    ./twilight.nix
    ./vimade.nix
    ./clipboard-image.nix
    ./alpha.nix
    ./noice.nix
    ./which-key.nix
    ./neoscroll.nix
    ./smear-cursor.nix
    ./mini.nix
    ./legendary.nix

    # alternatives for plugins not available in nixvim
    ./mkdnflow.nix
    ./fzf-lua.nix
    ./neoclip.nix
    ./harpoon.nix
    ./codesnap.nix
    ./direnv.nix
    ./flash.nix
    ./undotree.nix
    ./toggleterm.nix

    # python IDE
    ./lz-n.nix
    ./python-lsp.nix
    ./venv-selector.nix
    ./dap.nix
    ./iron.nix
  ];

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

    plugins.nvim-autopairs.enable = true;
    plugins.gitsigns.enable = true;
    plugins.bufferline.enable = true;
    # DISABLED: collides with neo-tree (both file explorers) — neo-tree wins
    # plugins.nvim-tree.enable = true;
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
