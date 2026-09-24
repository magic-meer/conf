{lib, pkgs, ...}:

let
  # Declarative Android SDK. Binaries are auto-patched (autoPatchelfHook) so they
  # run on NixOS, and the android-sdk-license is accepted here (licenseAccepted).
  androidSdk = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "37.0" ];
    buildToolsVersions = [ "37.0.0" ];
    licenseAccepted = true;
    includeEmulator = false;
    includeSystemImages = false;
    includeNDK = false;
  }.androidsdk;

  sdkRoot = "${androidSdk}/libexec/android-sdk";
  androidHome = "$HOME/.android-sdk";
in {
  home.packages = [ androidSdk ];

  home.sessionVariables = {
    # Use the Nix-store JDK so Amper/Gradle don't provision a Temurin JDK into
    # ~/.cache (which NixOS' stub-ld refuses to run).
    JAVA_HOME = "${pkgs.jdk25}/lib/openjdk";
    ANDROID_HOME = androidHome;
    ANDROID_SDK_ROOT = androidHome;
  };

  # The store SDK is read-only and Amper's cmdline-tools check expects
  # cmdline-tools/latest (nixpkgs installs it as cmdline-tools/<version>).
  # Mirror the components into a writable $ANDROID_HOME via symlinks.
  home.activation.setupAndroidSdk = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    sdk="${sdkRoot}"
    home_dir="$HOME/.android-sdk"
    mkdir -p "$home_dir"

    for d in build-tools platforms platform-tools licenses tools; do
      ln -sfn "$sdk/$d" "$home_dir/$d"
    done

    mkdir -p "$home_dir/cmdline-tools"
    for d in "$sdk/cmdline-tools/"*/; do
      dir="$home_dir/cmdline-tools/$(basename "$d")"
      ln -sfn "$(readlink -f "$d")" "$dir"
      ln -sfn "$(readlink -f "$d")" "$home_dir/cmdline-tools/latest"
    done
  '';
}