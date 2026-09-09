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
      pkgs.python3
      pkgs.zip
      pkgs.unzip
      pkgs.kdePackages.okular
      pkgs.kdePackages.calligra
      pkgs.jdk
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

       #Audio and Video Players/Provider/Deps
       pkgs.cliamp pkgs.yt-dlp pkgs.mpv

       #Terminal Apps
       pkgs.peaclock pkgs.cava pkgs.cmatrix pkgs.pipes

       #Kotlin Multiplatform (Android + Linux desktop)
       #NOTE: Gradle/AGP builds for Android must run inside `android-dev-env`
       #(see system/jinnnn/android-dev.nix) — the FHS shell is required on NixOS.
       pkgs.kotlin
       pkgs.kotlin-language-server
       pkgs.gradle
       pkgs.ktlint
       pkgs.jdk17
    ];
}
