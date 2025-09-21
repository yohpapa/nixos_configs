# Nix OS Configurations

## Install NixOS

Download whichever ISO image from https://nixos.org/download/ and just follow the instructions in NixOS installer.

## Install minimal set of apps and enable ssh in `configuration.nix`

1. Add `git` and `vim` to `environment.systemPackages`

2. Set `true` to `service.openssh.enable`

3. Build the system

   ```sh
   sudo nixos-rebuild switch --flake .
   ```

## Apply the full set of configurations

1. Clone the config repo and rebuild the system with the current hardware config

   ```sh
   profile=[new profile]
   mkdir -p $HOME/.config/nix
   git clone https://github.com/yohpapa/nixos_configs.git $HOME/.config/nix
   mkdir -p $HOME/.config/nix/configs/${profile}
   cp /etc/nixos/hardware-configuration.nix $HOME/.config/nix/configs/${profile}
   ```

2. Update system and user settings in `flake.nix`

3. Rebuild the system

   NOTE: Make sure to commit any new files before rebuilding the system. Otherwise, it fails.

   ```sh
   sudo nixos-rebuild switch --flake .
   ```

4. Configure apps

   ```sh
   cd $HOME
   git clone https://github.com/yohpapa/dotfiles.git
   cd dotfiles
   stow
   ```

   Remove unnecessary configurations.

   ```sh
   cd $HOME/.config
   rm systemd
   rm xremap
   ```

   Additional downloads for tmux and yazi.

   ```sh
   mkdir -p $HOME/.config/tmux/plugins
   git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm
   mkdir -p $HOME/.config/yazi/flavors
   git clone https://github.com/BennyOe/tokyo-night.yazi.git $HOME/.config/yazi/flavors/tokyo-night.yazi
   ```

5. Reboot the machine (after `sudo` if needed)

   ```sh
   reboot
   ```

6. Set up ssh for github

   ```sh
   git config --global user.name "XXXX"
   git config --global user.email "XXXX@XXXX.XXXX"
   ssh-keygen
   ```

   And then paste the public key to github in `Settings` > `SSH and GPG keys` > `New SSH key`

   Update the NixOS config repository to ssh

   ```sh
   cd $HOME/.config/nix
   git remote set-url origin git@github.com:yohpapa/nixos_configs.git
   git remote -v
   cd $HOME/dotfiles
   git remote set-url origin git@github.com:yohpapa/dotfiles.git
   git remote -v
   ```

7. Additional configurations for Hyprland and Ghostty
   - Hyprland animations from https://github.com/HyDE-Project/HyDE
   - Ghostty shaders from https://github.com/hackr-sh/ghostty-shaders/tree/main and https://github.com/KroneCorylus/ghostty-shader-playground/tree/main/shaders
