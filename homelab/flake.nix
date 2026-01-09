{
  description = "Homelab NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      hostName = "homelab";
      platform = "x86_64-linux";
    in {
      nixosConfigurations = {
        ${hostName} = nixpkgs.lib.nixosSystem {
          system = platform;
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
}

