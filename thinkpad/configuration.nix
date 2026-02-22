# #_   _     _       _                    _    __               __ _                       _   _                     _
# | |_| |__ (_)_ __ | | ___ __   __ _  __| |  / /__ ___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __    _ __ (_)_  __
# | __| '_ \| | '_ \| |/ / '_ \ / _` |/ _` | / / __/ _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \  | '_ \| \ \/ /
# | |_| | | | | | | |   <| |_) | (_| | (_| |/ / (_| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |_| | | | |>  <
#  \__|_| |_|_|_| |_|_|\_\ .__/ \__,_|\__,_/_/ \___\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_(_)_| |_|_/_/\_\
#                        |_|                                         |___/

{ config, lib, pkgs, systemSettings, userSettings, neovim-pkgs, ghostty, ... }:
let neovim-override = final: prev: { neovim = neovim-pkgs.neovim; };
in {
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = systemSettings.maxBackups;
        consoleMode = "max";
      };
      grub.enable = false;
    };

    kernelParams = [
      # "usbcore.autosuspend=-1"
      "usbcore.quirks=0853:0145:k"
      "amd_pstate=active"
      "amdgpu.sg_display=0"
      "amdgpu.dcdebugmask=0x10"
      "thinkpad_acpi.fan_control=1"
      "video=DP-2:3840x2160"
      "video=eDP-1:1920x1200"
      "resume=/dev/mapper/luks-46890fa7-417b-4e2f-9729-4b806f650218"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "uinput" ];
    initrd = {
      kernelModules = [ "amdgpu" ];
      luks.devices = {
        "luks-83660011-664a-4324-bf88-9c0628f375ba".device =
          "/dev/disk/by-uuid/83660011-664a-4324-bf88-9c0628f375ba";
        "luks-46890fa7-417b-4e2f-9729-4b806f650218" = {
          device = "/dev/disk/by-uuid/46890fa7-417b-4e2f-9729-4b806f650218";
          keyFile = "/etc/secrets/initrd-keyfile";
        };
      };
      secrets = {
        "/etc/secrets/initrd-keyfile" = "/etc/secrets/initrd-keyfile";
      };
    };

    resumeDevice = "/dev/mapper/luks-46890fa7-417b-4e2f-9729-4b806f650218";
  };

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    packages = [ pkgs.terminus_font ];
    keyMap = "us";
  };

  # Network settings
  networking.hostName = systemSettings.hostname;
  networking.wireless.enable =
    true; # Enables wireless support via wpa_supplicant.

  # Network manager
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  # Time zone.
  time.timeZone = systemSettings.timezone;

  # Locale settings
  i18n = {
    defaultLocale = systemSettings.defaultLocale;
    extraLocaleSettings = {
      LC_ADDRESS = systemSettings.extraLocale;
      LC_IDENTIFICATION = systemSettings.extraLocale;
      LC_MEASUREMENT = systemSettings.extraLocale;
      LC_MONETARY = systemSettings.extraLocale;
      LC_NAME = systemSettings.extraLocale;
      LC_NUMERIC = systemSettings.extraLocale;
      LC_PAPER = systemSettings.extraLocale;
      LC_TELEPHONE = systemSettings.extraLocale;
      LC_TIME = systemSettings.extraLocale;
    };
  };

  # Default shell
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # User account settings.
  # Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" "input" "video" "audio" "render" ];
  };

  # Allow proprietary firmware for Wi-Fi 7 and AMD Bluetooth
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  # Neovim overlay
  nixpkgs.overlays = [ neovim-override ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # CLI tools
    bat
    btop
    cargo
    clang
    dysk
    eza
    fastfetch
    fd
    figlet
    fzf
    git
    gnumake
    icu
    jq
    kanshi
    killall
    lazygit
    lshw
    neovim
    nmap
    nodePackages.npm
    pciutils
    pokeget-rs
    ripgrep
    starship
    tmux
    stow
    stylua
    unzip
    usbutils
    vim
    zoxide
    zsh-history-substring-search

    # GUI tools
    alacritty
    brightnessctl
    cliphist
    dconf
    firefoxpwa
    grim
    hyprland
    gdk-pixbuf
    ghostty
    imagemagick
    kitty
    libnotify
    librsvg
    mako
    networkmanagerapplet
    niri
    pavucontrol
    pywal16
    (rofi.override { plugins = [ rofi-emoji rofi-calc ]; })
    slurp
    swappy
    swayidle
    swaylock
    swayosd
    swww
    tailscale-systray
    udiskie
    xwayland-satellite
    waybar
    wl-clipboard
  ];

  # House-keeping
  # $ sudo nix-collect-garbage -d
  # $ nix-collect-garbage -d
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ]; # enable flakes
      auto-optimise-store = true; # optimize the store in every build.
    };

    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Key remapping
  services.xremap = {
    enable = true;
    package = pkgs.xremap;
    watch = true;
    userName = userSettings.username;
    deviceNames = [
      "Topre REALFORCE 87 US"
      "Topre REALFORCE 87 US Keyboard"
      "AT Translated Set 2 keyboard"
    ];
    config = {
      modmap = [{
        name = "Global";
        remap = {
          "CapsLock" = "Control_L";
          "Control_L" = "Alt_L";
          "Alt_L" = "SUPER_L";
        };
      }];
    };
  };

  services.udev.extraRules = ''
    # Force input devices to be owned by the 'input' group and be readable
    KERNEL=="uinput", GROUP="input", MODE="0660"
    KERNEL=="event*", GROUP="input", MODE="0660"
    SUBSYSTEM=="backlight", GROUP="video", MODE="0664"

    # When the Realforce is unplugged, restart xremap to fall back to the internal keyboard
    ACTION=="remove", SUBSYSTEM=="input", ATTRS{idVendor}=="0853", ATTRS{idProduct}=="0145", RUN+="${pkgs.systemd}/bin/systemctl restart xremap.service"

    # When the Realforce is plugged in, restart xremap to grab it
    ACTION=="add", SUBSYSTEM=="input", ATTRS{idVendor}=="0853", ATTRS{idProduct}=="0145", RUN+="${pkgs.systemd}/bin/systemctl restart xremap.service"

    # Trigger on DRM change for the Zen 5 GPU (card1)
    #
    # NOTE:
    # Since the 3-4 USB path is tied to the physical internal wiring of the T14 Gen 5, it should remain consistent.
    # However, if you ever perform a major BIOS/Firmware update and notice the automation stop working, just run
    # grep -l "06cb" /sys/bus/usb/devices/*/idVendor
    # again to see if the kernel re-indexed the port to something like 3-3 or 3-5.
    #
    ACTION=="change", SUBSYSTEM=="drm", ENV{HOTPLUG}=="1", \
    RUN+="${pkgs.bash}/bin/bash -c 'if ${pkgs.gnugrep}/bin/grep -q \"^connected$$\" /sys/class/drm/card1-DP-*/status; then \
      if [ -d /sys/bus/usb/devices/3-4/driver ]; then echo \"3-4\" > /sys/bus/usb/drivers/usb/unbind; fi; \
        ${pkgs.systemd}/bin/systemctl stop fprintd.service; \
      else \
        if [ ! -d /sys/bus/usb/devices/3-4/driver ]; then echo \"3-4\" > /sys/bus/usb/drivers/usb/bind; fi; \
        ${pkgs.systemd}/bin/systemctl start fprintd.service; \
      fi'"

    # Configure screen locking and suspension
    SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="[0-5]", RUN+="${pkgs.systemd}/bin/systemctl hibernate"
  '';

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Audio settings
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Wayland compositor settings
  programs.hyprland = {
    enable = lib.mkDefault true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.niri.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    AMD_VULKAN_ICD = "RADV";
    WLR_DRM_DEVICES = "/dev/dri/card1";
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    MESA_LOADER_DRIVER_OVERRIDE = "radeonsi";
    XDG_SESSION_TYPE = "wayland";
    NIRI_RENDERER = "gles2";
    WLR_BACKENDS = "drm,libinput";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config = {
      common.default = "gtk";
      niri = {
        default = lib.mkOptionDefault "gtk";
        "org.freedesktop.impl.portal.Settings" = "gtk";
      };
    };
  };

  # Xserver settings
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    videoDrivers = [ "amdgpu" ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.niri}/bin/niri -c /etc/greetd/niri-greeter.kdl";
        user = "greeter";
      };
    };
  };

  environment.etc."greetd/niri-greeter.kdl".text = ''
    hotkey-overlay {
      skip-at-startup
    }

    output "DP-2" {
      mode "3840x2160@60"
      scale 2.0
      focus-at-startup
    }

    output "eDP-1" {
      mode "1920x1200@60"
      position x=0 y=2160
    }

    input {
      keyboard {
        xkb {
          layout "us"
        }
      }
      touchpad {
        tap
      }
    }

    layout {
      gaps 0
      center-focused-column "always"
    }

    cursor {
      xcursor-theme "breeze_cursors"
      xcursor-size 24
    }

    spawn-at-startup "${pkgs.regreet}/bin/regreet"

    binds {
      "Mod+Shift+E" { quit; }
    }

    window-rule {
      match app-id="regreet"
      open-floating true
    }
  '';

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        color = "#121212";
        fit = "Cover";
      };
      GTK.application_prefer_dark_theme = true;
    };
    extraCss = ''
      window {
        background-color: #121212;
      }

      .main-window {
        background-color: #1e1e1e;
        border: 1px solid #333333;
        border-radius: 12px;
        padding: 40px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6);
      }

      entry {
        background-color: #2a2a2a;
        color: #eeeeee;
        border-radius: 4px;
        border: 1px solid #444;
      }
    '';
  };

  users.extraUsers.greeter = {
    extraGroups = [ "video" "input" "render" ];
    home = "/tmp/greeter-home";
    createHome = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-utils
      libva-vdpau-driver
      libvdpau-va-gl
      rocmPackages.clr.icd
      rocmPackages.rocminfo
      mesa
    ];
  };

  hardware.uinput.enable = true;

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  # Font settings https://nixos.wiki/wiki/Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.caskaydia-cove
  ];

  # IME settings
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        qt6Packages.fcitx5-configtool
      ];
      waylandFrontend = true;
    };
  };

  environment.variables = {
    GTK_IM_MODULE = "fcitx5";
    QT_IM_MODULE = "fcitx5";
    XMODIFIERS = "@im=fcitx";
  };

  # https://nix.dev/guides/faq#how-to-run-non-nix-executables
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ lua-language-server icu ];
  };

  # Firefox
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };

  # Battery Longevity
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80; # Stop at 80% to extend battery life
      WIFI_PWR_ON_BAT = "on";
      USB_AUTOSUSPEND_DEVICE_DENYLIST = "0853:0145";
    };
  };
  services.power-profiles-daemon.enable = false;

  # Headless/SSH Mode: Don't sleep when the lid is closed
  services.logind.settings.Login = {
    IdleAction = "suspend-then-hibernate";
    IdleActionSec = "30min";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitch = "suspend-then-hibernate";
  };

  # Fingerprint Sensor (Synaptics 06cb:00f9)
  services.fprintd.enable = true;
  security = {
    pam.services = {
      sudo.fprintAuth = true; # Touch sensor for sudo!
      login.fprintAuth = false; # Touch sensor for login!
      swaylock.fprintAuth = false; # for future (sway is not enabled yet)
      greetd.fprintAuth = false;
    };
    polkit = {
      enable = true;
      extraConfig = ''
              polkit.addRule(function(action, user) {
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              action.lookup("unit") == "fprintd.service" &&
              user.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
      '';
    };
  };

  # Firmware Updates
  services.fwupd.enable = true;

  # Trackpoint
  services.libinput = {
    touchpad.tapping = true;
    mouse.accelProfile = "flat";
  };

  # Other services
  services = {
    tailscale.enable = true;
    udisks2.enable = true;
  };

  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.kanshi}/bin/kanshi";
      Restart = "always";
    };
  };

  services.dbus = {
    enable = true;
    packages = [ pkgs.swayosd ];
  };

  systemd.user.services.swayosd = {
    description = "SwayOSD Display Service";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
      Restart = "always";
    };
  };

  systemd.sleep.extraConfig = "HibernateDelaySec=7200";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
