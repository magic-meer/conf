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
  androidSdk = pkgs.runCommand "android-sdk" { } ''
    mkdir -p $out/build-tools $out/licenses
    cp -r ${buildTools} $out/build-tools/37.0.0
    cp -r ${platform37}/libexec/android-sdk/. $out/
    cp -r ${platformTools}/libexec/android-sdk/. $out/
    cp ${licenseFile} $out/licenses/android-sdk-license
  '';

  jdk = "${pkgs.jdk25}/lib/openjdk";
in {
  home.packages = [
    platformTools
    buildTools
  ];

  home.sessionVariables = {
    ANDROID_HOME = toString androidSdk;
    ANDROID_SDK_ROOT = toString androidSdk;
    ANDROID_USER_HOME = "$HOME/.android";
    # Stops the Kotlin wrapper from provisioning its own JRE/JDK.
    KOTLIN_CLI_JAVA_HOME = jdk;
    JAVA_HOME = jdk;
  };
}
