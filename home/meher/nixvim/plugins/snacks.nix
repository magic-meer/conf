{ ... }: {
  plugins.snacks = {
    enable = true;
    settings = {
      # Only used as the picker + input UI backend for opencode.nvim.
      # Bigfile/notifier/etc are disabled to avoid overlapping with noice/notify.
      bigfile = {
        enabled = false;
      };
      notifier = {
        enabled = false;
      };
      quickfile = {
        enabled = false;
      };
      statuscolumn = {
        enabled = false;
      };
      words = {
        enabled = false;
      };
      # Enhance opencode.nvim Ask (input) and Select (picker)
      input = {
        enabled = true;
      };
      picker = {
        enabled = true;
      };
    };
  };
}
