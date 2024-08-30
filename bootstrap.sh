#!/usr/bin/env bash

set -a
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
STRAP_DIR="$SCRIPT_DIR/bootstrap"
SCRIPTS_DIR="$STRAP_DIR/scripts"
CONFIGS_DIR="$STRAP_DIR/configs"
LOGS_DIR="$STRAP_DIR/logs"
set +a

CONFIG_FILE=$CONFIGS_DIR/bootstrap.conf
if [ ! -f "$CONFIG_FILE" ]; then # check if file exists
    touch -f "$CONFIG_FILE" # create file if not exists
fi

STRAP_COLOR="#1ee1c8"

#  _______           _        _______ __________________ _______  _        _______
# (  ____ \|\     /|( (    /|(  ____ \\__   __/\__   __/(  ___  )( (    /|(  ____ \
# | (    \/| )   ( ||  \  ( || (    \/   ) (      ) (   | (   ) ||  \  ( || (    \/
# | (__    | |   | ||   \ | || |         | |      | |   | |   | ||   \ | || (_____
# |  __)   | |   | || (\ \) || |         | |      | |   | |   | || (\ \) |(_____  )
# | (      | |   | || | \   || |         | |      | |   | |   | || | \   |      ) |
# | )      | (___) || )  \  || (____/\   | |   ___) (___| (___) || )  \  |/\____) |
# |/       (_______)|/    )_)(_______/   )_(   \_______/(_______)|/    )_)\_______)

set_option() {
    if grep -Eq "^${1}.*" "$CONFIG_FILE"; then # check if option exists
        sed -i -e "/^${1}.*/d" "$CONFIG_FILE" # delete option if exists
    fi
    echo "${1}=${2}" >>"$CONFIG_FILE" # add option
}

install_Type() {
  installType=$(gum choose --cursor "[ • ] " --cursor-prefix "[ • ] " --selected-prefix "[ ✓ ] " --unselected-prefix "[   ] " --cursor.foreground 6 "Both" "Dotfiles" "Dependencies")
  set_option installType "$installType"
  echo -e "Installing $(gum style --foreground 6 --italic "$installType")"
}

check_OS() {
  checkOS=$(gum choose --cursor "[ • ] " --cursor-prefix "[ • ] " --selected-prefix "[ ✓ ] " --unselected-prefix "[   ] " --cursor.foreground 6 "WSL" "Linux" "MacOS")
  set_option checkOS "$checkOS"
  echo -e "Selected $(gum style --foreground 6 --italic "$checkOS")"
}

dotfilesInstall(){
    ( bash "$SCRIPT_DIR"/dots.sh )|& tee "$LOGS_DIR"/dots.log
}

#  _______  _______  _______  _______  _______  _______  _______
# (  ____ )(  ____ )(  ___  )(  ____ \(  ____ \(  ____ \(  ____ \
# | (    )|| (    )|| (   ) || (    \/| (    \/| (    \/| (    \/
# | (____)|| (____)|| |   | || |      | (__    | (_____ | (_____
# |  _____)|     __)| |   | || |      |  __)   (_____  )(_____  )
# | (      | (\ (   | |   | || |      | (            ) |      ) |
# | )      | ) \ \__| (___) || (____/\| (____/\/\____) |/\____) |
# |/       |/   \__/(_______)(_______/(_______/\_______)\_______)

clear
gum style --foreground 4 --border-foreground 4 --border double --align center --width 50 --margin "1 2" --padding "2 4" --italic $(gum style --foreground  "$STRAP_COLOR" --bold "AK-BOOTSTRAP") 'AiO Cross Platform dotfiles installer'
echo -e "What would you like to $(gum style --foreground  4 --bold "Install")?"
install_Type

case $installType in
    Both)
        echo -e "Please choose your $(gum style --foreground  4 --bold "Operating System")."
        check_OS
          case $checkOS in
              WSL)
                ( bash "$SCRIPTS_DIR"/wsl.sh )|& tee "$LOGS_DIR"/wsl.log
              	;;
              Linux)
                ( bash "$SCRIPTS_DIR"/linux.sh )|& tee "$LOGS_DIR"/linux.log
              	;;
              MacOS)
                ( bash "$SCRIPTS_DIR"/macos.sh )|& tee "$LOGS_DIR"/macos.log
              	;;
              *)
                echo -e "Sorry, encountered an $(gum style --foreground  1 --bold "ERROR")! Exiting the script."
              	exit 1
          esac
        dotfilesInstall
        ;;
    Dotfiles)
        dotfilesInstall
        ;;
    Dependencies)
        echo -e "Please choose your $(gum style --foreground  4 --bold "Operating System")."
        check_OS
          case $checkOS in
              WSL)
                ( bash "$SCRIPTS_DIR"/wsl.sh )|& tee "$LOGS_DIR"/wsl.log
              	;;
              Linux)
                ( bash "$SCRIPTS_DIR"/linux.sh )|& tee "$LOGS_DIR"/linux.log
              	;;
              MacOS)
                ( bash "$SCRIPTS_DIR"/macos.sh )|& tee "$LOGS_DIR"/macos.log
              	;;
              *)
                echo -e "Sorry, encountered an $(gum style --foreground  1 --bold "ERROR")! Exiting the script."
              	exit 1
          esac
        ;;
    *)
        echo -e "Sorry, encountered an $(gum style --foreground  1 --bold "ERROR")! Exiting the script."
        exit 1
esac