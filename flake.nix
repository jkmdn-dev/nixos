{
  description = "A very basic flake";

  inputs = {
    # Nix packagers	
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
  
    hyprland.url = "github:hyprwm/Hyprland";

  };

  outputs = inputs @ { self, nixpkgs, home-manager, nh, nix-search-cli, hyprland, ... }:
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
      specialArgs = {
        inherit hyprland nh;
      };
    in
    {
      nixosConfigurations = {
        joakimp = nixpkgs.lib.nixosSystem {
          inherit system pkgs specialArgs;
          modules = [
            ./configuration.nix
            hyprland.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = specialArgs; 
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
