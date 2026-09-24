{ pkgs, ... }: {
  # Roslyn-based LSP server for C#. Self-contained package from nixpkgs, so the
  # binary is available to nvim without needing a .NET SDK installed globally.
  plugins.lsp.servers.csharp_ls = {
    enable = true;
    package = pkgs.csharp-ls;
    autostart = true;
    filetypes = [ "cs" ];
  };
}