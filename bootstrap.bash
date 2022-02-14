# shellcheck shell=bash

function fancy_echo() {
  local fmt="$1"
  shift

  # shellcheck disable=SC2059
  printf "\\n$fmt\\n" "$@"
}

function pause() {
  read -n 1 -p "Click any key to continue..." -s -e -r
}

function install_xcode() {
  fancy_echo "Installing XCode..."

  xcode-select --install
}

function install_brew() {
  fancy_echo "Installing Homebrew..."

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

function generate_ssh_key() {
  fancy_echo "Generating SSH key..."
  read -r -p "Enter your email: " email
  ssh-keygen -t ed25519 -C \""$email"\"

  fancy_echo "Copying public key to clipboard"
  pbcopy <"$HOME"/.ssh/id_ed25519.pub

  fancy_echo "Please upload to GitHub"
  pause

  fancy_echo "Starting ssh-agent"
  eval "$(ssh-agent -s)"

  fancy_echo "Adding ssh keys to Keychain"
  cat <<EOF >"$HOME"/.ssh/config
Host *
AddKeysToAgent yes
UseKeychain yes
IdentityFile ~/.ssh/id_ed25519
EOF

  fancy_echo "Adding key to agent"
  ssh-add -K "$HOME"/.ssh/id_rsa
}

function brew_bundle() {
  fancy_echo "Updating Homebrew formulae ..."
  brew bundle --file=- <<EOF
tap "mhanberg/tap"

brew "mhanberg/tap/mctl
EOF
}

function configure() {
  (
    fancy_echo "Moving to $HOME"
    cd "$HOME" || exit

    fancy_echo "Cloning .dotfiles"
    git clone git@github.com:mhanberg/.dotfiles.git

    fancy_echo "Moving to $HOME/.dotfiles"
    cd .dotfiles || exit

    fancy_echo "Running the install script"
    ./install
  )

}

function main() {
  install_xcode
  install_brew
  generate_ssh_key
  # brew_bundle
  configure

  fancy_echo "🍻 Success!"
}

main
