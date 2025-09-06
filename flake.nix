{ description = "My flake based on youtu.be/AcybVzRvDhs";

  inputs = {
    # NOTE: Building hyprland fails with nixos-25.05
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
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
  in
  {
    # sudo nix-collect-garbage -d && sudo nixos-rebuild switch --flake .
    nixosConfigurations.${systemSettings.hostname} = nixpkgs.lib.nixosSystem {
      modules = [ ./configs/${systemSettings.profile}/configuration.nix ];
      specialArgs = {
        inherit systemSettings;
        inherit userSettings;
      };
    };
  };
}
