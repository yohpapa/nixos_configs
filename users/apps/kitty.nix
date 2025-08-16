{ config, lib, pkgs, ... }:
let
in {
  programs.kitty = {
    enable = true;
  };
}
