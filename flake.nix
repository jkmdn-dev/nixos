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

    my-nvim = {
      url = "github:JoakimPaulsson/nix-neovim-build";
      flake = false;
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nh-input = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-search-cli-input = {
      url = "github:peterldowns/nix-search-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gc-env.url = "github:Julow/nix-gc-env";

    hyprland = { 
      url = "https://github.com/hyprwm/Hyprland.git?ref=v.43&submodules=1";
      type = "git";
      submodules = true;
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, nh-input, hyprland
    , nix-search-cli-input, neovim-nightly-overlay, nix-gc-env, ... }:
    let
      system = "x86_64-linux";

      config = {
        allowUnfree = true;
        hardware = {
          opengl = let
            fn = oa: {
              nativeBuildInputs = oa.nativeBuildInputs ++ [ nixpkgs.glslang ];
              mesonFlags = oa.mesonFlags
                ++ [ "-Dvulkan-layers=device-select,overlay" ];
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
          in with nixpkgs; {
            enable = true;
            driSupport32Bit = true;
            package = (mesa.overrideAttrs fn).drivers;
            package32 = (pkgsi686Linux.mesa.overrideAttrs fn).drivers;
          };
        };
      };

      overlays = [];

        # [ (final: prev: { neovim = final.callPackage inputs.my-nvim { }; }) ];

      pkgs = import nixpkgs { inherit system config overlays; };

      pkgsWSL = import nixpkgs { inherit system overlays; };

      nh = nh-input.packages.${system}.default;
      nix-search-cli = nix-search-cli-input.packages.${system}.default;

      specialArgs = { inherit hyprland nh nix-search-cli nix-gc-env; };

      supportedSystems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems
        (system: f { pkgs = import nixpkgs { inherit system; }; });
    in {

      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [ nushell fnlfmt fennel-ls nixfmt-rfc-style nil ];
        };
      });

      nixosConfigurations = {
        joakimp-wsl = nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = pkgsWSL;
          modules = [
            ./configurationWSL.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.joakimp = import ./home-joakimp-wsl.nix;
              };
            }
          ];
        };

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
                users.joakimp = import ./home-joakimp.nix;
              };
            }
          ];
        };
      };
    };
}
