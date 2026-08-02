{ pkgs, ... }: {
  console = {
    font = "ter-132b";
    packages = [ pkgs.terminus_font ];
  };

  fonts.packages = with pkgs; [
    terminus_font
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nafees
    scheherazade-new
  ];

  # systemd-vconsole-setup applies the font at sysinit, but the amdgpu DRM
  # driver's console takeover happens afterwards and resets every VT back to
  # the kernel default font. Re-apply the font on all VTs once the GPU is up.
  systemd.services.console-font = {
    description = "Re-apply console font after DRM takeover";
    wantedBy = [ "multi-user.target" ];
    after = [ "dev-dri-card1.device" ];
    path = [ pkgs.kbd ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      StandardInput = "null";
      ExecStart = pkgs.writeShellScript "reapply-console-font" ''
        for tty in /dev/tty{1..12}; do
          [ -e "$tty" ] && setfont ter-132b -C "$tty"
        done
      '';
    };
  };
}
