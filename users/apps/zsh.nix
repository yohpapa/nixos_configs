{ config, lib, pkgs, ... }:
let
in {
  programs.zsh = {
    enable = true;
    # dotDir = ".config/zsh";

    shellAliases = {
      ls = "eza --icons=always";
      ll = "eza --icons=always --long";
      la = "eza --icons=always --all";
      tree = "eza -T";
      cat = "bat";
      c = "clear";
      vi = "nvim";
      top = "btop";
      cd = "z";
    };

    defaultKeymap = "emacs";
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    # History settings
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      size = 10000;
      save = 10000;
      share = true;
      append = true;
      expireDuplicatesFirst = true;
      extended = true;
      findNoDups = true;
      ignoreDups = true;
      saveNoDups = true;
      ignoreSpace = true;
      ignoreAllDups = true;
    };
    historySubstringSearch = {
      enable = true;
      searchUpKey = ["^[[p"];
      searchDownKey = ["^[[n"];
    };

    initContent = ''
      # Completion styling
      # Note:
      # Completions should be configured before compinit, as stated in the zsh-completions manual
      # installation guide. -- https://github.com/Aloxaf/fzf-tab
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons=always --all ''$realpath'
      zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza --icons=always --all ''$realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --icons=always -all ''$realpath'
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
      zstyle ':fzf-tab:*' popup-min-size 100 20
    '';

    envExtra = ''
      # General environment
      export EDITOR="nvim"
      export PATH=''$PATH:''$HOME/go/bin
    '';
  };
}
