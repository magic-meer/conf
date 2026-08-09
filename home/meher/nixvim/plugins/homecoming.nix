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

    # homecoming ships a sensible default config (header, Actions/Resources
    # sections, footer) — no overrides needed
    extraConfigLua = ''
      require("homecoming-nvim").setup()
    '';
  };
}