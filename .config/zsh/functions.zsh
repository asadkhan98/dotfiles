# Change cursor shape for different vi modes
#function zle-keymap-select {
#  if [[ ${KEYMAP} == vicmd ]] ||
#     [[ $1 = 'block' ]]; then
#    echo  -ne '\e[1 q'
#  elif [[ ${KEYMAP} == main ]] ||
#       [[ ${KEYMAP} == viins ]] ||
#       [[ ${KEYMAP} == '' ]] ||
#       [[ $1 = "beam" ]]; then
#    echo -ne '\e[5 q'
#  fi
#}
#zle -N zle-keymap-select

# ci", ci', ci`, di", etc
#autoload -U select-quoted
#zle -N select-quoted
#for m in visual viopp; do
#  for c in {a,i}{\',\",\`}; do
#    bindkey -M $m $c select-quoted
#  done
#done

# ci{, ci(, ci<, di{, etc
#autoload -U select-bracketed
#zle -N select-bracketed
#for m in visual viopp; do
#  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
#    bindkey -M $m $c select-bracketed
#  done
#done

#zle-line-init() {
#    zle -K viins # Initiate 'vi insert as keymap'
#    echo -ne "\e[5 q"
#}
#zle -N zle-line-init

#echo -ne '\e[5 q'  # Use beam shape as cursor on startup
#precmd() { echo -ne '\e[5 q' ;} # Use beam shape for each new prompt

# LF Directory switching
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

function reflector_mirror() {
  sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && sudo reflector -c Canada -a 24 --sort rate --save /etc/pacman.d/mirrorlist
}

function pacmansignkeys() {
  local key
  for key in $@; do
    sudo pacman-key --recv-keys $key
    sudo pacman-key --lsign-key $key
    printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
      --no-permission-warning --command-fd 0 --edit-key $key
  done
}

if (( $+commands[xdg-open] )); then
  function pacweb() {
    if [[ $# = 0 || "$1" =~ '--help|-h' ]]; then
      local underline_color="\e[${color[underline]}m"
      echo "$0 - open the website of an ArchLinux package"
      echo
      echo "Usage:"
      echo "    $bold_color$0$reset_color ${underline_color}target${reset_color}"
      return 1
    fi

    local pkg="$1"
    local infos="$(LANG=C pacman -Si "$pkg")"
    if [[ -z "$infos" ]]; then
      return
    fi
    local repo="$(grep -m 1 '^Repo' <<< "$infos" | grep -oP '[^ ]+$')"
    local arch="$(grep -m 1 '^Arch' <<< "$infos" | grep -oP '[^ ]+$')"
    xdg-open "https://www.archlinux.org/packages/$repo/$arch/$pkg/" &>/dev/null
  }
fi

function ClearRamCache(){
  sudo sh -c "echo 1 > /proc/sys/vm/drop_caches"
}
