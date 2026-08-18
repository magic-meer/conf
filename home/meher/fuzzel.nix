{
  ...
}: {
  programs.fuzzel = {
    enable = true;
    package = null;

    settings = {
      main = {
        layer = "overlay";
        terminal = "kitty";
        # font = "JetBrainsMono Nerd Font:size=12";
        width = "40%";
      };

      # colors = {
      #   background = "1a1b26cc";
      #   text = "c0caf5ee";
      #   prompt = "c0caf5ee";
      #   input = "c0caf5ee";
      #   placeholder = "565f8988";
      #   selection = "33467ccc";
      #   selection-text = "c0caf5ff";
      #   selection-match = "7aa2f7ff";
      #   border = "7aa2f7cc";
      #   counter = "565f89cc";
      # };
    };
  };
}
