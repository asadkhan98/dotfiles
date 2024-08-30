# ██████╗  ██████╗ ██╗    ██╗███████╗██████╗ ███████╗██╗  ██╗███████╗██╗     ██╗
# ██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗██╔════╝██║  ██║██╔════╝██║     ██║
# ██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝███████╗███████║█████╗  ██║     ██║
# ██╔═══╝ ██║   ██║██║███╗██║██╔══╝  ██╔══██╗╚════██║██╔══██║██╔══╝  ██║     ██║
# ██║     ╚██████╔╝╚███╔███╔╝███████╗██║  ██║███████║██║  ██║███████╗███████╗███████╗
# ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝

#     ____                             __
#    / __ \_________  ____ ___  ____  / /_
#   / /_/ / ___/ __ \/ __ `__ \/ __ \/ __/
#  / ____/ /  / /_/ / / / / / / /_/ / /_
# /_/   /_/   \____/_/ /_/ /_/ .___/\__/
#                           /_/

Import-Module -Name Terminal-Icons
Import-Module posh-git
Invoke-Expression (&starship init powershell)

#    _____      __  __  _
#   / ___/___  / /_/ /_(_)___  ____ ______
#   \__ \/ _ \/ __/ __/ / __ \/ __ `/ ___/
#  ___/ /  __/ /_/ /_/ / / / / /_/ (__  )
# /____/\___/\__/\__/_/_/ /_/\__, /____/
#                           /____/

Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -PredictionSource HistoryAndPlugin

#     ___    ___
#    /   |  / (_)___ _________  _____
#   / /| | / / / __ `/ ___/ _ \/ ___/
#  / ___ |/ / / /_/ (__  )  __(__  )
# /_/  |_/_/_/\__,_/____/\___/____/



# General
Set-Alias btw 'winfetch'
Set-Alias c 'code'
# Useful shortcuts for traversing directories
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
# Make it easy to edit this profile once it's installed
function Edit-Profile {
    code $PROFILE
}
function reload-profile {
    & $profile
}
function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | select-string $regex
        return
    }
    $input | select-string $regex
}
function touch($file) {
    "" | Out-File $file -Encoding ASCII
}
function df {
    get-volume
}
function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}
function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}
function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}
function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}
function pgrep($name) {
    Get-Process $name
}
function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter .\cove.zip | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}
# Compute file hashes - useful for checking successful downloads
function md5 { Get-FileHash -Algorithm MD5 $args }
function sha1 { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }
# Drive shortcuts
function HKLM: { Set-Location HKLM: }
function HKCU: { Set-Location HKCU: }
function Env: { Set-Location Env: }
# SSH
function sshrsa { ssh-keygen -t rsa -b 4096 }
function sshag { eval "$(ssh-agent -s)" }
function sshgl { ssh-add ~/.ssh/id_GitLab }
# Git

Set-Alias g 'git'
function ga { git add }
function gaa { git add --all}
function gapa { git add --patch }
function gau { git add --update }
function gav { git add --verbose }
function gap { git apply}
function gapt { git apply --3way }

function gb { git branch }
function gba { git branch -a }
function gbd { git branch -d }
function gbda { git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | command xargs git branch -d 2>/dev/null}
function gbD { git branch -D }
function gbnm { git branch --no-merged }
function gbr { git branch --remote}
function gbl { git blame -b -w}
function gbs { git bisect }
function gbsb { git bisect bad}
function gbsg { git bisect good}
function gbsr { git bisect reset}
function gbss { git bisect start}

function gcc { git commit -v }
function gc! { git commit -v --amend }
function gcn! { git commit -v --no-edit --amend }
function gca { git commit -v -a }
function gca! { git commit -v -a --amend }
function gcan! { git commit -v -a --no-edit --amend }
function gcans! { git commit -v -a -s --no-edit --amend }
function gcam { git commit -a -m }
function gcsm { git commit -s -m }
function gcas { git commit -a -s }
function gcasm { git commit -a -s -m }
function gcb { git checkout -b }
function gcf { git config --list }
function gcl { git clone --recurse-submodules }
function gclean { git clean -id }
function gpristine { git reset --hard && git clean -dffx }
function gccm { git checkout $(git_main_branch) }
function gcd { git checkout $(git_develop_branch) }
function gcmsg { git commit -m }
function gco { git checkout }
function gcor { git checkout --recurse-submodules }
function gcount { git shortlog -sn }
function gcp { git cherry-pick }
function gcpa { git cherry-pick --abort }
function gcpc { git cherry-pick --continue }
function gccs { git commit -S }
function gcss { git commit -S -s }
function gcssm { git commit -S -s -m }

function gd { git diff }
function gdca { git diff --cached }
function gdcw { git diff --cached --word-diff }
function gdct { git describe --tags $(git rev-list --tags --max-count=1) }
function gds { git diff --staged }
function gdt { git diff-tree --no-commit-id --name-only -r }
function gdu { 'git diff @{u}' }
function gdw { git diff --word-diff }