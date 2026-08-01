{ pkgs, ... }: {
  # Paste images from the clipboard into markdown/etc.
  # Wayland session (niri) → wl-clipboard provider
  programs.nixvim.plugins.clipboard-image = {
    enable = true;
    clipboardPackage = pkgs.wl-clipboard;
    settings.default = {
      img_dir = "img";
      img_dir_txt = "img";
    };
  };
}
