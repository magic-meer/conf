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
        section_separators = {
          left = "\u{e0b4}";
          right = "\u{e0b6}";
        };
      };
      sections = {
        lualine_a = [
          {
            __unkeyed-1 = "mode";
            separator.left = "\u{e0b6}";
            right_padding = 2;
          }
        ];
        lualine_b = [
          "filename"
          "branch"
          "diff"
        ];
        lualine_c = [
          (lib.nixvim.mkRaw "function() return require('lsp-status').status() end")
        ];
        lualine_x = [
          "filetype"
          "fileformat"
          "encoding"
        ];
        lualine_y = [
          "diagnostics"
          "progress"
        ];
        lualine_z = [
          {
            __unkeyed-1 = "location";
            separator.right = "\u{e0b4}";
            left_padding = 2;
          }
        ];
      };
    };
  };
}