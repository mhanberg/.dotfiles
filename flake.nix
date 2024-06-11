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
  } @ inputs: {
    darwinConfigurations."alt-mhanberg" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit self;};
      modules = [
        ./nix/darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mitchell = {
            imports = [
              ghostty.homeModules.default
              ./nix/home/work.nix
            ];
          };
        }
      ];
    };
    darwinConfigurations."mitchells-mini" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit self;};
      modules = [
        ./nix/darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mitchell = {
            imports = [
              ghostty.homeModules.default
              ./nix/home/personal.nix
            ];
          };
        }
      ];
    };
    darwinConfigurations."mitchells-air" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit self;};
      modules = [
        ./nix/darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mitchell = {
            imports = [
              ghostty.homeModules.default
              ./nix/home/personal.nix
            ];
          };
        }
      ];
    };

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        # > Our main nixos configuration file <
        modules = [./nix/nixos/configuration.nix];
      };
    };

    homeConfigurations = {
      "mitchell@nublar" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ghostty.homeModules.default
          ./nix/home/nublar.nix
        ];
      };
      "mitchell@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ghostty.homeModules.default
          ./nix/home/nixos.nix
        ];
      };
    };
  };
}
