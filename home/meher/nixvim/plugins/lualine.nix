{ lib, ... }: {
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "auto";
        globalstatus = true;
        icons_enabled = true;
        disabled_filetypes = {
          statusline = [ "neo-tree" ];
        };
        component_separators = "";
        section_separators = "";
      };
      sections = {
        lualine_a = [
          # Transparent left margin spacer
          {
            __unkeyed-1.__raw = "function() return '' end";
            color.bg = "";
            left_padding = 2;
            right_padding = 1;
          }
          # Mode in its own bubble
          {
            __unkeyed-1 = "mode";
            separator.left = "";
            separator.right = "";
          }
        ];
        lualine_b = [
          # File / VCS info in one bubble
          {
            __unkeyed-1 = "filename";
            separator.left = "";
          }
          "branch"
          {
            __unkeyed-1 = "diff";
            separator.right = "";
          }
        ];
        lualine_c = [
          # LSP status in its own bubble
          {
            __unkeyed-1.__raw = "function() return require('lsp-status').status() end";
            separator.left = "";
            separator.right = "";
          }
        ];
        lualine_x = [
          # OpenCode agent server + status
          {
            __unkeyed-1.__raw = "function() return require('opencode').statusline() end";
            separator.left = "";
            separator.right = "";
          }
          # File metadata in one bubble
          {
            __unkeyed-1 = "filetype";
            separator.left = "";
          }
          "fileformat"
          {
            __unkeyed-1 = "encoding";
            separator.right = "";
          }
        ];
        lualine_y = [
          # Diagnostics + progress in one bubble
          {
            __unkeyed-1 = "diagnostics";
            separator.left = "";
          }
          {
            __unkeyed-1 = "progress";
            separator.right = "";
          }
        ];
        lualine_z = [
          # Location in its own bubble
          {
            __unkeyed-1 = "location";
            separator.left = "";
            separator.right = "";
          }
          # Transparent right margin spacer
          {
            __unkeyed-1.__raw = "function() return '' end";
            color.bg = "";
            left_padding = 1;
            right_padding = 2;
          }
        ];
      };
    };
  };
}
