{ config, lib, pkgs, ... }:
let
in {
  programs.waybar = {
    enable = true;
    # systemd.enable = true;

    style = builtins.readFile ./waybar/style.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "keyboard-state"
          "hyprland/window"
        ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "pulseaudio"
          "cpu"
          "memory"
          "clock"
          "tray"
        ];

       keyboard-state = {
          numlock = false;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
          device-path = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        };

        "hyprland/window" = {
          format = " {}";
          separate-outputs = true;
        };

        "hyprland/workspaces" = {
          persistent-workspaces."*" = 5;
          format = "{icon}:{windows}";
          format-window-separator = " ";
          workspace-taskbar = {
            enable = true;
            update-active-window = true;
            format = "{icon} {title:.10}";
            icon-size = 16;
            orientation = "horizontal";
          };
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = " {volume}%";
          format-muted = "";
          format-icons = {
            "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
            "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            phone-muted = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          max-length = 10;
          scroll-step = 1;
          on-click = "pavucontrol";
          ignored-sinks = ["Easy Effects Sink"];
        };

        clock = {
          format = " {:%H:%M}";
          format-alt = "  {:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
        };

        cpu = {
          format = " {usage}%";
        };

        memory = {
          format = " {percentage}%";
          tooltip-format = "{avail}GiB available\n{used}GiB in use\n{total}GiBin total";
        };

        network = {
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = "{ipaddr}";
          tooltip-format = " {bandwidthUpBytes}  {bandwidthDownBytes}";
          format-disconnected = "⚠ No network";
        };

        tray = {
          icon-size = 12;
          spacing = 6;
        };
      };
    };
  };
}
