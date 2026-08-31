let
   meher = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFLcaoLYBulPgCFGtd23cUE2Xsv1iVRSJdLz3VgqzS21 meher@jinnnn";
   jinnnn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB37FH1t0LLZ5Dy9Y8X/0vKaxvxPjMf4u9iXchsA5pUr root@jinnnn";

in {
   "github-token.age".publicKeys = [ meher ];
   "meher-default-pass.age".publicKeys = [ meher jinnnn ];
   "syncthing-pass.age".publicKeys = [ meher jinnnn ];
   "opencode-server-pass.age".publicKeys = [ meher jinnnn ];
}

