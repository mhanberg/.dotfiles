![Open Graph Image](https://res.cloudinary.com/mhanberg/image/upload/v1590506591/dotfiles-social.png)

These dotfiles are now managed using Nix on macOS and Linux.

macOS utilizes nix-darwin in order to manage homebrew dependencies, and both macOS and Linux utilize home-manager for dotfiles and nixpkgs.

## Getting Started

Install Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Run the installer

```bash
nix run github:mhanberg/.dotfiles
```

## Usage

You can see the current tasks by running `just --list`

```bash
 just --list
Available recipes:
    brew            # update homebrew
    fix-shell-files # fix shell files. this happens sometimes with nix-darwin
    flake-update    # update your flake.lock
    hm              # run home-manager switch
    rebuild         # rebuild either nix-darwin or NixOS
```
