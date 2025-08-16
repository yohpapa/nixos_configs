{ config, lib, pkgs, ... }:
let
in {
  programs.tmux = {
    enable = true;
    prefix = "C-u";
    shell = "${pkgs.zsh}/bin/zsh";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 5000;
    plugins = with pkgs; [
      { plugin = tmuxPlugins.yank;
        extraConfig = "set -g @yank_selection_mouse 'clipboard'"; }
      { plugin = tmuxPlugins.sensible; }
      { plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
	 set -g @catppuccin_flavor "mocha"
	 set -g @catppuccin_window_status_style "rounded"
	''; }
      # { plugin = "thesast/tmux-transient-status" }
      { plugin = tmuxPlugins.resurrect; }
      { plugin = tmuxPlugins.continuum; }
      { plugin = tmuxPlugins.cpu; }
      { plugin = tmuxPlugins.battery; }
      # { plugin = tmuxPlugins.vim-tmux-navigator;
      #    extraConfig = ''
      #     set -g @vim_navigator_mapping_left "M-h"
      #     set -g @vim_navigator_mapping_right "M-l"
      #     set -g @vim_navigator_mapping_up "M-k"
      #     set -g @vim_navigator_mapping_down "M-j"
      # ''; }
    ];
    terminal = "tmux-256color";
    extraConfig = ''
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Reload Config!!"
      bind e setw synchronize-panes on
      bind E setw synchronize-panes off
      bind - split-window -v -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"
      bind b select-pane -L
      bind h select-pane -L
      bind f select-pane -R
      bind l select-pane -R
      bind p select-pane -U
      bind k select-pane -U
      bind n select-pane -D
      bind j select-pane -D
      bind K confirm kill-session
      bind -n M-b select-pane -L
      bind -n M-h select-pane -L
      bind -n M-f select-pane -R
      bind -n M-l select-pane -R
      bind -n M-p select-pane -U
      bind -n M-k select-pane -U
      bind -n M-n select-pane -D
      bind -n M-j select-pane -D
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      bind -n M-B resize-pane -L 1
      bind -n M-F resize-pane -R 1
      bind -n M-P resize-pane -U 1
      bind -n M-N resize-pane -D 1
      bind -n C-q killp
      
      # bind [ start copy mode
      # bind space while copy mode to set the start point, then hit enter to copy
      # bind ] past the copied text
      # bind I to install tmux-plugins
      
      unbind C-a
      unbind C-e
      unbind C-b
      unbind C-f
      unbind C-d
      unbind C-k
      unbind C-t
      unbind C-o
      unbind C-r
      unbind Space
      
      set-option -g renumber-windows on
      
      # Copy & paste
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
      
      # General
      set-environment -g "LC_ALL" "en_US.UTF-8" 
      
      # Make the status line pretty and add some modules
      set -g status-position top
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -agF status-right "#{E:@catppuccin_status_cpu}"
      # set -agF status-right "#{E:@catppuccin_status_battery}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"

      # run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';
  };
}
