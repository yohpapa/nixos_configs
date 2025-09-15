{
  description = "My flake based on youtu.be/AcybVzRvDhs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = { nixpkgs, xremap-flake, ... }:
    let
      # ---- System settings ---- #
      systemSettings = {
        system = "x86_64-linux";
        hostname = "nixos";
        profile = "ws";
        timezone = "Asia/Tokyo";
        defaultLocale = "en_US.UTF-8";
        extraLocale = "ja_JP.UTF-8";
        maxBackups = 5;
      };

      # ---- User settings ---- #
      userSettings = {
        username = "unamomo";
        name = "Kensuke Nakai";
      };
    in {
      # sudo nix-collect-garbage -d && sudo nixos-rebuild switch --flake .
      nixosConfigurations.${systemSettings.hostname} = nixpkgs.lib.nixosSystem {
        modules = [
          xremap-flake.nixosModules.default
          ./configs/${systemSettings.profile}/configuration.nix
        ];
        specialArgs = {
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };
}
