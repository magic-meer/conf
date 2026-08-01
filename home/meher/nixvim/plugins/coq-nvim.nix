{ ... }: {
  # Fast completion engine. Wraps every LSP server (incl. nixd) with coq capabilities.
  programs.nixvim.plugins.coq-nvim = {
    enable = true;
    installArtifacts = true;
    settings = {
      auto_start = "shut-up";
      keymap.recommended = true;
      completion.always = true;
    };
  };

  # coq_nvim runs `python3_host_prog -m coq`, so its python deps must be in the
  # nvim python3 provider env. Without these you get:
  #   No module named 'pynvim_pp'
  programs.nixvim.extraPython3Packages = ps: [
    ps.pynvim-pp
    ps.pyyaml
    ps.std2
  ];
}
