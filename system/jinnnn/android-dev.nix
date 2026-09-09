# Android development environment (Kotlin Multiplatform, Android + Linux targets).
#
# Design decisions:
# - No Android Studio, no emulator. Testing happens on Linux desktop or a
#   physical Android device plugged in over USB (or wireless adb).
# - The Android SDK is composed with androidenv and consumed through a
#   buildFHSEnv shell (`android-dev-env`). This is the important part on NixOS:
#   Android Gradle Plugin downloads its own aapt2 (and NDK toolchains) into
#   ~/.gradle and those binaries are dynamically linked against /lib64/ld-linux,
#   which does not exist on NixOS. A plain mkShell + GRADLE_OPTS aapt2 override
#   is NOT sufficient (nixpkgs#402297); the FHS shell makes all of those
#   prebuilt binaries work unmodified.
# - Licenses are accepted via nixpkgs.config.android_sdk.accept_license.
#
# Usage:
#   cd your-kmp-project && android-dev-env
#   adb devices                          # verify the physical device
#   ./gradlew :composeApp:installDebug   # device build
#   ./gradlew :composeApp:run            # desktop (linux) run
{
  pkgs,
  ...
}: let
  # JDK for Android/Kotlin builds. AGP 8.x is happy with JDK 17/21; 17 is the
  # safest with Gradle 8.x + AGP 8.x combinations.
  jdk = pkgs.jdk17_headless;

  # Android SDK composition: platform + build-tools only. No system images, no
  # emulator, no NDK unless/until a project actually needs native code.
  # Add more platformVersions entries when projects target older APIs.
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    platformVersions = ["35"];
    buildToolsVersions = ["35.0.0"];
    # Add `includeNDK = true;` here if a project ever needs native code.
  };
  androidsdk = androidComposition.androidsdk;
  androidSdkDir = "${androidsdk}/libexec/android-sdk";

  # FHS shell where Gradle/AGP can download and run its own toolchain bits
  # (aapt2, d8, CMake, NDK toolchains) exactly like on any other distro.
  androidDevEnv = pkgs.buildFHSEnv {
    name = "android-dev-env";
    # Run `android-dev-env` inside a project; you land in bash with the SDK.
    runScript = "bash";

    targetPkgs = pkgs:
      with pkgs; [
        # The SDK (exports ANDROID_HOME / ANDROID_NDK_ROOT itself)
        androidsdk

        # Build toolchain
        jdk
        gradle
        kotlin

        # FHS niceties for Gradle daemon / AGP scripts
        which
        file
        unzip
        zip
        procps

        # Physical-device debugging (adb also available on host)
        android-tools
      ];

    profile = ''
      export ANDROID_HOME=${androidSdkDir}
      export ANDROID_SDK_ROOT=${androidSdkDir}
      export JAVA_HOME=${jdk.home}

      # Keep Gradle from printing every cache access and use a per-user daemon.
      export GRADLE_USER_HOME=''${GRADLE_USER_HOME:-$HOME/.gradle}
    '';
  };
in {
  # Accept the Android SDK license, including for androidenv packages pulled in
  # by other packages (e.g. android-studio if it is ever added).
  nixpkgs.config.android_sdk.accept_license = true;

  # udev rules so adb/fastboot see physical devices across vendors
  # (Google/Pixel, Samsung, Xiaomi, OnePlus, etc.).
  services.udev.packages = [pkgs.android-udev-rules];

  environment.systemPackages = with pkgs; [
    androidDevEnv # `android-dev-env` command -> FHS shell with the SDK
    pkgs.android-tools # adb/fastboot available on the host too
  ];
}
