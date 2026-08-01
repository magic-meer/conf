{
  pkgs,
  ...
}:
let
  # venv-selector.nvim is not packaged in nixpkgs 26.05 — fetch the pinned commit
  venv-selector = pkgs.vimUtils.buildVimPlugin {
    pname = "venv-selector.nvim";
    version = "2026-05-20";
    src = pkgs.fetchFromGitHub {
      owner = "linux-cultist";
      repo = "venv-selector.nvim";
      rev = "cc4bb3975de8835291f9bb45889e96c6b2795fc4";
      sha256 = "119x37qxvy2b6l295x0czffkwivx4gm0rwnc8pz7gqhfzfx4jr7q";
    };
  };
in {
  programs.nixvim.plugins.venv-selector = {
    enable = true;
    package = venv-selector;

    # On a .py file: detect the project venv and share it with pyright + dap
    settings = {
      name = [ "venv" ".venv" ];
      dap_enabled = true;
      options = {
        set_environment_variables = true;
        enable_cached_venvs = true;
        cached_venv_automatic_activation = true;
        activate_venv_in_terminal = true;
        notify_user_on_venv_activation = true;
      };
    };

    # Python tooling loads lazily — only when opening a python file
    lazyLoad = {
      enable = true;
      settings = {
        ft = [ "python" ];
        keys = [
          {
            __unkeyed-1 = "<leader>pv";
            __unkeyed-3 = "<cmd>VenvSelect<CR>";
            desc = "Select python venv";
          }
        ];
      };
    };
  };
}
