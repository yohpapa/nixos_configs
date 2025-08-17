{ config, lib, pkgs, ... }:
let
in {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installBatSyntax = true;

    settings = {
      theme = "catppuccin-mocha";
    };
  };
}
