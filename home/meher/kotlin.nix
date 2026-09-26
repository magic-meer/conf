{lib, pkgs, ...}:

let
  jdk = "${pkgs.jdk25}/lib/openjdk";

  # Compose Desktop renders through Skiko, whose native library
  # (~/.skiko/libskiko-linux-x64-*.so) is downloaded and therefore unpatched.
  #
  # nix-ld only helps *unpatched* executables. The toolchain's downloaded JBR is
  # unpatched, so nix-ld resolves Skia's deps for it; but when the app runs on
  # the patched store JDK, the real loader looks for libGL.so.1 in RPATH /
  # ld.so.cache and fails with:
  #   libskiko-linux-x64-*.so: libGL.so.1: cannot open shared object file
  # Pointing the loader at the store's GL/X11/font libraries fixes it in both
  # cases, so GPU rendering works with or without Compose Hot Reload.
  glAndX11Libs = with pkgs; [
    libGL
    libX11
    libXext
    libXrender
    libXtst
    libXi
    libXcursor
    libXinerama
    libXrandr
    freetype
    fontconfig
    glib
    zlib
    ncurses
  ];
in {
  # Applies to every Kotlin project on this machine, wherever it lives: the env
  # comes from the session profile, not from anything project-local.
  home.sessionVariables = {
    # Never let the toolchain provision its own JRE/JDK into ~/.cache.
    KOTLIN_CLI_JAVA_HOME = jdk;
    JAVA_HOME = jdk;

    LD_LIBRARY_PATH = lib.makeLibraryPath glAndX11Libs;

    # Where Mesa keeps the DRI drivers (llvmpipe / nouveau / …) that libGL
    # dlopen()s at runtime.
    LIBGL_DRIVERS_PATH = "${lib.makeLibraryPath [ pkgs.mesa ]}/dri";
  };
}
