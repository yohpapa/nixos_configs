{ config, lib, pkgs, ... }:
let
in {
  programs.nvf.settings.vim.lazy = {
    enable = true;

    # NOTE: event types
    # "BufReadPost" "BufNewFile" "BufWritePre"
    plugins = with pkgs.vimPlugins; {

      ${noice-nvim.pname} = {
        package = noice-nvim;
        lazy = true;
        event = [ {event = "User"; pattern = "LazyFile";} ];
      };

      ${nvim-treesitter.pname} = {
        package = nvim-treesitter;
        lazy = true;
        event = [ {event = "User"; pattern = "BufNewFile";} ];
      };

      ${which-key-nvim.pname} = {
        package = which-key-nvim;
        lazy = true;
        event = [ {event = "User"; pattern = "LazyFile";} ];
      };
    };
  };
}
