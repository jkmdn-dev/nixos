{
  description = "A very basic flake";

  inputs = {
    # Nix packagers	
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

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
    # Neovim config
    neovim-config = {
      url = "git+file:///etc/nixos/neovim-config";
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      config = { allowUnfree = true; };
      pkgs = import nixpkgs {
        inherit system config;
        overlays = [
          (final: prev: { neovim = final.callPackage inputs.my-nvim { }; })
        ];
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
              home-manager = {
                extraSpecialArgs = inputs;
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

