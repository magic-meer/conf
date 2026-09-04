{ ... }: {
    xdg.configFile."cliamp/config.toml".text = ''
    [ytmusic]
    cookies_from = "firefox:~/.config/zen"
    expand_playlist = true
  '';
}
