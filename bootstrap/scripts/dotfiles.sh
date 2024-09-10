#!/usr/bin/env bash

clear
gum style --foreground 4 --border-foreground 4 --border double --align center --width 50 --margin "1 2" --padding "2 4" --italic $(gum style --foreground 1 --bold "AK-BOOTSTRAP") 'AiO Cross Platform dotfiles installer'

#cd && git clone --depth 1 https://github.com/asadkhan98/dotfiles ".dotfiles" && cd .dotfiles

installDots=$(gum choose --cursor "[ • ] " --cursor-prefix "[ • ] " --selected-prefix "[ ✓ ] " --unselected-prefix "[   ] " --cursor.foreground 6 "BASH" "BAT" "BTOP" "FASTFETCH" "GIT" "HTOP" "LF" "MICRO" "SSH" "STARSHIP" "TMUX" "ZSH")

case $installDots in
    BASH)
        ;;
    BAT)
        ;;
    BTOP)
        ;;
    FASTFETCH)
        ;;
    GIT)
        ;;
    HTOP)
        ;;
    LF)
        ;;
    MICRO)
        ;;
    SSH)
        ;;
    STARSHIP)
        ;;
    TMUX)
        ;;
    ZSH)
        ;;
    *)
        echo -e "Sorry, encountered an $(gum style --foreground  1 --bold "ERROR")! Exiting the script."
        exit 1
esac