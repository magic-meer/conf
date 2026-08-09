{
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = true;
      window = {
        # sidebar on the right so the code buffer stays put
        position = "right";
        mappings = {
          # superfile-style tree navigation & actions
          l = "open_tabnew";          # open: files go to a new tab by default
          h = "close_node";           # collapse / go up
          "<enter>" = "open_tabnew";  # same as l
          "<C-v>" = "open_vsplit";    # the dedicated key for split open
          H = "toggle_hidden";        # show / hide hidden files
          r = "rename";               # rename file/folder
          a = "add";                  # create new file
          A = "add_directory";        # create new folder
          d = "delete";               # delete file/folder
          y = "copy";                 # copy to clipboard
          x = "cut";                  # cut to clipboard
          p = "paste_from_clipboard";  # paste
          # D = move to trash and I = file info are buffer keymaps (commands.nix)
          # because they need a lua callback — kept here for discovery
        };
      };
      filesystem.follow_current_file.enabled = true;
    };
  };
}