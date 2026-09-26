# Declarative Kotlin Multiplatform on NixOS (jinnnn)

How the Android SDK, JDK and aapt2 are provided to the Kotlin Toolchain (formerly
Amper) so that `~/things/fyp/kmptest/TestProject` builds and runs without the
toolchain downloading its own Java or Android SDK.

Rebuild after any change:

```bash
cd ~/nixconfig
git add -A && git commit -m "..."
rebuild-system        # sudo nixos-rebuild switch --flake ~/nixconfig#jinnnn
```

Then verify in a **new shell** (env vars come from the profile):

```bash
echo "$ANDROID_HOME" "$JAVA_HOME"
cd ~/things/fyp/kmptest/TestProject
./kotlin build
./kotlin run                      # with Compose Hot Reload
./kotlin run --no-compose-hot-reload
```

## What is declarative, and where

| Piece | File | Notes |
|---|---|---|
| Android SDK license acceptance | `system/jinnnn/packages.nix` | `nixpkgs.config.android_sdk.accept_license = true` |
| `nix-ld` + libs | `system/jinnnn/default.nix` | lets AGP's aapt2 and the toolchain's JBR run |
| SDK, cmdline-tools, adb, `ANDROID_*`, aapt2 override, SDK farm | `home/meher/android.nix` | per-user, imported from `home/meher/default.nix` |
| JDK, `KOTLIN_CLI_JAVA_HOME`, Skiko renderer | `home/meher/kotlin.nix` | per-user, imported from `home/meher/default.nix` |

The license flag must stay in the *system* module: nixpkgs config only exists
there. Everything else is user-level.

All of it is **session-wide**, so a freshly cloned or `kotlin init`-ed project
anywhere on the machine picks it up with no per-project setup.

## Why each piece is needed

**`nixpkgs.config.android_sdk.accept_license = true`**
Without it nixpkgs refuses to evaluate *any* Android SDK. The error is a wall of
Android SDK license text, and if you only read the last line it looks like
`error: attribute 'androidsdk' missing` — which sends you hunting for a
nonexistent attribute problem.

**`toolsVersion = null` in the composition**
`build-tools` links the legacy `tools` package (for `aapt2`), which links the
**emulator**, which links **every system image**. With defaults that is 18.9 GiB
of downloads. `toolsVersion = null` (documented in nixpkgs' android docs) skips
the legacy tools package. Result: 174 MB instead.

**`GRADLE_OPTS=-Dorg.gradle.project.android.aapt2FromMavenOverride=…/aapt2`**
The Kotlin Toolchain delegates Android dexing to AGP in a generated Gradle build,
and AGP otherwise downloads its own unpackaged `aapt2`. This is the fix
documented by nixpkgs; it also means `nix-ld` is a safety net rather than the
primary mechanism.

**A writable `ANDROID_HOME` (`~/.local/share/android-sdk`)**
The toolchain writes lock files such as `platforms;android-37.0.lock` into
`ANDROID_HOME` and aborts on a read-only store path with
`FileSystemException: … Read-only file system`. The farm is a writable directory
of symlinks pointing at the immutable store SDK. `cmdline-tools/` must itself be
a real writable directory (the toolchain drops `*.flag` files in it) with
symlinks to each version inside; `licenses/` is a real directory with a copied
license file.

**`SKIKO_RENDER_API=SOFTWARE` (`home/meher/kotlin.nix`)**
Compose Desktop draws through Skiko, whose native library
(`~/.skiko/libskiko-linux-x64-*.so`) is downloaded and therefore unpatched, so
it fails with `libGL.so.1: cannot open shared object file`. Software rendering
removes the OpenGL requirement entirely, which is what makes a fresh project run
with no setup. Override per run (`SKIKO_RENDER_API=OPENGL ./kotlin run`) only
after making the GL libraries visible to the JVM's own loader.

**`KOTLIN_CLI_JAVA_HOME` / `JAVA_HOME` → store JDK 25**
Stops the toolchain provisioning a JRE/JDK into `~/.cache`. Additionally, in the
project you can hard-enable this per module:

```yaml
settings:
  jvm:
    jdk:
      selectionMode: javaHome   # use JAVA_HOME or fail; never provision
```

**`nix-ld` libraries (X11, fonts, GL)**
Compose Hot Reload runs on a *downloaded* JetBrains Runtime, which is not
patched. Without the X11/graphics/font libs its AWT fails with
`libawt_xawt.so: libX11.so.6: cannot open shared object file`.

## cmdline-tools 23.0 is pinned by the toolchain, not by nixpkgs

The Kotlin Toolchain wants cmdline-tools **23.0** (build `16111833`), which is
newer than this flake's pinned nixpkgs `repo.json` knows about (22.0). It then
tries to download it into `ANDROID_HOME` and fails on the read-only path. So
`home/meher/android.nix` fetches that exact zip from Google and generates the
`package.xml` metadata itself.

If a future toolchain release wants a newer build, the error names it:

```
…/commandlinetools-linux-<BUILD>_latest.zip.flag: Read-only file system
```

Bump the `url` + `sha256` and the `23.0` → `Pkg.Revision` values in that
derivation. To find the new revision:

```bash
unzip -p commandlinetools-linux-<BUILD>_latest.zip cmdline-tools/source.properties
```

## Pin notes / gotchas encountered

- `pkgs.androidenv.composeAndroidPackages { … }.androidsdk` **does not work** when
  called externally on this nixpkgs pin (fails with a misleading
  `attribute 'androidsdk' missing`). `pkgs.androidenv.androidPkgs.androidsdk`
  works but includes the emulator and system images. `home/meher/android.nix`
  therefore calls the compose function the way nixpkgs does internally, via
  `pkgs.callPackage` on `compose-android-packages.nix`.
- The toolchain validates every SDK package by parsing its `package.xml` and
  re-downloads any package that lacks one. If you hand-assemble an SDK, each
  package dir needs a `package.xml` with a `<license id="android-sdk-license">`
  element *and* `type-details` using the `generic/02` namespace
  (`xsi:type="ns5:genericDetailsType"`). Using `generic/01` fails with
  `Can not set … TypeDetails field … to … GenericDetailsType`.
- `cp -rl` (hardlink) fails with "Invalid cross-device link" because the store
  spans mounts; use `cp -r`, then `chmod -R u+w` before writing into the copy.
- `ANDROID_SDK_ROOT` is deprecated upstream but still exported for tools that
  read it.
- Flakes read the **git** tree: an uncommitted `home/meher/android.nix` is
  invisible to `nixos-rebuild`. For iterating without committing, evaluate with
  a path reference: `nix eval --impure --expr 'let f = builtins.getFlake
  "path:/home/meher/nixconfig"; …'`.

## Running on a physical Android device

```bash
adb devices                                     # platform-tools is on PATH
./kotlin run -m androidApp -d <device-id>       # builds, installs, launches
./kotlin run -m androidApp -d <id> -v release
```

## Expected noise (harmless)

- `Gtk-WARNING: Theme parsing error: gtk.css:NNNN: Expected semicolon` — the
  stylix theme parsed by the GTK bundled in the JetBrains Runtime. Cosmetic.
- `WARNING: A restricted method in java.lang.System has been called` — JDK 24+
  notices Skiko loading its native library. Silence with
  `JAVA_TOOL_OPTIONS="--enable-native-access=ALL-UNNAMED"`.

## Why Gradle shows up at all

The project is pure Kotlin Toolchain (only `project.yaml` / `module.yaml`, no
`gradlew`, no `build.gradle.kts`). But for `android/app` products the toolchain
does its own dependency resolution and Kotlin compilation and then delegates
**bytecode→dex conversion to the Android Gradle plugin in a generated Gradle
build behind the scenes**. That is where the aapt2 requirement comes from.
