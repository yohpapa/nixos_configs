{ config, lib, pkgs, ... }:
let
in {
  programs.nvf.settings.vim.telescope = {
    enable = true;
    extensions = [{
      name = "fzf";
      packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
      setup.fzf.fuzzy = true;
    }];

    mappings = {
      findFiles = "<leader>ff";
      liveGrep  = "<leader>fg";
      buffers   = "<leader>fb";
      helpTags  = "<leader>fh";
    };

    setupOpts.defaults.color_devicons = true;
  };
}
