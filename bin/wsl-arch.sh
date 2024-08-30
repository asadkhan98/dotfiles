#!/usr/bin/env bash

echo "Preparing WSL"

pacman-key --init && pacman-key --populate && pacman -Syu && pacman -S archlinux-keyring && sudo pacman -S --needed base-devel git gum



if [ $(whoami) = "root"  ]; then
    echo "Adding sudo user"
    read -p 'Username: ' USERNAME
    read -sp 'Password: ' PASSWORD
    useradd -m -G wheel -s /bin/zsh $USERNAME
    echo "$USERNAME created, home directory created, added to wheel, default shell set to /bin/zsh"
    sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
    echo "$USERNAME:$PASSWORD" | chpasswd
    echo "$USERNAME password set"
else
    echo -e "\033[00;34mYou are already a user. Everything is good to go!\033[0m"
fi

echo "Dependencies Complete, you can now switch to the user and install the dotfiles"