flake-update:
  #!/usr/bin/env bash
  set -euxo pipefail
  nix flake update
  if git diff --exit-code flake.lock > /dev/null 2>&1; then
    echo "no changes to flake.lock"
  else
    echo "committing flake.lock"
    git add flake.lock
    git commit -m "nix: update flake.lock"
  fi

hm:
  home-manager switch --flake ~/.dotfiles

darwin:
  darwin-rebuild switch --flake ~/.dotfiles
