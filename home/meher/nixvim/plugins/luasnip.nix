{ ... }: {
  # Snippet engine. coq_nvim picks it up through vim.snippet.
  programs.nixvim.plugins.luasnip = {
    enable = true;
    fromVscode = [ { } ];
    settings.enable_autosnippets = true;
  };
}
