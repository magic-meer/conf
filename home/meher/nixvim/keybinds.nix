{ ... }: {
  programs.nixvim.keymaps = let
    # Helper function to create keymaps with less boilerplate
    # Usage: map "n" "<leader>e" ":Neotree toggle<CR>" "Toggle file tree"
    map = mode: lhs: rhs: desc:
      {
        mode = mode;
        lhs = lhs;
        rhs = rhs;
        opts = { desc = desc; };
      };

    # Convenience wrappers for common modes
    nmap = lhs: rhs: desc: map "n" lhs rhs desc;
    vmap = lhs: rhs: desc: map "v" lhs rhs desc;
    imap = lhs: rhs: desc: map "i" lhs rhs desc;
    xmap = lhs: rhs: desc: map "x" lhs rhs desc;
    omap = lhs: rhs: desc: map "o" lhs rhs desc;
    tmap = lhs: rhs: desc: map "t" lhs rhs desc;
  in [
    # File explorer
    (nmap "<leader>e" "<cmd>Neotree toggle<CR>" "Toggle file tree")
  ];
}