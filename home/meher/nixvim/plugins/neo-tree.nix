{
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = true;
      window = {
        # sidebar on the right so the code buffer stays put
        position = "right";
        mappings = {
          # superfile-style tree
          h = "close_node";            # collapse / go up

          # open in a NEW TAB and go there
          l = "open_tabnew";
          "<enter>" = "open_tabnew";
          o = "open_tabnew";

          # open in a SPLIT (focus moves to it) — the shift variants
          "<S-l>" = "open_vsplit";
          "<S-enter>" = "open_vsplit";
          "<S-o>" = "open_vsplit";

          "." = "toggle_hidden";       # show / hide hidden files
          r = "rename";                # rename file/folder
          a = "add";                   # create new file
          A = "add_directory";         # create new folder
          D = "delete";                # delete file/folder (asks first)
          y = "copy";                  # copy to neo-tree clipboard (own buffer)
          x = "cut";                   # cut to neo-tree clipboard (own buffer)
          p = "paste_from_clipboard";  # paste
          # "t" = open in a background tab, "<S-t>" = open in a background
          # split, "d" = trash, "u" = undo, "I" = info — buffer keymaps in
          # commands.nix (they need lua callbacks)
        };
      };
      filesystem.follow_current_file.enabled = true;
    };
  };
}