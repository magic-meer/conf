{
  pkgs,
  ...
}:
let
  # homecoming.nvim is not packaged in nixpkgs yet — fetch the pinned commit
  homecoming = pkgs.vimUtils.buildVimPlugin {
    pname = "homecoming.nvim";
    version = "2026-08-09";
    src = pkgs.fetchFromGitHub {
      owner = "leo-alvarenga";
      repo = "homecoming.nvim";
      rev = "dcb904ddacdbd4443c13cab8cad812d2ae6a6a1e";
      sha256 = "1qpbc250biizbfzlrbcmy00p52lpybss0dmg4zls0wih17nhbmv5";
    };
  };
in {
  programs.nixvim = {
    extraPlugins = [ homecoming ];

    extraConfigLua = ''
      require("homecoming-nvim").setup({
        header = "  󰊠  ",
        header_centered = true,
        item_prefix_char = "  ",
        sections = {
          {
            title = "Actions",
            items = {
              { label = "Find File", action = "Telescope find_files" },
              { label = "Recent Files", action = "Telescope oldfiles" },
              { label = "New File", action = "enew" },
              {
                label = "Open Terminal",
                action = function()
                  vim.cmd("enew")
                  vim.cmd("terminal")
                  vim.cmd("startinsert")
                end,
              },
              { label = "Exit Nixvim", action = "ExitNixvim" },
            },
          },
        },
        footer = "vim is my home",
      })
    '';
  };
}