{ config, lib, pkgs, ... }:
let
in {
  programs.nvf.settings.vim.terminal.toggleterm = {
    enable = true;
    lazygit.enable = true;
  };
}
