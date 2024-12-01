{
  description = "home-manager and nix-darwin configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    ghostty-hm.url = "github:clo4/ghostty-hm-module";
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    ghostty-hm,
    ghostty,
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
        modules = [ghostty-hm.homeModules.default] ++ extraModules;
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
      alt-mhanberg = mkDarwin {
        extraDarwinModules = [./nix/darwin/alt-mhanberg.nix];
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
          {
            home.packages = [ghostty.packages.x86_64-linux.default];
          }
        ];
        arch = "x86_64-linux";
      };
      "mitchell@nixos" = mkHm {
        extraModules = [./nix/home/nixos.nix];
        arch = "x86_64-linux";
      };
      "mitchell@alt-mhanberg" = mkHm {
        extraModules = [./nix/home/work.nix];
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
