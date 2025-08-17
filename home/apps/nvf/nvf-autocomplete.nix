{ config, lib, pkgs, ... }:
let
in {
  programs.nvf.settings.vim = {
    autocomplete.nvim-cmp = {
      enable = true;
      sourcePlugins = [
        "luasnip"
      ];

      sources = {
        nvim-cmp = "nvim_lsp";
        luasnip = "luasnip";
        buffer = "buffer";
        path = "path";
      };
    };

    ui.borders.plugins.nvim-cmp = {
      enable = true;
      style = "rounded";
    };
  };  
}
