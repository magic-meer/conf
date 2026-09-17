{ pkgs, ... }: {
  # Java language server via nvim-jdtls.
  #
  # Fully declarative: the server and its bundled Java 21 runtime come from
  # pkgs.jdt-language-server (the wrapper script hard-codes the JVM, so no
  # JAVA_HOME fiddling needed). The `jdtls` binary is put on PATH via
  # extraPackages; the wrapper generates a per-project `-data` workspace under
  # ~/.cache/jdtls automatically.
  plugins.jdtls = {
    enable = true;
    jdtLanguageServerPackage = pkgs.jdt-language-server;

    settings.cmd = [ "jdtls" ];

    settings.settings = {
      java = {
        inlayHints = {
          parameterNames.enabled = "all";
        };
      };
    };
  };

  # nvim-jdtls configures the LSP server through lsp.servers.jdtls; nvim starts
  # it on Java buffers automatically.
  plugins.lsp.servers.jdtls = {
    filetypes = [ "java" ];
  };
}