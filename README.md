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
   mkdir -p $HOME/.config/nix
   git clone https://github.com/yohpapa/nixos_configs.git ~/.config/nix
   cp /etc/nixos/hardware-configuration.nix $HOME/.config/nix/configs/[machine]
   sudo nixos-rebuild switch --flake $HOME/.config/nix
   ```

2. Set up ssh for github

   ```sh
   git config --global user.name "Kensuke Nakai"
   git config --global user.email "kemumaki.kemuo@gmail.com"
   ssh-keygen
   ```

   And then past the public key to github in `Settings` > `SSH and GPG keys` > `New SSH key`

   Update the NixOS config repository to ssh

   ```sh
   cd $HOME/.config/nix
   git remote set-url main git@github.com:yohpapa/nixos_configs.git
   git remote -v
   ```

3. Configure apps

   ```sh
   cd $HOME
   git clone git@github.com:yohpapa/dotfiles.git
   cd dotfiles
   stow
   ```

   Remove unnecessary configurations.

   ```sh
   cd $HOME/.config
   rm systemd
   rm xremap
   ```

   Additional config for tmux and yazi.

   ```sh
   mkdir -p $HOME/.config/tmux/plugins
   git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm
   mkdir -p $HOME/.config/yazi/flavors
   git clone https://github.com/BennyOe/tokyo-night.yazi.git $HOME/.config/yazi/flavors/tokyo-night.yazi
   ```
