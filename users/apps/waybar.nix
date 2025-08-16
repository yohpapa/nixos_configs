{ config, lib, pkgs, ... }:
let
in {
  programs.waybar = {
    enable = true;
  };
}
