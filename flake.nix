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
    };
  
    hyprland.url = "github:hyprwm/Hyprland";

  };

  outputs = inputs @ { self, nixpkgs, home-manager, nh, hyprland, nix-search-cli, ... }:
    let
      system = "x86_64-linux";

      config = {
        hardware = {
          opengl =
            let
              fn = oa: {
                nativeBuildInputs = oa.nativeBuildInputs ++ [ nixpkgs.glslang ];
                mesonFlags = oa.mesonFlags ++ [ "-Dvulkan-layers=device-select,overlay" ];
                postInstall = oa.postInstall + ''
                    mv $out/lib/libVkLayer* $drivers/lib

                    #Device Select layer
                    layer=VkLayer_MESA_device_select
                    substituteInPlace $drivers/share/vulkan/implicit_layer.d/''${layer}.json \
                      --replace "lib''${layer}" "$drivers/lib/lib''${layer}"

                    #Overlay layer
                    layer=VkLayer_MESA_overlay
                    substituteInPlace $drivers/share/vulkan/explicit_layer.d/''${layer}.json \
                      --replace "lib''${layer}" "$drivers/lib/lib''${layer}"
                  '';
              };
            in
            with nixpkgs; {
              enable = true;
              driSupport32Bit = true;
              package = (mesa.overrideAttrs fn).drivers;
              package32 = (pkgsi686Linux.mesa.overrideAttrs fn).drivers;
            };
          };
      };

      overlays = [
        (final: prev: { neovim = final.callPackage inputs.my-nvim { }; })
      ];

      pkgs = import nixpkgs {
        inherit system config overlays;
      };

      specialArgs = {
        inherit hyprland nh nix-search-cli;
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
