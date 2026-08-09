{
  pkgs,
  ...
}:
let
  # nvim-luxmotion is not packaged in nixpkgs yet — fetch the pinned commit.
  # (repo renamed upstream to whisk.nvim; require("luxmotion") still works as a shim,
  #  we use the current API directly)
  luxmotion = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-luxmotion";
    version = "2026-08-09";
    src = pkgs.fetchFromGitHub {
      owner = "LuxVim";
      repo = "nvim-luxmotion";
      rev = "a5d122ed7c08dcb8366ddc58b44df9458a263d23";
      sha256 = "1xggv3l9nw7q1m2p5f4mmrs0njag2358r9hk969pacqx84gp8p7g";
    };
  };
in {
  programs.nixvim = {
    extraPlugins = [ luxmotion ];

    extraConfigLua = ''
      require("whisk").setup({
        cursor = {
          duration = 150,
          easing = "ease-out",
          enabled = true,
        },
        scroll = {
          duration = 200,
          easing = "ease-out",
          enabled = true,
        },
        keymaps = {
          cursor = true,
          scroll = true,
        },
        performance = { enabled = true },
      })
    '';
  };
}