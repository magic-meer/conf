{ ... }: {
  xdg.configFile."cliamp/config.toml".text = ''
   theme = ""

   [ytmusic]
   cookies_from = "firefox:~/.config/zen"
   expand_playlist = true
   '';
}
