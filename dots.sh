#!/usr/bin/env bash

echo -ne "\033[00;34m
█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗
╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝
                     █████╗ ██╗  ██╗       ██████╗  ██████╗ ████████╗███████╗
                    ██╔══██╗██║ ██╔╝       ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝
                    ███████║█████╔╝        ██║  ██║██║   ██║   ██║   ███████╗
                    ██╔══██║██╔═██╗        ██║  ██║██║   ██║   ██║   ╚════██║
                    ██║  ██║██║  ██╗    ██╗██████╔╝╚██████╔╝   ██║   ███████║
                    ╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝╚═════╝  ╚═════╝    ╚═╝   ╚══════╝
█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗
╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝\033[0m
"

#cd "$(dirname "$0")/.."
STRAP_COLOR="#1ee1c8"
ERROR_COLOR="#ff0000"
DOTFILES=$(pwd -P)
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CONFIG_FILE=$CONFIGS_DIR/bootstrap.conf

set -e

echo ''

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

link_file () {
  local src=$1 dst=$2

  local overwrite=
  local backup=
  local skip=
  local action=

  if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      # ignoring exit 1 from readlink in case where file already exists
      # shellcheck disable=SC2155
      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action  < /dev/tty

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "Removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "Moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "Skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "Linked $1 to $2"
  fi
}

set_option() {
    if grep -Eq "^${1}.*" "$CONFIG_FILE"; then # check if option exists
        sed -i -e "/^${1}.*/d" "$CONFIG_FILE" # delete option if exists
    fi
    echo "${1}=${2}" >>"$CONFIG_FILE" # add option
}

prop () {
   PROP_KEY=$1
   PROP_FILE=$2
   PROP_VALUE=$(eval echo "$(cat $PROP_FILE | grep "$PROP_KEY" | cut -d'=' -f2)")
   echo $PROP_VALUE
}

install_dotfiles () {
  info 'Installing dotfiles'
  echo ''
  local overwrite_all=false backup_all=false skip_all=false

  find -H "$DOTFILES" -maxdepth 2 -name 'links.prop' -not -path '*.git*' | while read linkfile
  do
    cat "$linkfile" | while read line
    do
        local src dst dir
        src=$(eval echo "$line" | cut -d '=' -f 1)
        dst=$(eval echo "$line" | cut -d '=' -f 2)
        dir=$(dirname $dst)

        mkdir -p "$dir"
        link_file "$src" "$dst"
    done
  done
}

create_env_file () {
    if test -f "$HOME/.env.sh"; then
        success "$HOME/.env.sh file already exists, skipping"
    else
        echo "export DOTFILES=$DOTFILES" > $HOME/.env.sh
        success 'created ~/.env.sh'
    fi
}

dotfilesInstall(){
    echo -e "What type of $(gum style --foreground  "$STRAP_COLOR" "System Link") would you like?"
    dotsType=$(gum choose --cursor "[ • ] " --cursor-prefix "[ • ] " --selected-prefix "[ x ] " --unselected-prefix "[   ] " --cursor.foreground 6 "USER" "SYSTEM")
    set_option dotsType "$dotsType"
    if [ "$dotsType" = "USER" ]; then
        cp -f $SCRIPT_DIR/bootstrap/configs/user.links.prop $SCRIPT_DIR/links.prop
    elif [ "$dotsType" = "SYSTEM" ]; then
        cp -f $SCRIPT_DIR/bootstrap/configs/system.links.prop $SCRIPT_DIR/links.prop
    fi
        echo -e "Created $(gum style --foreground "$STRAP_COLOR" "$dotsType") link file."
}

dotfilesInstall
install_dotfiles
create_env_file

echo ''
echo ''
success 'All dotfiles have been installed!'


echo -ne "\033[00;34m

█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗█████╗
╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝\033[0m
"