{
  ...
}: {
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

   # lsp-status.nvim is unmaintained and still calls `vim.lsp.buf_get_clients()`,
   # which was removed in Nvim 0.12. Shim it to the current API so the statusline
   # renders without deprecation warnings/errors. Must run before the lualine
   # component first renders, hence extraConfigLuaPre.
   extraConfigLuaPre = ''
      if vim.lsp.buf_get_clients == nil then
        vim.lsp.buf_get_clients = function(bufnr)
          return vim.lsp.get_clients({ bufnr = bufnr })
        end
      end
   '';
}