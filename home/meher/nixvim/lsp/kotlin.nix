{ pkgs, ... }: {
   plugins.lsp.servers.kotlin_language_server = {
      enable = true;
      package = pkgs.kotlin-language-server;

      autostart = true;

      # Neovim maps both .kt and .kts to the "kotlin" filetype.
      filetypes = [ "kotlin" ];

      # Kotlin files can live anywhere, so just start on any kotlin buffer.
      rootMarkers = [ "settings.gradle.kts" "settings.gradle" "build.gradle.kts" "build.gradle" ".git" ];
   };
}
