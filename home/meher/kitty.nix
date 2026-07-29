{
  ...
}:
{
  programs.kitty = {
    enable = true;

    # enableFishIntegration = true;
    enableGitIntegration = true;

    settings = {
      confirm_on_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "1.0";
      window_padding_width = 4;
      background_opacity = "0.5";
      background_blur = 5;
    };
  };
}
