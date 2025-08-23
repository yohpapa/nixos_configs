{ config, lib, pkgs, ... }:
let
in {
  # NOTE: Refer to the below
  # - https://wiki.hypr.land/Configuring/
  # - https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.conf
  # - https://github.com/Andrey0189/nixos-config-reborn
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings = {
      env = [
        # Hint Electron apps to use Wayland
        "NIXOS_OZONE_WL,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland"
        "XDG_SCREENSHOTS_DIR,$HOME/screens"
      ];

      monitor = ",preferred,auto,auto";

      # variables
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      # "$fileManager" = "$terminal -e sh -c 'ranger'";
      "$menu" = "rofi";

      bind = [
        "$mainMod SHIFT, Return, exec, $terminal"
        "$mainMod,       D, exec, $menu -show drun"
      ];

      decoration = {
        rounding = 5;
        rounding_power = 1;
        
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        
        shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
        };
        
        # https://wiki.hypr.land/Configuring/Variables/#blur
        blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
        };
      };

      exec-once = [
        "nm-applet"
        "waybar"
      ];
    };
  };
}
