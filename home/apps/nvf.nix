{ config, lib, pkgs, ... }:
let
in {
  imports = [
    ./nvf/nvf-keymaps.nix
    ./nvf/nvf-theme.nix
    ./nvf/nvf-lualine.nix
    ./nvf/nvf-noice.nix
    ./nvf/nvf-tree.nix
    ./nvf/nvf-snacks.nix
    ./nvf/nvf-telescope.nix
    ./nvf/nvf-treesitter.nix
    ./nvf/nvf-whichkey.nix
    ./nvf/nvf-notify.nix
    ./nvf/nvf-lazy.nix
    ./nvf/nvf-languages.nix
    ./nvf/nvf-autocomplete.nix
    ./nvf/nvf-toggleterm.nix
  ];

  # NOTE: https://notashelf.github.io/nvf/options.html
  programs.nvf = {
    enable = true;

    settings.vim = {

      viAlias = false;
      vimAlias = true;

      # line numbers
      lineNumberMode = "relNumber";

      # clipboard
      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      # search settings
      searchCase = "smart";

      options = {

        # Tab & Indentation
        tabstop = 2;
        shiftwidth = 2;
        # opt.softtabstop = 2  # NA in nvf
        # opt.expandtab = true # NA in nvf
        autoindent = true;

        # Line wrapping
        wrap = false;

        # cursor line
        cursorlineopt = "screenline"; # or "both"

        # appearance
        termguicolors = true;
        # opt.background = "dark" # NA in nvf
        # opt.signcolumn = "yes"  # NA in nvf

        # backspace
        # opt.backspace = "indent,eol,start" # Not exist in nvf

        # split windows
        splitright = true;
        splitbelow = true;

        # consider "-" as part of keyword
        # opt.iskeyword:append("-") # NA in nvf
      };
    };
  };
}
