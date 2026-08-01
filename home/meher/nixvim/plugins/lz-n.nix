{ ... }: {
  # Lazy-loading provider (lz.n) — routes the config of plugins with
  # lazyLoad.enable = true into specs loaded on ft/cmd/keys triggers
  programs.nixvim.plugins.lz-n.enable = true;
}
