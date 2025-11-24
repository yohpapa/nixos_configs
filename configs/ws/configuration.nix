# #                  __                   __ _                       _   _
# __      _____     / /   ___ ___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __
# \ \ /\ / / __|   / /   / __/ _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \
#  \ V  V /\__ \  / /   | (_| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
#   \_/\_/ |___/ /_/     \___\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#                                              |___/

{ config, lib, pkgs, systemSettings, userSettings, neovim-pkgs, ghostty
, sddm-stray, ... }:
let neovim-override = final: prev: { neovim = neovim-pkgs.neovim; };
in {
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
    };
    systemd-boot = {
      # enable = true;
      configurationLimit = systemSettings.maxBackups;
    };
  };

  # Network settings
  networking.hostName = systemSettings.hostname;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Proxy settings
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Network manager
  networking.networkmanager.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "input" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
    emacs
    eza
    fastfetch
    fd
    figlet
    fzf
    git
    gnumake
    icu
    jq
    killall
    lazygit
    lshw
    neovim
    nerd-fonts.fira-code
    nodePackages.npm
    pokeget-rs
    python3Full
    ripgrep
    starship
    tmux
    stow
    stylua
    superfile
    unzip
    usbutils
    vim
    zoxide
    zsh-history-substring-search

    # SSDM tools
    catppuccin-sddm
    sddm-stray

    # GUI tools
    brightnessctl
    cliphist
    firefox
    firefoxpwa
    grim
    hyprland
    hyprlock
    gdk-pixbuf
    ghostty
    imagemagick
    kitty
    libnotify
    librsvg
    mako
    networkmanagerapplet
    niri
    obsidian
    pavucontrol
    pywal16
    (rofi-wayland.override { plugins = [ rofi-emoji rofi-calc ]; })
    slurp
    swappy
    swayosd
    swww
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

  # move the nix store to the external storage
  # - https://nixos.wiki/wiki/Storage_optimization.
  # fileSystems."/nix" = {
  #   device = "/dev/disk/.../nix";
  #   fsType = "ext4";
  #   neededForBoot = true;
  #   options = [ "noatime" ];
  # };

  # virtualisation.virtualbox.guest.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Keyboard settings
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Key remapping
  services.xremap = {
    enable = true;
    package = pkgs.xremap;
    watch = true;
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
  };

  # Hyprland settings
  programs.hyprland = {
    enable = lib.mkDefault true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.niri.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.niri."org.freedesktop.impl.portal.FileChooser" = "gtk";
  };

  # Display manager (Login manager) settings
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      # theme = "catppuccin-macchiato";
      # theme = "catppuccin-mocha";
      # theme = "elarun";
      # theme = "maldives";
      # theme = "maya";
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs; [ kdePackages.qtsvg kdePackages.qtmultimedia ];
      theme = "sddm-stray";
    };
    defaultSession = "hyprland-uwsm";
  };

  # Graphics https://nixos.wiki/wiki/Nvidia
  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      # prime = {
      #   sync.enable = true;
      #   nvidiaBusId = "PCI:16:0:0";
      # };
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # Font settings https://nixos.wiki/wiki/Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # IME settings
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      addons = with pkgs; [ fcitx5-mozc fcitx5-gtk fcitx5-configtool ];
      waylandFrontend = true;
    };
  };

  environment.variables = { XMODIFIERS = "@im=fcitx"; };

  # https://nix.dev/guides/faq#how-to-run-non-nix-executables
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ lua-language-server icu ];
  };

  # External drive
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/7108f049-26cb-4e5c-8e04-f58862fc5551";
    fsType = "ext4";
    options = [ "nofail" "x-gvfs-show" ];
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Emacs
  services.emacs = {
    enable = true;
    package = pkgs.emacs;
  };

  # Firefox
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };

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
  system.stateVersion = "25.05"; # Did you read the comment?

}
