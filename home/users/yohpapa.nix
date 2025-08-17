{ config, lib, pkgs, systemSettings, userSettings, ... }:
let
in {
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";
  home.stateVersion = "25.11";

  # NOTE: Refer to the below
  # - https://nix-community.github.io/home-manager/options.xhtml
  # - 
  home.packages = with pkgs; [
    # cli tools
    eza
    bat
    neovim
    btop
    tmux
    zoxide
    fzf
    starship
    zsh-history-substring-search
    disfetch

    # wayland tools
    waybar
    # mako
    # swww
    # hyprlock
    # pavucontrol
    rofi-wayland
    # networkmanagerapplet
    ghostty
    # swaync
    # hypridle

    # fonts
    font-awesome
  ];

  imports = [
    ../apps/zsh.nix
    ../apps/zoxide.nix
    ../apps/fzf.nix
    ../apps/starship.nix
    ../apps/tmux.nix
    ../apps/nvf.nix
    ../apps/hyprland.nix
    ../apps/waybar.nix
    ../apps/ghostty.nix
    ../apps/git.nix
  ];

  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/yohpapa/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
     EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
