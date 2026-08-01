{
  programs.nixvim.plugins.noice = {
    enable = true;

    settings = {
      cmdline = {
        enabled = true;
        view = "cmdline_popup";
      };

      messages = {
        enabled = true;
        view = "notify";
        view_error = "notify";
        view_warn = "notify";
      };

      # error messages float in the top-right corner
      views = {
        notify = {
          position = {
            row = "top";
            col = "right";
          };
          # border colors follow the colorscheme's FloatBorder highlight
          border = "rounded";
        };
        # confirmation popups (e.g. `:q` with unsaved changes) appear top-center
        cmdline_popup = {
          position = {
            row = "10%";
            col = "50%";
          };
          border = {
            style = "rounded";
            padding = [ 1 2 ];
          };
        };
      };

      routes = [
        {
          filter = { event = "confirm"; };
          view = "cmdline_popup";
        }
      ];
    };
  };
}
