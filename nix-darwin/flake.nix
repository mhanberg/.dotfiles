{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    neovim-nightly-overlay,
  }: let
    configuration = {pkgs, ...}: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      nix.settings.trusted-users = ["mitchell"];

      # Create /etc/zshrc that loads the nix-darwin environment.
      # programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      programs.zsh.enable = true;
      homebrew.enable = true;
      homebrew.onActivation.cleanup = "uninstall";
      homebrew.brews = [
        "agg"
        "alerter"
        "aom"
        "apr"
        "apr-util"
        "argon2"
        "asciinema"
        "aspell"
        "asyncapi"
        "autoconf"
        "automake"
        "avro-c"
        "awscli"
        "awslogs"
        "base64"
        "bash"
        "bash-completion"
        "bdw-gc"
        "berkeley-db"
        "berkeley-db@5"
        "brotli"
        "btop"
        "c-ares"
        "ca-certificates"
        "cairo"
        "capstone"
        "ccache"
        "cffi"
        "cmake"
        "coreutils"
        "cowsay"
        "ctags"
        "curl"
        "deno"
        "direnv"
        "docutils"
        "dtc"
        "dust"
        "elixir"
        "emacs"
        "emscripten"
        "erlang"
        "exa"
        "fd"
        "figlet"
        "fontconfig"
        "fop"
        "freetds"
        "freetype"
        "fribidi"
        "fswatch"
        "fzf"
        "gcc"
        "gd"
        "gdbm"
        "gdk-pixbuf"
        "geckodriver"
        "genext2fs"
        "gettext"
        "gh"
        "ghostscript"
        "giflib"
        "gist"
        "git"
        "git-crypt"
        "git-delta"
        "glib"
        "glow"
        "gmp"
        "gnu-sed"
        "gnupg"
        "gnutls"
        "go"
        "gobject-introspection"
        "gopls"
        "graphite"
        "graphite2"
        "graphviz"
        "groff"
        "gts"
        "guile"
        "harfbuzz"
        "helix"
        "helm"
        "heroku"
        "heroku-node"
        "highlight"
        "highway"
        "hiredis"
        "icu4c"
        "imath"
        "imgcat"
        "isl"
        "jansson"
        "jasper"
        "jbig2dec"
        "jpeg"
        "jpeg-turbo"
        "jpeg-xl"
        "kafka"
        "kcat"
        "krb5"
        "kubernetes-cli"
        "libassuan"
        "libavif"
        "libevent"
        "libffi"
        "libgcrypt"
        "libgit2"
        "libgpg-error"
        "libidn"
        "libidn2"
        "libksba"
        "liblinear"
        "libmpc"
        "libnghttp2"
        "libpaper"
        "libpng"
        "libpq"
        "libpthread-stubs"
        "librdkafka"
        "librsvg"
        "libserdes"
        "libslirp"
        "libsodium"
        "libssh"
        "libssh2"
        "libtasn1"
        "libtermkey"
        "libtiff"
        "libtool"
        "libunistring"
        "libusb"
        "libuv"
        "libvmaf"
        "libvterm"
        "libx11"
        "libxau"
        "libxcb"
        "libxdmcp"
        "libxext"
        "libxml2"
        "libxrender"
        "libxslt"
        "libyaml"
        "libzip"
        "little-cms2"
        "loc"
        "lolcat"
        "lua"
        "lua-language-server"
        "lua@5.3"
        "luajit"
        "luajit-openresty"
        "luarocks"
        "luv"
        "lynx"
        "lz4"
        "lzlib"
        "lzo"
        "m4"
        "make"
        "markdown"
        "mdcat"
        "minikube"
        "mpdecimal"
        "mpfr"
        "msgpack"
        "ncurses"
        "neofetch"
        "netcat"
        "netpbm"
        "nettle"
        "ninja"
        "nmap"
        "nnn"
        "node"
        "node@16"
        "npth"
        "nushell"
        "oniguruma"
        "openapi-generator"
        "openexr"
        "openjdk"
        "openjdk@11"
        "openjpeg"
        "openldap"
        "openssl@1.1"
        "openssl@3"
        "p11-kit"
        "pango"
        "parity"
        "pcre"
        "pcre2"
        "perl"
        "pgformatter"
        "php"
        "pinentry"
        "pixman"
        "pkg-config"
        "popt"
        "postgresql"
        "postgresql@14"
        "psutils"
        "pycparser"
        "python-setuptools"
        "python@3.10"
        "python@3.11"
        "python@3.12"
        "python@3.9"
        "pyyaml"
        "qemu"
        "rabbitmq"
        "readline"
        "ripgrep"
        "rsync"
        "rtmpdump"
        "ruby"
        "rust-analyzer"
        "screenresolution"
        "selenium-server"
        "shellcheck"
        "shfmt"
        "six"
        "sl"
        "snappy"
        "speedtest"
        "telnet"
        "terminal-notifier"
        "the_silver_searcher"
        "tidy-html5"
        "tmate"
        "tree"
        "uchardet"
        "unbound"
        "unibilium"
        "unixodbc"
        "unzip"
        "utf8proc"
        "vale"
        "vde"
        "vim"
        "watchexec"
        "webp"
        "websocat"
        "weechat"
        "wget"
        "wxwidgets"
        "xorgproto"
        "xxhash"
        "xz"
        "yajl"
        "youtube-dl"
        "yuicompressor"
        "zk"
        "zookeeper"
        "zsh"
        "zstd"
      ];
      homebrew.casks = [
        "1password"
        "1password-cli"
        "adoptopenjdk8"
        "alacritty"
        "alfred"
        "aws-vpn-client"
        "bartender"
        "chromedriver"
        "dash"
        "deckset"
        "discord"
        "divvy"
        "docker"
        "dropbox"
        "element"
        "elgato-control-center"
        "elgato-stream-deck"
        "farrago"
        "figma"
        "firefox"
        "firefox-developer-edition"
        "font-inter"
        "font-jetbrains-mono"
        "font-jetbrains-mono-nerd-font"
        "font-work-sans"
        "gitpigeon"
        "hammerspoon"
        "iterm2"
        "itsycal"
        "karabiner-elements"
        "kindle"
        "kitty"
        "loopback"
        "nordvpn"
        "notion"
        "obs"
        "pocket-casts"
        "postgres-unofficial"
        "postico"
        "screenflow"
        "slack"
        "soundsource"
        "sublime-merge"
        "tailscale"
        "tuple"
        "via"
        "visual-studio-code"
        "vlc"
        "wezterm-nightly"
        "zed"
        "zeplin"
        "zoom"
        "zsa-wally"
      ];

      nixpkgs.config.allowUnfree = true;
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          nixpkgs.overlays = [neovim-nightly-overlay.overlay];
        }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mitchell = import ../home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."simple".pkgs;
  };
}
