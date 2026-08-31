{ pkgs, ... }: {
  console = {
    font = "spleen-16x32";
    packages = [ pkgs.spleen ];
  };

  # System fonts available for applications.
  # nafees (Nastaliq/Urdu) is included for fontconfig language-based mapping.
  # noto-fonts and nerd-fonts are included for general use.
  fonts.packages = with pkgs; [
    nafees
    noto-fonts
    nerd-fonts.jetbrains-mono
    spleen
  ];

  # fontconfig: map Arabic script (lang=ar) to nafees Nastaliq font.
  # This uses mode="prepend" to force nafees to the front of the
  # font family list for Arabic-script text runs, regardless of what other
  # fonts cover the glyphs. Per urdu-font-problem.md, mode="prepend" with
  # lang="ar" is the correct approach (not fallback reordering).
  # Note: "nafees" is the family name of the nafees Urdu font from CRULP.
  fonts.fontconfig = {
    enable = true;
    localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
        <match>
          <test name="lang" compare="contains"><string>ar</string></test>
          <test qual="any" name="family"><string>sans-serif</string></test>
          <edit name="family" mode="prepend"><string>Nafees</string></edit>
        </match>
        <match>
          <test name="lang" compare="contains"><string>ar</string></test>
          <test qual="any" name="family"><string>serif</string></test>
          <edit name="family" mode="prepend"><string>Nafees</string></edit>
        </match>
        <match>
          <test name="lang" compare="contains"><string>ar</string></test>
          <test qual="any" name="family"><string>monospace</string></test>
          <edit name="family" mode="prepend"><string>Nafees</string></edit>
        </match>
      </fontconfig>
    '';
  };

  # console-font: re-applies spleen-16x32 after DRM GPU driver takeover on all VTs.
  # The initial sysinit application is omitted because the GPU driver's console
  # takeover resets the font back to the kernel default. The oneshot service runs
  # after the DRM device is ready, ensuring the font persists.
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
          [ -e "$tty" ] && setfont spleen-16x32 -C "$tty"
        done
      '';
    };
  };
}