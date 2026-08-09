{ ... }: {
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
    ./homecoming.nix
    ./noice.nix
    ./which-key.nix
    ./luxmotion.nix
    ./smear-cursor.nix
    ./mini.nix
    ./legendary.nix
    ./transparent.nix
    ./treesitter.nix
    ./autopairs.nix
    ./gitsigns.nix
    ./bufferline.nix
    ./web-devicons.nix

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

    # python tooling
    ./lz-n.nix
    ./venv-selector.nix
    ./dap.nix
    ./iron.nix
  ];

  programs.nixvim.nixpkgs.config.allowUnfree = true;
}