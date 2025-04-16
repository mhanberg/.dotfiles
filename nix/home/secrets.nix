let
  dk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBawt44pYaVCd7wxRtsxJfcvMP4ac6Ara9xd7YK8mvq";
in {
  "export-aws-keys.age".publicKeys = [dk];
}
