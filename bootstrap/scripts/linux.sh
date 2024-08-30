#!/usr/bin/env bash

source $STRAP_DIR/configs/packages.conf

#  _______           _        _______ __________________ _______  _        _______
# (  ____ \|\     /|( (    /|(  ____ \\__   __/\__   __/(  ___  )( (    /|(  ____ \
# | (    \/| )   ( ||  \  ( || (    \/   ) (      ) (   | (   ) ||  \  ( || (    \/
# | (__    | |   | ||   \ | || |         | |      | |   | |   | ||   \ | || (_____
# |  __)   | |   | || (\ \) || |         | |      | |   | |   | || (\ \) |(_____  )
# | (      | |   | || | \   || |         | |      | |   | |   | || | \   |      ) |
# | )      | (___) || )  \  || (____/\   | |   ___) (___| (___) || )  \  |/\____) |
# |/       (_______)|/    )_)(_______/   )_(   \_______/(_______)|/    )_)\_______)

set -e

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

#  __  __             ___  ____
# |  \/  | __ _  ___ / _ \/ ___|
# | |\/| |/ _` |/ __| | | \___ \
# | |  | | (_| | (__| |_| |___) |
# |_|  |_|\__,_|\___|\___/|____/
function brew_install_self {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

function brew_install_packages {
    [ -x "$(command -v brew > /dev/null 2>&1)" ] && brew_install_self

    # shellcheck disable=SC2086
    brew install ${brew_packages} ${brew_packages_optional}
}

function display_packages_brew {
    echo -ne "Required: \033[00;32m${brew_packages}\033[0m
Optional: \033[00;32m${brew_packages_optional}\033[0m"
}

installBrew() {
if [ -z "${skip_system_packages}" ]; then
cat << EOF

This script will install the following packages listed below.

$(display_packages_brew)

If you choose no, the packages listed above will not be installed and this script
will continue. This gives you a chance to edit the list of packages (packages.conf)
if you don't agree with any of the decisions.

EOF
    while true; do
        read -rp "Do you want to continue with the installation? (Y/N) " yn
        case "${yn}" in
            [Yy]*)
                brew_install_packages
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
        installArc
        ;;
    *manjaro*)
        installArc
        ;;
    *debian*)
        installDeb
        ;;
    *ubuntu*)
        installDeb
        ;;
    *raspbian*)
        installDeb
        ;;
    *elementary*)
        installDeb
        ;;
    *linuxmint*)
        installDeb
        ;;
    *kali*)
        installDeb
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

