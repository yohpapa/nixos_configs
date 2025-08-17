{ config, lib, pkgs, ... }:
let
in {
  programs.nvf.settings.vim.notify.nvim-notify = {
    enable = true;
  };
}
