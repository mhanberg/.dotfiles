![Open Graph Image](https://res.cloudinary.com/mhanberg/image/upload/v1590506591/dotfiles-social.png)

## Install

Clone this repository into your home directory.

```shell
$ cd ~
$ git clone git@github.com:mhanberg/.dotfiles.git
```

To bootstrap a new machine, run the `install` script.

```shell
$ ~/.dotfiles/install
```

To only install the dotfiles, run the `rcup` script.

```shell
$ ~/.dotfiles/rcup
```

## Bootstrap

The curl flags are copied from the Homebrew install method. I'm not entirely sure what they do tbh.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mhanberg/.dotfiles/main/bootstrap.bash)"
```
