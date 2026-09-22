{
   inputs,
   pkgs,
   ... }: {
   home.packages = [
      pkgs.fuzzel
      pkgs.waybar
      pkgs.superfile
      pkgs.swaylock
      pkgs.overskride
      pkgs.zed-editor
      pkgs.opencode
      pkgs.awww
      pkgs.swaynotificationcenter
      pkgs.brightnessctl
      pkgs.power-profiles-daemon
      pkgs.zip
      pkgs.unzip
      pkgs.kdePackages.okular
      pkgs.kdePackages.calligra
      pkgs.steam-run
      pkgs.quickshell
      pkgs.gimp
      pkgs.ripgrep
      pkgs.ghostty
      pkgs.pavucontrol
      pkgs.nixd
      pkgs.starship
      # qmlls
      pkgs.keepassxc
      pkgs.btop

      #Developers thigss
      pkgs.python3 pkgs.jdk25 pkgs.kotlin
      pkgs.stdenv.cc.cc.lib # libstdc++.so.6 for numpy in python venvs
      pkgs.direnv pkgs.android-tools pkgs.kotlin-language-server
      pkgs.ruff
      pkgs.uv

       #Audio and Video Players/Provider/Deps
       pkgs.cliamp pkgs.yt-dlp pkgs.mpv

       #Terminal Apps
       pkgs.peaclock pkgs.cava pkgs.cmatrix pkgs.pipes

# Antigravity
        inputs.antigravity-nix.packages.x86_64-linux.google-antigravity-cli
      ];
 }
