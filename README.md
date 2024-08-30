<div align="justify">
<div align="center">

```ocaml
NEVER SKIP / IGNORE / AVOID README
```
<h1>
    <a name="top" title="dotfiles">~/.📂</a><br/>Cross-platform, cross-shell dotfiles<br/> <sup><sub>powered by  <a href="https://shaky.sh/simple-dotfiles/">shaky.sh</a> 🏠</sub></sup>
</h1>

<pre align="center">
<a href="#-setup">SETUP</a> • <a href="#-tools">TOOLS</a> • <a href="#-keybinds">KEYBINDS</a> • <a href="#-gallery">GALLERY</a>
</pre>


Universal dotfiles with custom bootstrap.  Works on Linux, MacOS, Windows & WSL.


<div align="center">
    <p><strong>Be sure to <a href="#" title="star">⭐️</a> or <a href="#" title="fork">🔱</a> this repo if you find it useful! 😃</strong></p>
</div>
</div>

# 🥅 Project Goals
-   Unified set of aliases and commands.
-   Familiar feel and creature comforts across environments.
-   Easy access to common paths.
-   MacOS Script
-   Windows Script
-   Add Keybinds
-   Add Screenshots

# 🚀 Setup📡🔭

>⚠️ If you don't fully understand what [~/.bootstrap.sh](bootstrap.sh) does, DO NOT run the script.

<details>
<summary><b>Dependencies</b></summary>

Before you get started, there are a few dependencies that need to be fulfilled in order to run [~/.bootstrap.sh](bootstrap.sh)
- [Git](https://git-scm.com/)
- [Gum](https://github.com/charmbracelet/gum)
</details>
<details>
<summary><b>Customization</b></summary>

- **Packages**
  - [packages.conf](./bootstrap/packages.conf): Packages to be installed
- **Dotfiles**
  - [user.links.prop](./bootstrap/user.links.prop): Installs dotfiles for user only
  - [system.links.prop](./bootstrap/system.links.prop): Installs dotfiles system wide
</details>

Once the dependencies are met, you can clone the repository to your desired location and launch [~/.bootstrap.sh](bootstrap.sh) to install the dotfiles.

```bash
cd && git clone --depth 1 https://github.com/CodecoLabs/dotfiles ".dotfiles" && cd .dotfiles
```

Run [~/.bootstrap.sh](bootstrap.sh) with `./bootstrap.sh` or `bash bootstrap.sh`
and follow the prompts.



<p align="right"><a href="#top" title="Back to top">🔝</a></p>

# 🧰 Tools
<div align="center">
🐧: Linux
🍏: MacOS
🪟: Windows
</div>

### 🐚 Shells

-   [Z shell](http://zsh.sourceforge.net/) <b title="Linux">🐧</b><b title="MacOS">🍏</b>: [`~/.config/zsh/.zshrc`](./.config/zsh/.zshrc) _<sup>enhanced with [**Oh-My-Zsh**](https://ohmyz.sh/), [**Powerlevel10K**](https://github.com/romkatv/powerlevel10k), and others!</sup>_
-   [Bash](https://www.gnu.org/software/bash/) <b title="Linux">🐧</b><b title="MacOS">🍏</b>: [`~/.config/bash/.bashrc`](./.config/bash/.bashrc) _<sup>enhanced with [**Bash-It**](https://github.com/Bash-it/bash-it)!</sup>_
-   [PowerShell 7.3+](https://github.com/PowerShell/PowerShell) <b title="Linux">🐧</b><b title="MacOS">🍏</b><b title="Windows">🪟</b>: [`~/.config/pwsh/profile`](./.config/pwsh/profile.ps1) _<sup>enhanced with [**Oh-My-Posh**](https://github.com/JanDeDobbeleer/oh-my-posh), [**Terminal Icons**](https://github.com/devblackops/Terminal-Icons), and others!</sup>_

### 💻 Terminals

-   [Hyper](https://hyper.is/) <b title="Linux">🐧</b><b title="MacOS">🍏</b><b title="Windows">🪟</b>: [`~/.hyper.js`](./dot_hyper.js.tmpl)
-   [Kitty](https://sw.kovidgoyal.net/kitty/) <b title="Linux">🐧</b><b title="MacOS">🍏</b>: [`~/.config/kitty/kitty.conf`](./.config/kitty/kitty.conf)
-   [Windows Terminal](https://github.com/microsoft/terminal) <b title="Windows">🪟</b>: [`~/.config/windows_term/settings.json`](./.config/windows_term/settings.json)


### 📦 Package managers
-   [PacMan](https://scoop.sh/) <b title="Arch">🐧</b>
-   [Homebrew](https://brew.sh/) <b title="MacOS">🍏</b>
-   [Winget](https://github.com/microsoft/winget-cli) <b title="Windows">🪟</b>
-   [Scoop](https://scoop.sh/) <b title="Windows">🪟</b>


### 💾 Universal apps <b title="Linux">🐧</b><b title="macOS">🍏</b><b title="Windows">🪟</b>

-   [chezmoi](https://www.chezmoi.io/) dotfiles manager: [`~/.chezmoi.toml`](./.chezmoi.toml.tmpl)
-   [cURL](https://curl.haxx.se/) data transfer tool: [`~/.curlrc`](./dot_curlrc)
-   [Git :octocat:](https://git-scm.com/) version-control system: [`~/.gitconfig`](./dot_gitconfig.tmpl)
-   [GNU Nano 4.x+](https://www.nano-editor.org/) text editor: [`~/.nanorc`](./dot_nanorc) _<sup>enhanced with [**Improved Nano Syntax Highlighting Files**](https://github.com/scopatz/nanorc)!</sup>_
-   [GNU Wget](https://www.gnu.org/software/wget/) HTTP/FTP file downloader: [`~/.wgetrc`](./dot_wgetrc)
-   [Micro](https://micro-editor.github.io/) text editor: [`~/.config/micro/`](./dot_config/micro)
-   [OpenSSH](https://www.openssh.com/) secure networking utilities: [`~/.ssh/config`](./dot_ssh/config.tmpl)
-   [Ripgrep](https://github.com/BurntSushi/ripgrep) fast-search tool: [`~/.ripgreprc`](./dot_ripgreprc)
-   [SQLite3](https://www.sqlite.org/cli.html) database client: [`~/.sqliterc`](./dot_sqliterc)
-   [Starship 🚀](https://starship.rs) cross-shell prompt: [`~/.config/starship.toml`](./dot_config/starship.toml)
-   [tmux](https://github.com/tmux/tmux/wiki) terminal multiplexer: [`~/.tmux.conf.local`](./dot_tmux.conf.local) _<sup>enhanced with [**Oh-My-Tmux**](https://github.com/gpakosz/.tmux)!</sup>_
-   [Vim](https://www.vim.org/) text editor: [`~/.vimrc`](./dot_vimrc) _<sup>enhanced with [**Ultimate vimrc**](https://github.com/amix/vimrc)!</sup>_

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

# ⌨️ Keybinds
Add keybinds for all app heres
<p align="right"><a href="#top" title="Back to top">🔝</a></p>

# 🖼️ Gallery
Add screenshots here
<p align="right"><a href="#top" title="Back to top">🔝</a></p>

# 💡 Inspirations
-   [GitHub: dotfiles](https://dotfiles.github.io/)
-   [GitHub: owl4ce's dotfiles](https://github.com/owl4ce/dotfiles)
-   [GitHub: renemarc dotfiles](https://github.com/renemarc/dotfiles)
-   [GitHub: andrew8088's dotfiles](https://github.com/andrew8088/dotfiles)

<p align="right"><a href="#top" title="Back to top">🔝</a></p>
