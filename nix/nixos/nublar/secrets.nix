let
  nublar_mitchell = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFqwZQR1Z5Y9Tss3HvBN/bEPx5FthMjTHSuZhjmh+lu";
  nublar_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAFJ0aggyJ7EnYIt1nrWeb18AhRDVji/hdES3LmFeVcZ root@nublar";
in {
  "./secrets/smb-secrets.age".publicKeys = [nublar_mitchell nublar_host];
}
