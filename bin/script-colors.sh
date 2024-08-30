#!/usr/bin/env bash
------------------------------------------------------------
# Foreground Colors
black='\e[30m'
red='\e[31m'
green='\e[32m'
yellow='\e[33m'
blue='\e[34m'
magenta='\e[35m'
cyan='\e[36m'
lightgray='\e[37m'
gray='\e[90m'
lightred='\e[91m'
lightgreen='\e[92m'
lightyellow='\e[93m'
lightblue='\e[94m'
lightmagenta='\e[95m'
lightcyan='\e[96m'
white='\e[97m'
# Background Colors
BLACK='\e[40m'
RED='\e[41m'
GREEN='\e[42m'
YELLOW='\e[43m'
BLUE='\e[44m'
MAGENTA='\e[45m'
CYAN='\e[46m'
LIGHTGRAY='\e[47m'
GRAY='\e[100m'
LIGHTRED='\e[101m'
LIGHTGREEN='\e[102m'
LIGHTYELLOW='\e[103m'
LIGHTBLUE='\e[104m'
LIGHTMAGENTA='\e[105m'
LIGHTCYAN='\e[106m'
WHITE='\e[107m'
# Specials
BOLD='\e[1m'
DIM='\e[2m'
ITALICS='\e[3m'
UNDERLINE='\e[4m'
BLINK='\e[5m'
INVERT='\e[7m'
HIDDEN='\e[8m'
STRIKE='\e[9m'
# Resets
NORMAL='\e[0m'
RBOL='\e[21m'
RDIM='\e[22m'
RITA='\e[23m'
RUND='\e[24m'
RBLI='\e[25m'
RINV='\e[27m'
RHID='\e[28m'
RSTR='\e[29m'
------------------------------------------------------------

# Sample

echo "Foreground Colors"
echo -e "${black}Black Foreground${red} Red Foreground${green} Green Foreground${yellow} Yellow Foreground${blue} Blue Foreground${magenta} Magenta Foreground${cyan} Cyan Foreground${lightgray} Light Gray Foreground${gray} Gray Foreground${lightred} Light Red Foreground${lightgreen} Light Green Foreground${lightyellow} Light Yellow Foreground${lightblue} Light Blue Foreground${lightmagenta} Light Magenta Foreground${lightgray} Light Gray Foreground${white} White Foreground${NORMAL}"

echo "Background Colors"
echo -e "${white}${BLACK}Black Background${NORMAL} ${black}${RED}Red Background${NORMAL} ${black}${GREEN}Green Background${NORMAL} ${black}${YELLOW}Yellow Background${NORMAL} ${black}${BLUE}Blue Background${NORMAL} ${black}${MAGENTA}Magenta Background${NORMAL} ${black}${CYAN}Cyan Background${NORMAL} ${black}${LIGHTGRAY}Light Gray Background${NORMAL} ${black}${GRAY}Gray Background${NORMAL} ${black}${LIGHTRED}Light Red Background${NORMAL} ${black}${LIGHTGREEN}Light Green Background${NORMAL} ${black}${LIGHTYELLOW}Light Yellow Background${NORMAL} ${black}${LIGHTBLUE}Light Blue Background${NORMAL} ${black}${LIGHTMAGENTA}Light Magenta Background${NORMAL} ${black}${LIGHTGRAY}Light Gray Background${NORMAL} ${black}${WHITE}White Background${NORMAL}"

echo "Specials"
echo -e "${BOLD}Bold Text${NORMAL} ${DIM}Dim Text${NORMAL} ${ITALICS}Italics Text${NORMAL} ${UNDERLINE}Underline Text${NORMAL} ${BLINK}Blinking Text${NORMAL} ${INVERT}Inverted Text${NORMAL} ${HIDDEN}Hidden Text${NORMAL} ${STRIKE}Strike Text${RSTR} ${NORMAL} Normal Text"