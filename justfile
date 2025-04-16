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

# rebuild either nix-darwin or NixOS
rebuild:
  #!/usr/bin/env bash
  set -euxo pipefail
  case "{{ os() }}" in
    macos)
      darwin-rebuild switch --flake ~/.dotfiles;;

    linux)
      sudo nixos-rebuild switch --flake ~/.dotfiles;;

     *)
      echo "Unsupported operating system"
      exit 1;;
  esac

# update homebrew
brew:
  #!/usr/bin/env bash
  set -euxo pipefail
  case "{{ os() }}" in
    macos)
      brew update && brew upgrade;;

     *)
      echo "Unsupported operating system"
      exit 1;;
  esac

# fix shell files. this happens sometimes with nix-darwin
fix-shell-files:
  #!/usr/bin/env bash
  set -euxo pipefail

  sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
  sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
  sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin

[linux]
update-apt:
  sudo apt update && sudo apt upgrade --yes
