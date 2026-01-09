# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.kensuke = {
  #   isNormalUser = true;
  #   description = "Kensuke Nakai";
  #   extraGroups = [ "networkmanager" "wheel" ];
  #   packages = with pkgs; [];
  # };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  #   vim
  #   wget
  #   git
  #   pciutils
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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

  # GPU Drivers & Early Boot
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Custom NixOS configurations
  environment.systemPackages = with pkgs; [
    lazygit
    vim
    wget
    git
    pciutils
    docker-compose
    vulkan-tools
  ];

  # Fix LAN issue
  boot.extraModulePackages = [ config.boot.kernelPackages.r8125 ];
  boot.blacklistedKernelModules = [ "r8169" ];

  # Hardware Acceleration (2026 Standard)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Needed for certain apps/Wine
    extraPackages = with pkgs; [
      # Standard Vulkan loader and validation (good for dev/troubleshooting)
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      
      # The Mesa RADV driver is already included by 'enable = true', 
      # but ensuring the ICD profiles are here is good practice.
      mesa
      
      # Essential for AI/Compute workloads on your 780M
      rocmPackages.clr.icd 
    ];
  };

  # Tailscale & Networking
  boot.kernelModules = [ "tun" ];
  services.tailscale.enable = true;

  # User Permissions & Tools
  users.users.kensuke = {
    isNormalUser = true;
    description = "Kensuke Nakai";
    extraGroups = [
      "networkmanager"
      "wheel" 
      "docker"
      "video"  # Access to /dev/dri (Vulkan/Graphics)
      "render" # Access to /dev/kfd (AI/Compute)
    ];
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # Networking
  networking = {
    hostName = "homelab";
    useDHCP = false;
    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.100";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    extraHosts = "129.168.1.100 homelab";
  };

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
}
