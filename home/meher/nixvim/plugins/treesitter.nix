{ config, ... }: {
   plugins.treesitter = {
      enable = true;
      # folding.enable = true;
      highlight.enable = true;
      indent.enable = true;

      settings = {
         ensure_installed = [
            "qmljs"
            "nix"

            # Kotlin Multiplatform (Android + desktop) filetypes
            "kotlin"
            "java"
            "groovy" # build.gradle (legacy Groovy DSL)
            "toml" # gradle/libs.versions.toml version catalog
            "xml" # AndroidManifest.xml, res/*.xml
            "yaml"
            "json"
         ];
      };
   };



   plugins.treesitter-context = {
      enable = true;
   };
}

