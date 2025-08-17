{ config, lib, pkgs, ... }:
let
in {
  programs.nvf.settings.vim = {
    treesitter = {
      enable = true;
      incrementalSelection.enable = true;
      highlight.enable = true;
      indent.enable = true;
    };

    languages = {
      # enableTreesitter = true;
      bash.treesitter.enable = true;
      # css.treesitter.enable = true;
      clang.treesitter.enable = true;
      # html.treesitter.enable = true;
      java.treesitter.enable = true;
      markdown.treesitter.enable = true;
      nix.treesitter.enable = true;
      lua.treesitter.enable = true;
      yaml.treesitter.enable = true;
    };
  };
}
