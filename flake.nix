{
  description = "home-manager and nix-darwin configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    ghostty.url = "github:clo4/ghostty-hm-module";
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
        modules = [ghostty.homeModules.default] ++ extraModules;
      };
  in {
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
        extraModules = [./nix/home/nublar.nix];
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
