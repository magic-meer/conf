{lib, pkgs, ...}:

let
  androidenvPath = "${pkgs.path}/pkgs/development/mobile/androidenv";

  # composeAndroidPackages, built the way nixpkgs builds it internally (calling
  # pkgs.androidenv.composeAndroidPackages directly is broken in this pin).
  #
  # toolsVersion = null is the documented way to skip the legacy "tools" package,
  # which otherwise links the emulator and every system image (18+ GiB).
  androidComposition = pkgs.callPackage "${androidenvPath}/compose-android-packages.nix" {
    licenseAccepted =
      pkgs.androidenv.licenseAccepted
      or pkgs.callPackage "${androidenvPath}/license.nix" { };
    meta = { };
  } {
    platformVersions = [ "37.0" ];
    buildToolsVersions = [ "37.0.0" ];
    toolsVersion = null;
    includeEmulator = false;
    includeSystemImages = false;
    includeNDK = false;
    includeCmake = false;
  };

  androidSdk = androidComposition.androidsdk;

  # ANDROID_HOME as nixpkgs lays it out.
  sdkRoot = "${androidSdk}/libexec/android-sdk";

  jdk = "${pkgs.jdk25}/lib/openjdk";

  # The Kotlin Toolchain writes lock files (e.g. "platforms;android-37.0.lock")
  # into ANDROID_HOME, which a read-only store path rejects. So ANDROID_HOME is a
  # writable directory of symlinks pointing at the immutable store SDK.
  sdkHome = "$HOME/.local/share/android-sdk";
in {
  home.sessionVariables = {
    ANDROID_HOME = sdkHome;
    ANDROID_SDK_ROOT = sdkHome;
    ANDROID_USER_HOME = "$HOME/.android";
    # Stops the Kotlin wrapper from provisioning its own JRE/JDK.
    KOTLIN_CLI_JAVA_HOME = jdk;
    JAVA_HOME = jdk;
    # The Kotlin Toolchain delegates Android dexing to AGP, which otherwise
    # downloads its own unpackaged aapt2. Point it at the patched store binary
    # (documented in nixpkgs' android docs).
    GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${sdkRoot}/build-tools/37.0.0/aapt2";
  };

  home.activation.setupAndroidSdkFarm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    store="${sdkRoot}"
    farm="$HOME/.local/share/android-sdk"

    mkdir -p "$farm"
    for entry in build-tools platforms platform-tools cmdline-tools; do
      ln -sfn "$store/$entry" "$farm/$entry"
    done

    # cmdline-tools/latest (nixpkgs installs cmdline-tools/<version>)
    if [ -d "$farm/cmdline-tools" ]; then
      for d in "$farm/cmdline-tools/"*/; do
        name=$(basename "$d")
        [ "$name" = "latest" ] && continue
        ln -sfn "$name" "$farm/cmdline-tools/latest"
      done
    fi

    # licenses must be writable, so copy instead of symlinking
    mkdir -p "$farm/licenses"
    cp -f "$store/licenses/android-sdk-license" "$farm/licenses/android-sdk-license"
  '';
}
