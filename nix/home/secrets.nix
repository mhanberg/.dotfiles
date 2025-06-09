let
  dk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBawt44pYaVCd7wxRtsxJfcvMP4ac6Ara9xd7YK8mvq";
  # nublar = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFqwZQR1Z5Y9Tss3HvBN/bEPx5FthMjTHSuZhjmh+lu";
in {
  "./dk/secrets/aws-role-arn.age".publicKeys = [dk];
  "./dk/secrets/aws-role-session-name.age".publicKeys = [dk];
}
