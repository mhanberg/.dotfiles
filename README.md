# .dotfiles

These dotfiles are now managed using Nix on macOS and Linux.

macOS utilizes nix-darwin in order to manage homebrew dependencies, and both macOS and Linux utilize home-manager for dotfiles and nixpkgs.

## Getting Started

Install [Lix](https://lix.systems/), an implementation of Nix.

```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
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
    hm                 # run home-manager switch
    rebuild            # rebuild nixos
    update             # updates apt, flake, and runs home-manager
    update-apt         # update and upgrade apt packages
    update-flake       # update your flake.lock
    update-lix version # update Lix on non-NixOS linux systems
```
