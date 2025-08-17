{ config, lib, pkgs, ... }:
let
in {
  programs.git = {
    enable = true;
    userName = "Kensuke Nakai";
    userEmail = "kemumaki.kemuo@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
