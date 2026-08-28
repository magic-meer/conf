{ ... }: {
  programs.nixvim.keymaps = let
    # Helper function to create keymaps with less boilerplate
    # Usage: map "n" "<leader>e" ":Neotree toggle<CR>" "Toggle file tree"
    map = mode: key: action: desc:
      {
        mode = mode;
        key = key;
        action = action;
        options = { desc = desc; };
      };

    # Convenience wrappers for common modes
    nmap = key: action: desc: map "n" key action desc;
    vmap = key: action: desc: map "v" key action desc;
    imap = key: action: desc: map "i" key action desc;
    xmap = key: action: desc: map "x" key action desc;
    omap = key: action: desc: map "o" key action desc;
    tmap = key: action: desc: map "t" key action desc;
  in [
    # File explorer
    (nmap "<leader>e" "<cmd>Neotree toggle<CR>" "Toggle file tree")
  ];
}