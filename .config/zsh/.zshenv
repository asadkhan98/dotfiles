source $HOME/.env.sh
# Default Apps
export term="xterm-256color"
export EDITOR="code"
export OPENER="xdg-open"
export BROWSER="zen"
export TERMINAL="kitty"

export EZA_COLORS="da=4;31"

## Directories
# ZSH Directory Location
export ZDOTDIR=$HOME/.config/zsh
# Set up a few standard directories based on:
# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# Add all local binaries to the system path.
export PATH="${PATH}:${HOME}/.local/bin"

# Disable files
export LESSHISTFILE=-

# LF Icons
[ -f "${HOME}/.config/lf/LF_ICONS" ] && source "${HOME}/.config/lf/LF_ICONS"