{ ... }: {
  # Explain compiler/error messages with AI (`wtf` under the cursor).
  # NOTE: needs an API key in env, e.g. OPENAI_API_KEY
  programs.nixvim.plugins.wtf = {
    enable = true;
    settings.popup_type = "popup";
  };
}
