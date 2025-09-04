# .dotfiles

These dotfiles are now managed using Nix on macOS and Linux.

macOS utilizes nix-darwin in order to manage homebrew dependencies, and both macOS and Linux utilize home-manager for dotfiles and nixpkgs.

## Getting Started

Install Nix with the determinate nix installer

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
```

Run the installer

```bash
nix run github:mhanberg/.dotfiles
```

## Usage

You can see the current tasks by running `just --list`

```bash
$ just --list
Available recipes:
    default
    fix-shell-files # fix shell files. this happens sometimes with nix-darwin
    hm              # run home-manager switch
    news
    rebuild         # rebuild nix darwin
    update          # updates brew, flake, and runs home-manager
    update-brew     # update and upgrade homebrew packages
    update-flake    # update your flake.lock

```
