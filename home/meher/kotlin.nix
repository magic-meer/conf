{lib, pkgs, ...}:

let
  jdk = "${pkgs.jdk25}/lib/openjdk";
in {
  # Applies to every Kotlin project on this machine, wherever it lives: the env
  # comes from the session profile, not from anything project-local.
  home.sessionVariables = {
    # Never let the toolchain provision its own JRE/JDK into ~/.cache.
    KOTLIN_CLI_JAVA_HOME = jdk;
    JAVA_HOME = jdk;

    # Compose Desktop renders through Skiko, whose native library
    # (~/.skiko/libskiko-linux-x64-*.so) is downloaded and therefore unpatched.
    # Asking for the software renderer avoids needing OpenGL at all, so a fresh
    # clone runs on a clean machine with no per-project setup:
    #   libskiko-linux-x64-*.so: libGL.so.1: cannot open shared object file
    # Override per-run with SKIKO_RENDER_API=OPENGL once the GL libraries are
    # made visible to the JVM's loader (see docs/kmp-android-declarative-setup.md).
    SKIKO_RENDER_API = "SOFTWARE";
  };
}
