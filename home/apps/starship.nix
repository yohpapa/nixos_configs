{ config, lib, pkgs, ... }:
let
in {
  programs.starship = {
    enable = true;
    # configPath = "${config.xdg.configHome}/starship/starship.toml";
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      command_timeout = 2000;
      format = lib.concatStrings [
        "$env_var"
        "$os"
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$python\n"
        "$character"
      ];

      character = {
        success_symbol= "╰─[](bold green)";
        error_symbol= "╰─[](bold red)";
      };

      env_var = {
        symbol = "╭╴";
        variable = "SHELL";
        format = "$symbol";
        disabled = false;
      };

      os = {
        format = "[$symbol](bold white) ";
        disabled = false;
      	symbols = {
          Windows = " ";
          Arch = "󰣇";
          Ubuntu = "";
          Macos = "󰀵";
          Unknown = "󰠥";
        };
      };

      username = {
        style_user = "yellow bold";
        style_root = "black bold";
        format = "[|](black bold) [$user](#2883ff) "; # 2883ff
        disabled = false;
        show_always = true;
      };

      hostname = {
        ssh_only = false;
        format = "[|](black bold) [$hostname](bold blue) ";
        disabled = false;
      };

      directory = {
        truncation_length = 0;
        truncation_symbol = "…/";
        home_symbol = "~";
        read_only = "  ";
        format = "[|](black bold) [$path]($style)[$read_only]($read_only_style) ";
        style = "#7ed1fb"; # yellow bold
      };

      git_branch = {
        # symbol = " ";
        symbol = " ";
        format = "[|](black bold) [$symbol\\[$branch\\]]($style) ";
        style = "bold green";
      };

      git_status = {
      	format = "[ $all_status $ahead_behind]($style) ";
      	style = "bold green";
      	conflicted = "🏳 ";
      	up_to_date = "";
      	untracked = " ";
        ahead = "⇡$count";
      	diverged = "⇕⇡$ahead_count⇣$behind_count";
      	behind = "⇣$count";
      	stashed = " ";
      	modified = " ";
      	staged = "[++\\($count\\)](green)";
      	renamed = "襁 ";
      	deleted = " ";
      };

      python = {
        symbol = "󰌠";
        python_binary = ["./venv/bin/python" "python" "python3" "python2"];
        format = "[|](black bold) [$symbol $pyenv_prefix($version )(\\($virtualenv\\) )]($style) ";
      };
    };
  };
}
