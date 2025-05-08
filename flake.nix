{
  description = "home-manager and nix-darwin configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rummage = {
      url = "github:mhanberg/rummage";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    lix-module,
    agenix,
    rummage,
  }: let
    mkDarwin = {extraDarwinModules ? {}}:
      nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit self;};
        modules =
          [
            lix-module.nixosModules.default
            ./nix/darwin.nix
          ]
          ++ extraDarwinModules;
      };
    mkHm = {
      extraModules ? [],
      arch,
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${arch};
        modules =
          [
            ./nix/home
            agenix.homeManagerModules.default
            {
              home.packages = [
                rummage.packages.${arch}.default
                agenix.packages.${arch}.default
              ];
            }
            ./nix/home/diy/gh-actions-language-server
            rummage.homeManagerModules.default
          ]
          ++ extraModules;
      };
    mkInit = {
      system,
      script ? ''
        git clone https://github.com/mhanberg/.dotfiles ~/.dotfiles
        nix run home-manager/master -- switch --flake ~/.dotfiles
      '',
    }: let
      pkgs = nixpkgs.legacyPackages.${system};
      init = pkgs.writeShellApplication {
        name = "init";
        text = script;
      };
    in {
      type = "app";
      program = "${init}/bin/init";
    };
  in {
    apps."aarch64-darwin".default = mkInit {
      system = "aarch64-darwin";
      script = ''
        git clone https://github.com/mhanberg/.dotfiles ~/.dotfiles
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        nix run nix-darwin -- switch --flake ~/.dotfiles
        nix run home-manager/master -- switch --flake ~/.dotfiles
      '';
    };
    apps."x86_64-linux".default = mkInit {system = "x86_64-linux";};
    apps."aarch64-linux".default = mkInit {system = "aarch64-linux";};

    darwinConfigurations = {
      mhanberg-GQJNV7J4QY = mkDarwin {
        extraDarwinModules = [./nix/darwin/dk.nix];
      };
      mitchells-mini = mkDarwin {
        extraDarwinModules = [./nix/darwin/personal.nix];
      };
      mitchells-air = mkDarwin {
        extraDarwinModules = [./nix/darwin/personal.nix];
      };
    };

    homeConfigurations = {
      "mitchell@nublar" = mkHm {
        extraModules = [./nix/home/nublar.nix];
        arch = "x86_64-linux";
      };
      "ubuntu@ubuntu" = mkHm {
        extraModules = [./nix/home/ubuntu.nix];
        arch = "aarch64-linux";
      };
      "mitchell@nixos" = mkHm {
        extraModules = [./nix/home/nixos.nix];
        arch = "x86_64-linux";
      };
      "m.hanberg" = mkHm {
        extraModules = [./nix/home/dk.nix];
        arch = "aarch64-darwin";
      };
      "mitchell@mitchells-mini" = mkHm {
        extraModules = [./nix/home/personal.nix];
        arch = "aarch64-darwin";
      };
      "mitchell@mitchells-air" = mkHm {
        extraModules = [./nix/home/personal.nix];
        arch = "aarch64-darwin";
      };
    };
  };
}
