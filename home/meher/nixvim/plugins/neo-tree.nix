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
          l = "open_tabnew";           # open: enter folders, files → new tab
          h = "close_node";            # collapse / go up
          "<enter>" = "open_tabnew";   # same as l
          "<S-l>" = "open_tabnew";     # shift-variant also opens (new tab)
          "<S-enter>" = "open_tabnew";
          "<C-v>" = "open_vsplit";     # the dedicated key for split open
          "." = "toggle_hidden";       # show / hide hidden files
          r = "rename";                # rename file/folder
          a = "add";                   # create new file
          A = "add_directory";         # create new folder
          D = "delete";                # delete file/folder (asks first)
          y = "copy";                  # copy to neo-tree clipboard (own buffer)
          x = "cut";                   # cut to neo-tree clipboard (own buffer)
          p = "paste_from_clipboard";  # paste
          # "d" = move to trash, "u" = undo trash, "I" = file info are buffer
          # keymaps in commands.nix — they need lua callbacks
        };
      };
      filesystem.follow_current_file.enabled = true;
    };
  };
}