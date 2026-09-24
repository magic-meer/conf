{lib, pkgs, ...}:

let
  # Declarative Android SDK. nixpkgs' composeAndroidPackages (pinned, verified
  # against this flake's own pkgs: `? androidsdk = true`) writes the
  # android-sdk-license hashes itself and accepts licenses for us — do NOT pass
  # a licenseAccepted arg (this pinned compose rejects it). Binaries are
  # auto-patched (autoPatchelfHook) at build time so they run on NixOS, and
  # Amper's cmdline-tools/license check is satisfied by the license dirs that
  # ship inside the SDK — no imperative sdkmanager --licenses needed.
  androidSdk = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "37.0" ];
    buildToolsVersions = [ "37.0.0" ];
  }.androidsdk;

  # Store payload: nixpkgs installs the real components under libexec/android-sdk.
  sdkStore = "${androidSdk}/libexec/android-sdk";

  # Writable ANDROID_HOME farm. Amper/AGP need cmdline-tools/latest (nixpkgs
  # ships them under cmdline-tools/<version>), and Amper's sdkmanager writes
  # licenses — so we fake a writable, Amper-friendly layout via symlinks.
  sdkHome = "$HOME/.android-sdk";

  # Components present in the pinned androidsdk (verified above).
  components = [
    "build-tools"
    "platforms"
    "platform-tools"
    "tools"
    "licenses"
    "cmdline-tools"
  ];
in {
  home.packages = [ androidSdk ];

  home.sessionVariables = {
    # Use the Nix-store JDK so Amper/Gradle go straight to it instead of
    # provisioning a Temurin JDK into ~/.cache (which NixOS refuses to run).
    JAVA_HOME = "${pkgs.jdk25}/lib/openjdk";
    ANDROID_HOME = sdkHome;
    ANDROID_SDK_ROOT = sdkHome;
    ANDROID_USER_HOME = "$HOME/.android";
  };

  # Amper expects a writable SDK (it runs sdkmanager which writes licenses and
  # reads cmdline-tools/latest). The store SDK is read-only, nixpkgs names
  # cmdline-tools/<version>, and components live in the store — so we mirror the
  # store components into a writable farm via symlinks and alias latest.
  home.activation.setupAndroidSdk = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    store="${sdkStore}"
    farm="${sdkHome}"
    mkdir -p "$farm/cmdline-tools"

    for d in ${builtins.toString components}; do
      ln -sfn "$store/$d" "$farm/$d"
    done

    # alias cmdline-tools/latest (store ships cmdline-tools/<version>)
    latest=$(find "$store/cmdline-tools" -maxdepth 1 -mindepth 1 -type d | head -n1)
    if [ -n "$latest" ]; then
      ln -sfn "$(readlink -f "$latest")" "$farm/cmdline-tools/latest"
    fi

    # Amper checks licenses/ - the store SDK ships them; ensure the farm has them.
    mkdir -p "$farm/licenses"
    if [ -f "$store/licenses/android-sdk-license" ]; then
      cp -L "$store/licenses/android-sdk-license" "$farm/licenses/android-sdk-license" 2>/dev/null || true
    fi
  '';
}
