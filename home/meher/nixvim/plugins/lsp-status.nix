{ ... }: {
   plugins.lsp-status = {
      enable = true;
      settings = {
         # Show current function, filename and diagnostics in the statusline component
         current_function = true;
         show_filename = true;
         diagnostics = true;
         # Decorate the current-function name with a nerd-font icon per symbol kind
         kind_labels = {
            "Class" = "󰠱";
            "Function" = "󰊕";
            "Method" = "󰊕";
            "Struct" = "󰆼";
            "Enum" = "󰕘";
            "Interface" = "󰖩";
            "Namespace" = "󰌗";
            "Module" = "󰏗";
         };
      };
   };
}