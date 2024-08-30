#!/usr/bin/env bash

source $STRAP_DIR/configs/packages.conf

CONFIG_FILE=$CONFIGS_DIR/bootstrap.conf

source $CONFIG_FILE

#  _______           _        _______ __________________ _______  _        _______
# (  ____ \|\     /|( (    /|(  ____ \\__   __/\__   __/(  ___  )( (    /|(  ____ \
# | (    \/| )   ( ||  \  ( || (    \/   ) (      ) (   | (   ) ||  \  ( || (    \/
# | (__    | |   | ||   \ | || |         | |      | |   | |   | ||   \ | || (_____
# |  __)   | |   | || (\ \) || |         | |      | |   | |   | || (\ \) |(_____  )
# | (      | |   | || | \   || |         | |      | |   | |   | || | \   |      ) |
# | )      | (___) || )  \  || (____/\   | |   ___) (___| (___) || )  \  |/\____) |
# |/       (_______)|/    )_)(_______/   )_(   \_______/(_______)|/    )_)\_______)

set -e

set_option() {
    if grep -Eq "^${1}.*" $CONFIG_FILE; then # check if option exists
        sed -i -e "/^${1}.*/d" $CONFIG_FILE # delete option if exists
    fi
    echo "${1}=${2}" >>$CONFIG_FILE # add option
}

root_check() {
    if [[ "$(id -u)" != "0" ]]; then
        echo -ne "\033[00;31mERROR! This script must be run under the 'root' user!\033[0m\n"
        exit 0
    fi
}

docker_check() {
    if awk -F/ '$2 == "docker"' /proc/self/cgroup | read -r; then
        echo -ne "\033[00;31mERROR! Docker container is not supported (at the moment)\033[0m\n"
        exit 0
    elif [[ -f /.dockerenv ]]; then
        echo -ne "\033[00;31mERROR! Docker container is not supported (at the moment)\033[0m\n"
        exit 0
    fi
}

background_checks() {
    root_check
    docker_check
}

pacman_check() {
    if [[ -f /var/lib/pacman/db.lck ]]; then
        echo -ne "\033[00;31mERROR! Pacman is blocked.\033[0m"
        echo -ne "\033[00;33mIf not running remove /var/lib/pacman/db.lck.\033[0m\n"
        exit 0
    fi
}

arch_check() {
    if [[ ! -e /etc/arch-release ]]; then
        echo -ne "\033[00;33mERROR! This script must be run in Arch Linux!\033[0m\n"
        exit 0
    fi
}

set_password() {
    read -rs -p "Please enter password: " PASSWORD1
    echo -ne "\n"
    read -rs -p "Please re-enter password: " PASSWORD2
    echo -ne "\n"
    if [[ "$PASSWORD1" == "$PASSWORD2" ]]; then
        set_option "$1" "$PASSWORD1"
    else
        echo -ne "\033[00;31mERROR! Passwords do not match.\033[0m \n"
        set_password
    fi
}

userInfo () {
    echo -e "Would you like to add a $(gum style --foreground  3 "New User")?"
    newUser=$(gum choose --cursor "[ • ] " --cursor-prefix "[ • ] " --selected-prefix "[ x ] " --unselected-prefix "[   ] " --cursor.foreground 6 "Yes" "No")
    set_option newUser "$newUser"
    case $newUser in
        Yes)
            read -p "Please enter your username: " username
            set_option USERNAME ${username,,} # convert to lower case as in issue #109
            set_password "PASSWORD"
            addUser
        ;;
        No)
            echo -e "\033[00;36mSkipping user setup.\033[0m"
        ;;
        *)
            echo -e "Sorry, encountered an $(gum style --foreground  1 --bold "ERROR")!"
        ;;
    esac
}

keysReset () {
    echo -e "Would you like to refresh the $(gum style --foreground  3 "Archlinux Keyring")?"
    refKeys=$(gum choose --cursor "[ • ] " --cursor-prefix "[ • ] " --selected-prefix "[ x ] " --unselected-prefix "[   ] " --cursor.foreground 6 "Yes" "No")
    set_option refKeys "$refKeys"
    case $refKeys in
        Yes)
            echo -e "\033[00;36mRemoving old Keys\033[0m"
            rm -R /etc/pacman.d/gnupg/
            rm -R /root/.gnupg/
            echo -e "\033[00;36mRefreshing Keys\033[0m"
            gpg --refresh-keys
            echo -e "\033[00;36mPopulating Keys\033[0m"
            pacman-key --init && pacman-key --populate archlinux
            pacman -S --noconfirm archlinux-keyring
            echo -e "\033[00;36mInstalling archlinux-keyring and updating\033[0m"
            pacman -Syu --noconfirm
            echo "Keys refreshed"
        ;;
        No)
            echo -e "\033[00;36mSkipping keys refresh.\033[0m"
        ;;
        *)
            echo -e "Sorry, encountered an $(gum style --foreground  1 --bold "ERROR")!"
        ;;
    esac
}

addUser () {
    if [ $(whoami) = "root"  ]; then
        useradd -m -G wheel -s /bin/zsh $USERNAME
        echo "$USERNAME created, home directory created, added to wheel, default shell set to /bin/zsh"
        sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
        sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
        echo "$USERNAME:$PASSWORD" | chpasswd
        echo "$USERNAME password set"
    else
	    echo -e "\033[00;34mYou are already a user. Everything is good to go!\033[0m"
    fi
}

skip_system_packages="${1}"

function no_system_packages() {
cat << EOF
Please install git & gum on your own
System package installation isn't supported with your OS / distro.
Please install any dependent packages on your own. You can view the list at:
    https://github.com/CodecoLabs/dotfiles/blob/master/install/dependencies
Then re-run the script and explicitly skip installing system packages:
    bash <(curl -sS https://raw.githubusercontent.com/CodecoLabs/dotfiles/master/install) --skip-system-packages
EOF
exit 1
}

#     _             _
#    / \   _ __ ___| |__
#   / _ \ | '__/ __| '_ \
#  / ___ \| | | (__| | | |
# /_/__ \_\_| _\___|_| |_|
function pacman_install_packages {
    sudo pacman -Syyu && sudo pacman -S --noconfirm ${pacman_packages} ${pacman_packages_optional}
}

function display_packages_pacman {
    echo -ne "Required: \033[00;32m${pacman_packages}\033[0m
Optional: \033[00;32m${pacman_packages_optional}\033[0m"
}

installArc() {
if [ -z "${skip_system_packages}" ]; then
cat << EOF

This script will install the following packages listed below.

$(display_packages_pacman)

If you choose no, the packages listed above will not be installed and this script
will continue. This gives you a chance to edit the list of packages (packages.conf)
if you don't agree with any of the decisions.

EOF
    while true; do
        read -rp "Do you want to continue with the installation? (Y/N) " yn
        case "${yn}" in
            [Yy]*)
                pacman_install_packages
                break;;
            [Nn]*)
                echo "Installation skipped, exiting!"
                break;;
            *) echo "Please answer Y or N";;
        esac
    done
else
    echo -e "\033[00;33mSystem package installation was skipped!\033[0m"
fi
}

function installAUR {
    AUR_HELPER=$(gum choose --cursor "[ • ] " --cursor-prefix "[ • ] " --selected-prefix "[ ✓ ] " --unselected-prefix "[   ] " --cursor.foreground 6 "paru" "yay" "pikaur")
    set_option AUR_HELPER "$AUR_HELPER"
    echo -e "Installing $(gum style --foreground 6 --italic "$AUR_HELPER")"
    cd ~
    git clone "https://aur.archlinux.org/$AUR_HELPER.git"
    cd ~/$AUR_HELPER
    makepkg -si --noconfirm
    cd ~
    rm -rf $AUR_HELPER
}

#  ____       _     _
# |  _ \  ___| |__ (_) __ _ _ __
# | | | |/ _ \ '_ \| |/ _` | '_ \
# | |_| |  __/ |_) | | (_| | | | |
# |____/_\___|_.__/|_|\__,_|_|_|_|
function apt_install_packages {
    # shellcheck disable=SC2086
    sudo apt-get update && sudo apt-get install -y ${apt_packages} ${apt_packages_optional}
}

function display_packages_apt {
    echo -ne "Required: \033[00;32m${apt_packages}\033[0m
Optional: \033[00;32m${apt_packages_optional}\033[0m"
}

installDeb() {
if [ -z "${skip_system_packages}" ]; then
cat << EOF

This script will install the following packages listed below.

$(display_packages_apt)

If you choose no, the packages listed above will not be installed and this script
will continue. This gives you a chance to edit the list of packages (packages.conf)
if you don't agree with any of the decisions.

EOF
    while true; do
        read -rp "Do you want to continue with the installation? (Y/N) " yn
        case "${yn}" in
            [Yy]*)
                apt_install_packages
                break;;
            [Nn]*)
                echo "Installation skipped, exiting!"
                break;;
            *) echo "Please answer Y or N";;
        esac
    done
else
    echo -e "\033[00;33mSystem package installation was skipped!\033[0m"
fi
}

#  _______  _______  _______  _______  _______  _______  _______
# (  ____ )(  ____ )(  ___  )(  ____ \(  ____ \(  ____ \(  ____ \
# | (    )|| (    )|| (   ) || (    \/| (    \/| (    \/| (    \/
# | (____)|| (____)|| |   | || |      | (__    | (_____ | (_____
# |  _____)|     __)| |   | || |      |  __)   (_____  )(_____  )
# | (      | (\ (   | |   | || |      | (            ) |      ) |
# | )      | ) \ \__| (___) || (____/\| (____/\/\____) |/\____) |
# |/       |/   \__/(_______)(_______/(_______/\_______)\_______)

_distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')

case $_distro in
    *macos*)
        installBrew
        ;;
    *arch*)
        background_checks
        arch_check
        pacman_check
        keysReset
        installArc
        userInfo
        installAUR
        ;;
    *manjaro*)
        background_checks
        arch_check
        pacman_check
        keysReset
        installArc
        userInfo
        installAUR
        ;;
    *debian*)
        background_checks
        installDeb
        userinfo
        ;;
    *ubuntu*)
        background_checks
        installDeb
        userinfo
        ;;
    *raspbian*)
        background_checks
        installDeb
        userinfo
        ;;
    *elementary*)
        background_checks
        installDeb
        userinfo
        ;;
    *linuxmint*)
        background_checks
        installDeb
        userinfo
        ;;
    *kali*)
        background_checks
        installDeb
        userinfo
        ;;
    *alpine*)
        echo "ALPINE"
        ;;
    *fedora*)
        echo "FEDORA - DNF, RPM"
        ;;
    *coreos*)
        echo "COREOS"
        ;;
    *gentoo*)
        echo "GENTOO"
        ;;
    *mageia*)
        echo "MEGEIA"
        ;;
    *centos*)
        echo "CENTOS - DNF, RPM"
        ;;
    *opensuse*|*tumbleweed*)
        echo "OPENSUSE"
        ;;
    *sabayon*)
        echo "SABAYON"
        ;;
    *slackware*)
        echo "SLACEWARE"
        ;;
    *aosc*)
        echo "AOSC"
        ;;
    *nixos*)
        echo "NIXOS"
        ;;
    *devuan*)
        echo "DEVUAN"
        ;;
    *rhel*)
        echo "RHEL"
        ;;
    *)
        echo "Unknown OS. Exiting!"
        exit 1
        ;;
esac