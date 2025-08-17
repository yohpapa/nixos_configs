{ config, lib, pkgs, ... }:
let
in {
  programs.nvf.settings.vim.languages = {
    nix = {
      enable = true;
      extraDiagnostics.enable = true;
      format.enable = true;
      lsp = {
        enable = true;
        server = "nixd";
      };
    };
    haskell = {
      enable = true;
      lsp.enable = true;
    };
  };
}
