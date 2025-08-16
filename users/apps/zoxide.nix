{ config, lib, pkgs, ... }:
let
in {
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
