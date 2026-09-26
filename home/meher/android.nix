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

  # The Kotlin Toolchain pins cmdline-tools 23.0 (build 16111833), which is newer
  # than this pinned nixpkgs' repo.json knows about (22.0). Provide it directly
  # so the toolchain does not try to download it into the SDK.
  cmdlineTools23 = pkgs.stdenvNoCC.mkDerivation {
    pname = "android-cmdline-tools";
    version = "23.0";
    src = pkgs.fetchurl {
      url = "https://dl.google.com/android/repository/commandlinetools-linux-16111833_latest.zip";
      sha256 = "0877a1d048fe4a24efe2eff536ca4223f7adeb58648bb81909d33c446918cfa8";
    };
    nativeBuildInputs = [ pkgs.unzip ];
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      unzip -q "$src" -d .
      mkdir -p "$out"
      cp -r cmdline-tools "$out/23.0"
      chmod -R u+w "$out"

      license_block=$(sed -n '/<license id="android-sdk-license" type="text">/,/<\/license>/p' \
        ${androidComposition.platform-tools}/libexec/android-sdk/platform-tools/package.xml)
      cat > "$out/23.0/package.xml" <<EOF
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <ns2:repository
      xmlns:ns2="http://schemas.android.com/repository/android/common/02"
      xmlns:ns3="http://schemas.android.com/repository/android/common/01"
      xmlns:ns4="http://schemas.android.com/repository/android/generic/01"
      xmlns:ns5="http://schemas.android.com/repository/android/generic/02"
      xmlns:ns6="http://schemas.android.com/sdk/android/repo/addon2/01"
      xmlns:ns7="http://schemas.android.com/sdk/android/repo/addon2/02"
      xmlns:ns8="http://schemas.android.com/sdk/android/repo/addon2/03"
      xmlns:ns9="http://schemas.android.com/sdk/android/repo/repository2/01"
      xmlns:ns10="http://schemas.android.com/sdk/android/repo/repository2/02"
      xmlns:ns11="http://schemas.android.com/sdk/android/repo/repository2/03"
      xmlns:ns12="http://schemas.android.com/sdk/android/repo/sys-img2/03"
      xmlns:ns13="http://schemas.android.com/sdk/android/repo/sys-img2/02"
      xmlns:ns14="http://schemas.android.com/sdk/android/repo/sys-img2/01"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    $license_block
      <localPackage path="cmdline-tools;23.0" obsolete="false">
        <type-details xsi:type="ns5:genericDetailsType"/>
        <revision><major>23</major><minor>0</minor><micro>0</micro></revision>
        <display-name>Android SDK Command-line Tools</display-name>
        <uses-license ref="android-sdk-license"/>
      </localPackage>
    </ns2:repository>
    EOF
      runHook postInstall
    '';
  };

  # ANDROID_HOME as nixpkgs lays it out.
  sdkRoot = "${androidSdk}/libexec/android-sdk";

  # The Kotlin Toolchain writes lock files (e.g. "platforms;android-37.0.lock")
  # into ANDROID_HOME, which a read-only store path rejects. So ANDROID_HOME is a
  # writable directory of symlinks pointing at the immutable store SDK.
  sdkHome = "$HOME/.local/share/android-sdk";
in {
  home.packages = [
    cmdlineTools23
    # adb / fastboot on PATH, for `./kotlin run -d <device-id>`
    androidComposition.platform-tools
  ];

  home.sessionVariables = {
    ANDROID_HOME = sdkHome;
    ANDROID_SDK_ROOT = sdkHome;
    ANDROID_USER_HOME = "$HOME/.android";
    # The Kotlin Toolchain delegates Android dexing to AGP, which otherwise
    # downloads its own unpackaged aapt2. Point it at the patched store binary
    # (documented in nixpkgs' android docs).
    GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${sdkRoot}/build-tools/37.0.0/aapt2";
  };

  home.activation.setupAndroidSdkFarm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    store="${sdkRoot}"
    farm="$HOME/.local/share/android-sdk"

    mkdir -p "$farm"
    for entry in build-tools platforms platform-tools; do
      ln -sfn "$store/$entry" "$farm/$entry"
    done

    # cmdline-tools must be a real (writable) directory: the toolchain drops
    # lock/flag files in here while installing. Contents are symlinks.
    rm -rf "$farm/cmdline-tools"
    mkdir -p "$farm/cmdline-tools"
    ln -sfn "${cmdlineTools23}/23.0" "$farm/cmdline-tools/23.0"
    ln -sfn 23.0 "$farm/cmdline-tools/latest"

    # licenses must be writable, so copy instead of symlinking
    mkdir -p "$farm/licenses"
    cp -f "$store/licenses/android-sdk-license" "$farm/licenses/android-sdk-license"
  '';
}
