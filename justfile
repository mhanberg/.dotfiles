default:
  @just --list
# update your flake.lock
update-flake:
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

# update Lix on non-NixOS linux systems
[linux]
update-lix version:
  #!/usr/bin/env bash

  sudo --preserve-env=PATH $(which nix) run \
     --experimental-features "nix-command flakes" \
     --extra-substituters https://cache.lix.systems --extra-trusted-public-keys "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" \
     'git+https://git.lix.systems/lix-project/lix?ref=refs/tags/{{version}}' -- \
     upgrade-nix \
     --extra-substituters https://cache.lix.systems --extra-trusted-public-keys "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="

# run home-manager switch
hm:
  home-manager switch --flake ~/.dotfiles -b backup

# rebuild nix darwin
[macos]
rebuild:
  sudo darwin-rebuild switch --flake ~/.dotfiles

# rebuild nixos
[linux]
rebuild:
  sudo nixos-rebuild switch --flake ~/.dotfiles

# update and upgrade homebrew packages
[macos]
update-brew:
  brew update && brew upgrade

# fix shell files. this happens sometimes with nix-darwin
[macos]
fix-shell-files:
  #!/usr/bin/env bash
  set -euxo pipefail

  sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
  sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
  sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin

# update and upgrade apt packages
[linux]
update-apt:
  sudo apt update && sudo apt upgrade --yes

# updates apt, flake, and runs home-manager
[linux]
update: update-apt update-flake hm

# updates brew, flake, and runs home-manager
[macos]
update: update-brew update-flake hm
  

