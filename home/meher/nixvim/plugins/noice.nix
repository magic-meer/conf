{ ... }: {
  plugins.noice = {
    enable = true;
    settings = {
      cmdline = {
        enabled = true;
        view = "cmdline_popup";
        format = {
          cmdline = {
            icon = ">";
            lang = "vim";
          };
          search_down = {
            kind = "search";
            icon = "/";
            lang = "regex";
          };
          search_up = {
            kind = "search";
            icon = "?";
            lang = "regex";
          };
        };
      };

      messages = {
        enabled = true;
        view = "notify";
      };

      popupmenu = {
        enabled = true;
        backend = "nui";
      };

      # nvim-notify stays as the toast backend for notifications
      notify = {
        enabled = true;
        view = "notify";
      };

      lsp = {
        message = {
          enabled = true;
          view = "bottom_right";
        };
        documentation = {
          view = "hover";
        };
      };

      views = {
        # Typed commands and inline prompts (save?, :inputs) live here: top-center
        cmdline_popup = {
          backend = "popup";
          relative = "editor";
          position = {
            row = 3;
            col = "50%";
          };
          size = {
            width = "60%";
            height = "auto";
          };
          border = {
            style = "rounded";
            padding = [
              1
              1
            ];
          };
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder";
            winblend = 30;
          };
        };
        # Search results, counts and errors land here: bottom-right, above lualine
        bottom_right = {
          backend = "popup";
          relative = "editor";
          position = {
            row = -2;
            col = "100%";
          };
          size = {
            width = "auto";
            height = "auto";
          };
          border = "rounded";
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder";
            winblend = 30;
          };
        };
        # Native confirm dialogs (e.g. "save?") also top-center and transparent
        confirm = {
          backend = "popup";
          relative = "editor";
          focusable = false;
          align = "center";
          enter = false;
          position = {
            row = 3;
            col = "50%";
          };
          size = "auto";
          border = {
            style = "rounded";
            padding = [
              0
              1
            ];
          };
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder";
            winblend = 30;
          };
        };
      };

      routes = [
        # Search input and count -> bottom right
        {
          filter = {
            event = "msg_show";
            kind = "search_count";
          };
          view = "bottom_right";
        }
        {
          filter = {
            event = "cmdline";
            kind = "search";
          };
          view = "bottom_right";
        }
        # Errors -> bottom right
        {
          filter = {
            error = true;
          };
          view = "bottom_right";
        }
        # Warnings -> bottom right
        {
          filter = {
            warning = true;
          };
          view = "bottom_right";
        }
        # LSP messages -> bottom right
        {
          filter = {
            event = "lsp";
            kind = "message";
          };
          view = "bottom_right";
        }
        # Everything else stays with the notify backend (nvim-notify)
      ];
    };
  };
}
