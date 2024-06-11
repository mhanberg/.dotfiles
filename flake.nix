{
  description = "home-manager and nix-darwin configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    mkDarwin = {
      extraHmModules,
      extraDarwinModules ? {},
    }:
      nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit self;};
        modules =
          [./nix/darwin.nix]
          ++ extraDarwinModules
          ++ [
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.mitchell = {
                imports = [ghostty.homeModules.default] ++ extraHmModules;
              };
            }
          ];
      };
    mkHm = extraHmModules:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [ghostty.homeModules.default] ++ extraHmModules;
      };
  in {
    darwinConfigurations = {
      alt-mhanberg = mkDarwin {
        extraDarwinModules = [./nix/darwin/alt-mhanberg.nix];
        extraHmModules = [./nix/home/work.nix];
      };
      mitchells-mini = mkDarwin {
        extraDarwinModules = [./nix/darwin/personal.nix];
        extraHmModules = [./nix/home/work.nix];
      };
      mitchells-air = mkDarwin {
        extraDarwinModules = [./nix/darwin/personal.nix];
        extraHmModules = [./nix/home/work.nix];
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
      "mitchell@nublar" = mkHm [./nix/home/nublar.nix];
      "mitchell@nixos" = mkHm [./nix/home/nixos.nix];
    };
  };
}
