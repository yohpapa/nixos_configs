{
  description = "My flake based on youtu.be/AcybVzRvDhs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    xremap.url = "github:xremap/nix-flake";
    ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs = { nixpkgs, xremap, ghostty, ... }:
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
          xremap.nixosModules.default
          ({ pkgs, ... }: {
            environment.systemPackages =
              [ ghostty.packages.${systemSettings.system}.default ];
          })
          ./configs/${systemSettings.profile}/configuration.nix
        ];
        specialArgs = {
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };
}
