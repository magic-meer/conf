{ ... }: {
  # Quickshell (qml component host) needs the Qt language server
  programs.nixvim.lsp.servers.qmlls.enable = true;
}