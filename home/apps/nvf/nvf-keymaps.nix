{ config, lib, pkgs, ... }:
let
in {
  programs.nvf.settings.vim = {

    # set leader key to space
    globals.mapleader = " ";

    keymaps = [
      # general
      { mode = "i"; key = "jk";         action = "<ESC>";             desc = "Exit insert mode with jk"; }
      { mode = "n"; key = "<leader>no"; action = ":nohl<CR>";         desc = "Clear search highlights"; }

      # window management
      { mode = "n"; key = "<leader>s|"; action = "<C-w>v";            desc = "Split window vertically"; }
      { mode = "n"; key = "<leader>s-"; action = "<C-w>s";            desc = "Split window horizontally"; }
      { mode = "n"; key = "<leader>se"; action = "<C-w>=";            desc = "Make splits equal size"; }
      { mode = "n"; key = "<leader>sx"; action = "<cmd>close<CR>";    desc = "Close current split"; }
      { mode = "n"; key = "<leader>sj"; action = "<C-w>j";            desc = "Move the focus to the below window"; }
      { mode = "n"; key = "<leader>sk"; action = "<C-w>k";            desc = "Move the focus to the above window"; }
      { mode = "n"; key = "<leader>sh"; action = "<C-w>h";            desc = "Move the focus to the left window"; }
      { mode = "n"; key = "<leader>sl"; action = "<C-w>l";            desc = "Move the focus to the right window"; }

      # tab management
      { mode = "n"; key = "<leader>to"; action = "<cmd>tabnew<CR>";   desc = "Open new tab"; }
      { mode = "n"; key = "<leader>tx"; action = "<cmd>tabclose<CR>"; desc = "Close current tab"; }
      { mode = "n"; key = "<leader>tn"; action = "<cmd>tabn<CR>";     desc = "Go to next tab"; }
      { mode = "n"; key = "<leader>tp"; action = "<cmd>tabp<CR>";     desc = "Go to previous tab"; }
      { mode = "n"; key = "<leader>tf"; action = "<cmd>tabnew %<CR>"; desc = "Open current buffer in new tab"; }

      # noice
      { mode = "n"; key = "<leader>nl"; action = "<cmd>NoiceLast<CR>";    desc = "Show the last notification"; }
      { mode = "n"; key = "<leader>nh"; action = "<cmd>NoiceHistory<CR>"; desc = "Show the notification history"; }
      { mode = "n"; key = "<leader>nd"; action = "<cmd>NoiceDismiss<CR>"; desc = "Dismiss the notifications"; }

      # Diagnostics
      { mode = "n"; key = "gR";         action = "<cmd>Telescope lsp_references<CR>";         desc = "Show LSP references"; }
      { mode = "n"; key = "gD";         action = "<cmd>lua vim.lsp.buf.declaration, opts)";   desc = "Go to declaration"; }
      { mode = "n"; key = "gd";         action = "<cmd>Telescope lsp_definitions<CR>";        desc = "Show LSP definitions"; }
      { mode = "n"; key = "gi";         action = "<cmd>Telescope lsp_implementations<CR>";    desc = "Show LSP implementations"; }
      { mode = "n"; key = "gt";         action = "<cmd>Telescope lsp_type_definitions<CR>";   desc = "Show LSP type definitions"; }
      { mode = "n"; key = "K";          action = "<cmd>lua vim.lsp.buf.hover";                desc = "Show documentation for what is under cursor"; }
      { mode = "n"; key = "<leader>rs"; action = "<cmd>LspRestart<CR>";                       desc = "Restart LSP"; }
      { mode = "n"; key = "<leader>ge"; action = "<cmd>lua vim.diagnostic.open_float()<CR>";  desc = "Open diagnostic"; }
    ];
  };
}
