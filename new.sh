#!/usr/bin/env sh

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

mainproc () {
 echo -ne "
=========================================================================================================
                                     What Would You Like To Setup?                                       
========================================================================================================="
options=("dependencies" "dotfiles" "wsl" "exit")
select_option $? 1 "${options[@]}"

case $? in
0) set_option mainproc dependencies
    echo -ne "Setting up Dependencies"
    bash <(curl -s https://raw.githubusercontent.com/asadkhan98/dotfiles/main/bootstrap/scripts/dependencies.sh)
    mainproc
    ;;
1) set_option mainproc dotfiles
    echo -ne "Dotfiles"
    bash <(curl -s https://raw.githubusercontent.com/asadkhan98/dotfiles/main/bootstrap/scripts/dotfiles.sh)
    ;;
2) set_option mainproc WSL
    echo -ne "WSL"
    bash <(curl -s https://raw.githubusercontent.com/asadkhan98/dotfiles/main/bootstrap/scripts/wsl.sh)
    ;;
3) exit 
    echo -ne "Exiting script"
;;
*) echo "Wrong option please select again"; mainproc;;
esac

}


# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
select_option() {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "$2   $1 "; }
    print_selected()   { printf "$2  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    get_cursor_col()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${COL#*[}; }
    key_input()         {
                        local key
                        IFS= read -rsn1 key 2>/dev/null >&2
                        if [[ $key = ""      ]]; then echo enter; fi;
                        if [[ $key = $'\x20' ]]; then echo space; fi;
                        if [[ $key = "k" ]]; then echo up; fi;
                        if [[ $key = "j" ]]; then echo down; fi;
                        if [[ $key = "h" ]]; then echo left; fi;
                        if [[ $key = "l" ]]; then echo right; fi;
                        if [[ $key = "a" ]]; then echo all; fi;
                        if [[ $key = "n" ]]; then echo none; fi;
                        if [[ $key = $'\x1b' ]]; then
                            read -rsn2 key
                            if [[ $key = [A || $key = k ]]; then echo up;    fi;
                            if [[ $key = [B || $key = j ]]; then echo down;  fi;
                            if [[ $key = [C || $key = l ]]; then echo right;  fi;
                            if [[ $key = [D || $key = h ]]; then echo left;  fi;
                        fi 
    }
    print_options_multicol() {
        # print options by overwriting the last lines
        local curr_col=$1
        local curr_row=$2
        local curr_idx=0

        local idx=0
        local row=0
        local col=0
        
        curr_idx=$(( $curr_col + $curr_row * $colmax ))
        
        for option in "${options[@]}"; do

            row=$(( $idx/$colmax ))
            col=$(( $idx - $row * $colmax ))

            cursor_to $(( $startrow + $row + 1)) $(( $offset * $col + 1))
            if [ $idx -eq $curr_idx ]; then
                print_selected "$option"
            else
                print_option "$option"
            fi
            ((idx++))
        done
    }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local return_value=$1
    local lastrow=`get_cursor_row`
    local lastcol=`get_cursor_col`
    local startrow=$(($lastrow - $#))
    local startcol=1
    local lines=$( tput lines )
    local cols=$( tput cols ) 
    local colmax=$2
    local offset=$(( $cols / $colmax ))

    local size=$4
    shift 4

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local active_row=0
    local active_col=0
    while true; do
        print_options_multicol $active_col $active_row 
        # user key control
        case `key_input` in
            enter)  break;;
            up)     ((active_row--));
                    if [ $active_row -lt 0 ]; then active_row=0; fi;;
            down)   ((active_row++));
                    if [ $active_row -ge $(( ${#options[@]} / $colmax ))  ]; then active_row=$(( ${#options[@]} / $colmax )); fi;;
            left)     ((active_col=$active_col - 1));
                    if [ $active_col -lt 0 ]; then active_col=0; fi;;
            right)     ((active_col=$active_col + 1));
                    if [ $active_col -ge $colmax ]; then active_col=$(( $colmax - 1 )) ; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $(( $active_col + $active_row * $colmax ))
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
echo -ne "
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░      ░▒▓██████▓▒░ ░▒▓██████▓▒░░▒▓██████████████▓▒░░▒▓████████▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓██████▓▒░ ░▒▓█▓▒░     ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓██████▓▒░   
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        
 ░▒▓█████████████▓▒░░▒▓████████▓▒░▒▓████████▓▒░▒▓██████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░ "

mainproc