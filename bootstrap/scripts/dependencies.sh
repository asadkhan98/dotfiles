#!/bin/sh

set -e
#     _             _
#    / \   _ __ ___| |__
#   / _ \ | '__/ __| '_ \
#  / ___ \| | | (__| | | |
# /_/__ \_\_| _\___|_| |_|
function pacman_install_packages {
    sudo pacman -Syyu && sudo pacman -S --noconfirm git gum binutils pkg-config pkgfile
}

function installArc {
    pacman_install_packages
}


#  ____       _     _
# |  _ \  ___| |__ (_) __ _ _ __
# | | | |/ _ \ '_ \| |/ _` | '_ \
# | |_| |  __/ |_) | | (_| | | | |
# |____/_\___|_.__/|_|\__,_|_|_|_|
function apt_install_packages {
    # shellcheck disable=SC2086
    sudo apt-get update && sudo apt-get install -y git gum binutils pkg-config pkgfile
}

function installDeb {
    apt_install_packages
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
    brew install git gum binutils pkg-config pkgfile
}

function installBrew {
    brew_install_self
    brew_install_packages
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

echo -ne "Your current operating system is ${_distro}"

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
