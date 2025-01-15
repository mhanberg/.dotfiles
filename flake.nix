{
  description = "home-manager and nix-darwin configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:anund/home-manager/ghostty_darwin_support";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rummage = {
      url = "github:mhanberg/rummage";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    rummage,
  } @ inputs: let
    mkDarwin = {extraDarwinModules ? {}}:
      nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit self;};
        modules = [./nix/darwin.nix] ++ extraDarwinModules;
      };
    mkHm = {
      extraModules ? [],
      arch,
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${arch};
        modules =
          [
            {
              home.packages = [rummage.packages.${arch}.default];
            }
          ]
          ++ extraModules;
      };
  in {
    apps."aarch64-darwin".default = let
      pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      init = pkgs.writeShellApplication {
        name = "init";
        runtimeInputs = with pkgs; [git curl bash];
        text = ''
          git clone https://github.com/mhanberg/.dotfiles ~/.dotfiles
          bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          nix run nix-darwin -- switch --flake ~/.dotfiles
          nix run home-manager/master -- switch --flake ~/.dotfiles
        '';
      };
    in {
      type = "app";
      program = "${init}/bin/init";
    };
    apps."x86_64-linux".default = let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      init = pkgs.writeShellApplication {
        name = "init";
        text = ''
          nix run home-manager/master -- switch --flake ~/.dotfiles
        '';
      };
    in {
      type = "app";
      program = "${init}/bin/init";
    };
    darwinConfigurations = {
      dk-mhanberg = mkDarwin {
        extraDarwinModules = [./nix/darwin/dk.nix];
      };
      alt-mhanberg = mkDarwin {
        extraDarwinModules = [./nix/darwin/sb.nix];
      };
      mitchells-mini = mkDarwin {
        extraDarwinModules = [./nix/darwin/personal.nix];
      };
      mitchells-air = mkDarwin {
        extraDarwinModules = [./nix/darwin/personal.nix];
      };
    };

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        # > Our main nixos configuration file <
        modules = [./nix/nixos/configuration.nix];
      };
    };

    homeConfigurations = {
      "mitchell@nublar" = mkHm {
        extraModules = [
          ./nix/home/nublar.nix
        ];
        arch = "x86_64-linux";
      };
      "mitchell@nixos" = mkHm {
        extraModules = [./nix/home/nixos.nix];
        arch = "x86_64-linux";
      };
      "m.hanberg@dk-mhanberg" = mkHm {
        extraModules = [./nix/home/dk.nix];
        arch = "aarch64-darwin";
      };
      "mitchell@alt-mhanberg" = mkHm {
        extraModules = [
          ./nix/home/sb.nix
          ./nix/home/diy/gh-actions-language-server
        ];
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
