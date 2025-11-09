{
  description = "My flake based on youtu.be/AcybVzRvDhs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    xremap.url = "github:xremap/nix-flake";
    ghostty.url = "github:ghostty-org/ghostty";
    neovim-pkgs.url =
      "github:nixos/nixpkgs/bce5fe2bb998488d8e7e7856315f90496723793c";
    sddm-stray.url = "github:Bqrry4/sddm-stray";
  };

  outputs = { nixpkgs, xremap, ghostty, neovim-pkgs, sddm-stray, ... }:
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
          ./configs/${systemSettings.profile}/configuration.nix
        ];
        specialArgs = {
          inherit systemSettings;
          inherit userSettings;
          neovim-pkgs = import neovim-pkgs { system = systemSettings.system; };
          ghostty = ghostty.packages.${systemSettings.system}.default;
          sddm-stray = sddm-stray.packages.${systemSettings.system}.default;
        };
      };
    };
}
