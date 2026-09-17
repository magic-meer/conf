{ pkgs, lib, ... }: {
  # Java formatting via google-java-format (Google Java Style).
  # google-java-format is slow to start (~1s JVM spin-up) but produces correct
  # output. The formatter reads from stdin and writes to stdout.
  plugins.conform-nvim.settings.formatters = {
    google-java-format = {
      command = lib.getExe pkgs.google-java-format;
      args = [ "-" ];
      stdin = true;
    };
  };

  plugins.conform-nvim.settings.formatters_by_ft = {
    java = [ "google-java-format" ];
  };
}