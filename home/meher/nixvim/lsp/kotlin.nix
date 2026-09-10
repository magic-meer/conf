{ pkgs, ... }: {
   plugins.lsp.servers.kotlin-language-server = {
      enable = true;
      package = pkgs.kotlin-language-server;

      autostart = true;

      filetypes = [
      "kotlin"
      ];

      rootMarkers = [
      "settings.gradle"
      "settings.gradle.kts"
      "build.gradle"
      "build.gradle.kts"
      "gradlew"
      ".git"
      ];
   };
}
