{
  pkgs,
  ...
}: {
  programs.nixvim = {
    # not packaged in nixpkgs, so fetch it directly
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "legendary.nvim";
        version = "v2.13.13";
        # require-check fails only on optional deps (sqlite.lua for
        # frecency sorting, vimdoc-gen for doc generation)
        doCheck = false;
        src = pkgs.fetchFromGitHub {
          owner = "mrjones2014";
          repo = "legendary.nvim";
          rev = "v2.13.13";
          sha256 = "13kvz35jx3frp23warl9mvarjql39srfl4dzrn3hqal6ch4zks0b";
        };
      })
    ];

    # dynamic cheatsheet: picks up every which-key registration
    # automatically, so keymap changes show up without extra work
    extraConfigLua = ''
      require('legendary').setup({
        extensions = {
          which_key = {
            auto_register = true,
          },
        },
      })
    '';
  };
}
