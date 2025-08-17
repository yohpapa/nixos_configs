{ config, lib, pkgs, ... }:
let
in {
  programs.nvf.settings.vim.filetree.nvimTree = {
    enable = true;
    openOnSetup = false;
    setupOpts = {
      view = {
        width = 35;
        relativenumber = true;
        float.enable = true;
      };

      renderer = {
        indent_markers.enable = true;
        icons = {
          glyphs.folder = {
            arrow_closed = "";
            arrow_open = "";
          };
          show.git = true;
        };
        highlight_git = true;
        highlight_modified = "icon";
        highlight_opened_files = "icon";
      };

      actions.open_file.window_picker.enable = false;

      git.enable = true;
      disable_netrw = true;
      modified.enable = true;
    };

    mappings = {
      findFile = "<leader>ef";
      toggle = "<leader>ee";
      refresh = "<leader>er";
    };
  };
}
