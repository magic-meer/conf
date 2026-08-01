{ ... }: {
  # ALTERNATIVE for dotenv (load per-directory environment variables)
  programs.nixvim.plugins.direnv.enable = true;
}
