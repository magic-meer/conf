{ pkgs, ... }:
{
  plugins.lsp.servers.basedpyright = {
    enable = true;
    package = pkgs.basedpyright;

    autostart = true;

    filetypes = [ "python" ];

    rootMarkers = [
      "pyproject.toml"
      "setup.py"
      "setup.cfg"
      "requirements.txt"
      "pyrightconfig.json"
      ".git"
    ];

    settings = {
      python = {
        analysis = {
          # balanced = type checks but skips the most pedantic rules.
          typeCheckingMode = "balanced";
          # Find all (sub)modules referenced in the workspace and index them,
          # without an explicit extraPaths. Combined with venvPath below this
          # makes venv end-to-end with zero per-project setup.
          autoSearchPaths = true;
          useLibraryCodeForTypes = true;
          diagnosticMode = "openFilesOnly";
        };
        # Auto-detect a virtualenv: basedpyright looks for `venv`/`.venv`
        # inside the workspace root and activates it automatically.
        venvPath = ".";
      };
    };
  };
}
