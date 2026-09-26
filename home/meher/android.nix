{lib, pkgs, ...}:

let
  # nixpkgs' androidenv, pre-composed. Requires
  # nixpkgs.config.android_sdk.accept_license = true, which is set in
  # system/jinnnn/packages.nix (nixpkgs config only exists at system level).
  androidEnv = pkgs.androidenv.androidPkgs;

  buildToolsSrc = pkgs.fetchurl {
    url = "https://dl.google.com/android/repository/build-tools_r37_linux.zip";
    sha1 = "70954e99f4c3d9d46ee70fa32624672fe7cd6ebe";
  };

  # nixpkgs' own build-tools package links the legacy "tools" package, which
  # links the emulator, which links every system image (18+ GiB). We only need
  # aapt2/aidl/zipalign, so take the official zip and patchelf it ourselves.
  buildTools = pkgs.stdenvNoCC.mkDerivation {
    pname = "android-build-tools";
    version = "37.0.0";
    src = buildToolsSrc;
    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.unzip
    ];
    buildInputs = [
      pkgs.glibc
      pkgs.zlib
      pkgs.ncurses5
      pkgs.libcxx
    ];
    autoPatchelfIgnoreMissingDeps = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      unzip -q "$src" -d .
      unpacked=$(echo android-*)
      mkdir -p "$out"
      cp -r "$unpacked"/* "$out"/
      chmod -R +w "$out"
      addAutoPatchelfSearchPath "$out/lib" "$out/lib64"
      autoPatchelf --no-recurse "$out/lib64" || true
      autoPatchelf --no-recurse "$out"
      runHook postInstall
    '';
  };

  platform37 = builtins.head (builtins.filter (p: lib.hasPrefix "android-sdk-platforms-37" p.name) androidEnv.platforms);
  platformTools = androidEnv.platform-tools;

  # cmdline-tools 22.0 (sdkmanager/avdmanager). Fetched directly: nixpkgs'
  # builder needs deployAndroidPackage, which is internal to its compose file.
  cmdlineToolsSrc = pkgs.fetchurl {
    url = "https://dl.google.com/android/repository/commandlinetools-linux-15859902_latest.zip";
    sha1 = "040d3996a65543d22ec4bf73e4c37aa37a8d4af4";
  };

  cmdlineTools = pkgs.stdenvNoCC.mkDerivation {
    pname = "android-cmdline-tools";
    version = "22.0";
    src = cmdlineToolsSrc;
    nativeBuildInputs = [ pkgs.unzip ];
    autoPatchelfIgnoreMissingDeps = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      unzip -q "$src" -d .
      mkdir -p "$out"
      cp -r cmdline-tools "$out/22.0"
      chmod -R u+w "$out"
      runHook postInstall
    '';
  };

  licenseFile = pkgs.writeText "android-sdk-license" ''
    24333f8a63b6825ea9c5514f83c2829b004d1fee
    d56f5187479451eabf01fb78af6dfcb131a6481e
    24333f8a63b6825ea9c5514f83c2829b004d1fee
  '';

  # Lean SDK: only what the KMP project needs (API 37 + build-tools 37.0.0 +
  # platform-tools), avoiding the multi-GB emulator/system images that
  # androidPkgs.androidsdk pulls in. Components are autoPatchelfHook-patched by
  # nixpkgs, so they run on NixOS. $out is the SDK root, so ANDROID_HOME can
  # point straight at it.
  # The Kotlin Toolchain validates each SDK package by reading package.xml and
  # re-downloads the package if it is missing. nixpkgs ships one for platforms
  # and platform-tools; the raw build-tools zip does not, so provide it.


  androidSdk = pkgs.runCommand "android-sdk" { } ''
    mkdir -p $out/build-tools $out/licenses $out/cmdline-tools
    cp -r ${buildTools} $out/build-tools/37.0.0
    cp -r ${platform37}/libexec/android-sdk/. $out/
    cp -r ${platformTools}/libexec/android-sdk/. $out/
    for d in ${cmdlineTools}/*/; do
      name=$(basename "$d")
      cp -r "$d" "$out/cmdline-tools/$name"
      ln -sfn "$name" "$out/cmdline-tools/latest"
    done
    chmod -R u+w $out
    cp ${licenseFile} $out/licenses/android-sdk-license

    # The toolchain parses each package's package.xml with JAXB and requires the
    # <license id="android-sdk-license"> element that <uses-license> refers to.
    # Reuse the exact block nixpkgs generates for platform-tools.
    pt_xml="${platformTools}/libexec/android-sdk/platform-tools/package.xml"
    license_block=$(sed -n '/<license id="android-sdk-license" type="text">/,/<\/license>/p' "$pt_xml")

    write_package_xml() {
      local dir=$1 pkg_path=$2 rev_major=$3 rev_minor=$4 rev_micro=$5 name=$6
      cat > "$dir/package.xml" <<EOF
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
      <localPackage path="$pkg_path" obsolete="false">
        <type-details xsi:type="ns5:genericDetailsType"/>
        <revision><major>$rev_major</major><minor>$rev_minor</minor><micro>$rev_micro</micro></revision>
        <display-name>$name</display-name>
        <uses-license ref="android-sdk-license"/>
      </localPackage>
    </ns2:repository>
    EOF
    }

    write_package_xml "$out/build-tools/37.0.0" "build-tools;37.0.0" 37 0 0 "Android SDK Build-Tools 37"
    write_package_xml "$out/cmdline-tools/22.0" "cmdline-tools;22.0" 22 0 0 "Android SDK Command-line Tools"
  '';

  jdk = "${pkgs.jdk25}/lib/openjdk";

  # The toolchain writes lock files (e.g. "platforms;android-37.0.lock") into
  # ANDROID_HOME, so it cannot be a read-only /nix/store path. ANDROID_HOME is a
  # writable directory of symlinks pointing at the immutable store SDK.
  sdkHome = "$HOME/.local/share/android-sdk";
in {
  home.packages = [
    platformTools
    buildTools
  ];

  home.sessionVariables = {
    ANDROID_HOME = sdkHome;
    ANDROID_SDK_ROOT = sdkHome;
    ANDROID_USER_HOME = "$HOME/.android";
    # Stops the Kotlin wrapper from provisioning its own JRE/JDK.
    KOTLIN_CLI_JAVA_HOME = jdk;
    JAVA_HOME = jdk;
  };

  home.activation.setupAndroidSdkFarm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    store="${toString androidSdk}"
    farm="$HOME/.local/share/android-sdk"

    mkdir -p "$farm/licenses"
    for entry in build-tools platforms platform-tools cmdline-tools; do
      ln -sfn "$store/$entry" "$farm/$entry"
    done
    cp -f "$store/licenses/android-sdk-license" "$farm/licenses/android-sdk-license"
  '';
}
