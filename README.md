# Nix OS Configurations

## Install NixOS

Download whichever ISO image from https://nixos.org/download/ and just follow the instructions in NixOS installer.

## Install minimal set of apps and enable ssh in `configuration.nix`

1. Add `git` and `vim` to `environment.systemPackages`

2. Set `true` to `service.openssh.enable`

3. Build the system

   ```sh
   sudo nixos-rebuild switch
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

3. Put your background image (png, jpg or gif) in $HOME/flake/configs/ws/assets/background.[png|jpg|gif]

4. Rebuild the system

   NOTE: Make sure to commit any new files before rebuilding the system. Otherwise, it fails.

   ```sh
   sudo nixos-rebuild switch --flake path:$HOME/flake
   ```

5. Configure apps

   ```sh
   cd $HOME
   git clone https://github.com/yohpapa/dotfiles.git
   cd dotfiles
   stow (module)
   ```

   The module refers to a name of the directory under `$HOME/dotfiles`, which you want to stow in `$HOME/.config/`. See https://github.com/yohpapa/dotfiles for more details.

6. Reboot the machine (after `sudo` if needed)

   ```sh
   reboot
   ```

7. Set up ssh for github

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
