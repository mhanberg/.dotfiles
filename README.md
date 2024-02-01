![Open Graph Image](https://res.cloudinary.com/mhanberg/image/upload/v1590506591/dotfiles-social.png)

These dotfiles are now managed using Nix on macOS and Linux.

macOS utilizes nix-darwin in order to manage homebrew dependencies, and both macOS and Linux utilize home-manager for dotfiles and nixpkgs.

I haven't yet set up a new computer with the Nix setup, so I don't have the fresh install instructions ready, but the maintenance instructions are documented.

## macOS

```bash
darwin-rebuild switch --flake ~/.dotfiles/nix-darwin#simple
```

## Linux

```bash
home-manager switch --flake ~/.dotfiles
```

## Old

### Install

Clone this repository into your home directory.

```shell
cd ~
git clone git@github.com:mhanberg/.dotfiles.git
```

To bootstrap a new machine, run the `install` script.

```shell
~/.dotfiles/install
```

To only install the dotfiles, run the `rcup` script.

```shell
~/.dotfiles/rcup
```

### Bootstrap

The curl flags are copied from the Homebrew install method. I'm not entirely sure what they do tbh.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mhanberg/.dotfiles/main/bootstrap.bash)"
```
