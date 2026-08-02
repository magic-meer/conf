{
  lib,
  pkgs,
  ...
}: let
  splashTheme = pkgs.runCommand "plymouth-theme-jinnnn" {} ''
    mkdir -p $out/share/plymouth/themes/jinnnn
    cp ${pkgs.plymouth}/share/plymouth/themes/script/*.png $out/share/plymouth/themes/jinnnn/
    cp ${./plymouth-theme/jinnnn.script} $out/share/plymouth/themes/jinnnn/jinnnn.script
    cat > $out/share/plymouth/themes/jinnnn/jinnnn.plymouth <<EOF
    [Plymouth Theme]
    Name=jinnnn
    Description=Black splash with logo and tagline
    ModuleName=script

    [script]
    ImageDir=$out/share/plymouth/themes/jinnnn
    ScriptFile=$out/share/plymouth/themes/jinnnn/jinnnn.script
    ConsoleLogBackgroundColor=0x00000000
    EOF
  '';
in {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;
  # Load amdgpu in the initrd so Plymouth renders via the real GPU from the
  # start. Otherwise the late amdgpu takeover wipes the splash (black screen)
  # and resets the console font.
  boot.initrd.availableKernelModules = lib.mkAfter [ "amdgpu" ];

  boot.plymouth = {
    enable = true;
    # Custom "script"-based theme: black background, centered logo from
    # /etc/plymouth/logo.png, tagline text below. The default "bgrt" theme
    # never renders the logo on machines without a firmware BGRT.
    theme = "jinnnn";
    themePackages = [ splashTheme ];
    logo = ./boot-splash.png;
  };

  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    # No "quiet": show the systemd boot logs on the black console before the
    # Plymouth splash takes over.
    "systemd.show_status=yes"
    "udev.log_level=3"
  ];
}
