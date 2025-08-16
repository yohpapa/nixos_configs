{ config, lib, pkgs, ... }:
let
in {
  programs.nvf.settings.vim.binds.whichKey = {
    enable = true;

    register = {
      "<leader>b" = " buffers";
      "<leader>f" = " telescope";
      "<leader>s" = " window";
      "<leader>e" = " files";
      "<leader>n" = " noice";
      "<leader>t" = " tab";
      "<leader>g" = " diagnostics";
      "<leader>r" = " laungages";
    };

    setupOpts = {
      preset = "modern";
      notify = true;
    };
  };
}
