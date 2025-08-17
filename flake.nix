{ description = "My flake based on youtu.be/AcybVzRvDhs";

  inputs = {
    # NOTE: Building hyprland fails with nixos-25.05
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nvf, hyprland, ... }:
  let
    # ---- System settings ---- #
    systemSettings = {
      system        = "x86_64-linux";
      hostname      = "nixos";
      profile       = "vm";
      timezone      = "Asia/Tokyo";
      defaultLocale = "en_US.UTF-8";
      extraLocale   = "ja_JP.UTF-8";
      maxBackups    = 5;
    };

    # ---- User settings ---- #
    userSettings = {
      username      = "yohpapa";
      name          = "Yohpapa";
    };

    # ---- Local aliases ---- #
    pkgs = nixpkgs.legacyPackages.${systemSettings.system};
  in
  {
    nixosConfigurations.${systemSettings.hostname} = nixpkgs.lib.nixosSystem {
      system = systemSettings.system;
      modules = [
        ./configs/${systemSettings.profile}/configuration.nix 
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${userSettings.username}.imports = [
              ./home/users/${userSettings.username}.nix
              nvf.homeManagerModules.default
              {
                wayland.windowManager.hyprland = {
                  package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
                  portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
                };
              }
            ];
            extraSpecialArgs = {
              inherit systemSettings;
              inherit userSettings;
            };
	        };
        }
      ];
      specialArgs = {
        inherit systemSettings;
        inherit userSettings;
      };
    };
  };
}
