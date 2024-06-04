{
  description = "home-manager and nix-darwin configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
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
  }: let
    darwinSystem = {
      system = "aarch64-darwin";
      specialArgs = {inherit self;};
      modules = [
        ./nix/darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mitchell = import ./nix/home.nix;
        }
      ];
    };
  in {
    darwinConfigurations."alt-mhanberg" = nix-darwin.lib.darwinSystem darwinSystem;
    darwinConfigurations."mitchells-mini" = nix-darwin.lib.darwinSystem darwinSystem;
    darwinConfigurations."mitchells-air" = nix-darwin.lib.darwinSystem darwinSystem;

    homeConfigurations."mitchell" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [
        ./nix/home.nix
      ];
    };
  };
}
