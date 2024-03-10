{
  description = "A very basic flake";

  inputs = {
    # Nix packagers	
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-nvim = {
      url = "github:JoakimPaulsson/nix-neovim-build";
      flake = false;
    };

    nix-search-cli = {
      url = "github:peterldowns/nix-search-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs @ { self, nixpkgs, unstable, home-manager, nh, nix-search-cli, ... }:
    let
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
      overlays = [
        (final: prev: { neovim = final.callPackage inputs.my-nvim { }; })
      ];
      pkgs = import nixpkgs {
        inherit system config overlays;
      };
      unstablePkgs = import unstable {
        inherit system config overlays;
      };
    in
    {
      nixosConfigurations = {
        joakimp = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              _module.args = { inherit unstablePkgs; };
            }
            {
              home-manager = {
                extraSpecialArgs = { inherit nh unstablePkgs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.joakimp = import ./home.nix;
              };
            }
          ];
        };
      };
    };
}
