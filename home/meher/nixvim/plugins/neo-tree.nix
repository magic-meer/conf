{ ... }: {
   plugins.neo-tree = {
      enable = true;
      settings = {
         close_if_last_window = true;
         window = {
            position = "right";
            mappings = {
               "l" = "open";
               "h" = "close_node";
            };
         };
         filesystem = {
            follow_current_file = {
               enabled = true;
               leave_dirs_open = true;
            };
            window = {
               mappings = {
                  "." = "toggle_hidden";
               };
            };
         };
      };
   };
}
