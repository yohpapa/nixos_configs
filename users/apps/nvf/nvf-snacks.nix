{ config, lib, pkgs, ... }:
let
in {
  programs.nvf.settings.vim.utility.snacks-nvim = {
    enable = true;
  };
}
