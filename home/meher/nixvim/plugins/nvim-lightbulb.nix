{ ... }: {
  # Shows a lightbulb whenever a code action is available at the cursor
  programs.nixvim.plugins.nvim-lightbulb = {
    enable = true;
    settings.virtual_text.enabled = true;
  };
}
