{ config, lib, pkgs, ... }:
let
in {
  programs.nvf.settings.vim = {

    # theme
    theme = {
      enable = true;
      name = "catppuccin";
      style = "frappe";
      transparent = true;
    };

    # bufferline
    tabline.nvimBufferline = {
      enable = true;
      setupOpts.options = {
        mode = "tabs";
        separator_style = "thin";
      };
    };
  };
}
