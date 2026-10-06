# ⭐ Starship Shellcraft

**A beautiful, portable and intelligent Bash environment for Linux & WSL.**

Starship Shellcraft transforms a normal Bash terminal into a modern, productive and customizable shell environment powered by **Starship**, **ble.sh**, **bash-completion**, **fzf** and **zoxide**.

![Version](https://img.shields.io/badge/version-v1.2.0-blue)
![Linux](https://img.shields.io/badge/Linux-Supported-success)
![WSL](https://img.shields.io/badge/WSL-Supported-success)
![APT](https://img.shields.io/badge/APT-Supported-success)
![Pacman](https://img.shields.io/badge/Pacman-Supported-success)
![DNF](https://img.shields.io/badge/DNF-Supported-success)
![Zypper](https://img.shields.io/badge/Zypper-Supported-success)
![License](https://img.shields.io/badge/license-MIT-blue)

---

## ✨ Features

Starship Shellcraft provides a complete Bash environment with:

- ⭐ Starship prompt
- 🎨 Built-in Starship themes
- 🧠 ble.sh autosuggestions
- 🌈 ble.sh syntax highlighting
- 📦 bash-completion
- 🔎 fzf fuzzy history search
- 📁 fzf file search
- 🧭 zoxide smart directory navigation
- 🖥️ Linux and WSL support
- 🔍 Automatic OS detection
- 📦 Automatic package-manager detection
- 🔧 Doctor and repair utilities
- 🎛️ Interactive CLI menu
- 🔄 Theme switching without reinstalling
- 🛡️ Safe `.bashrc` configuration management
- 📦 Native Linux package support
- 🚀 GitHub Actions automated releases

---

# 📦 Supported Linux Distributions

Shellcraft automatically detects the distribution and selects the appropriate package manager.

| Distribution | Package Manager | Native Package | Status |
|---|---|---|---|
| Debian | APT | `.deb` | ✅ Supported |
| Ubuntu | APT | `.deb` | ✅ Supported |
| Linux Mint | APT | `.deb` | ✅ Supported |
| Pop!_OS | APT | `.deb` | ✅ Supported |
| Kali Linux | APT | `.deb` | ✅ Supported |
| Arch Linux | Pacman | `.pkg.tar.zst` | ✅ Supported |
| Manjaro | Pacman | `.pkg.tar.zst` | ✅ Supported |
| EndeavourOS | Pacman | `.pkg.tar.zst` | ✅ Supported |
| Garuda Linux | Pacman | `.pkg.tar.zst` | ✅ Supported |
| Fedora | DNF | `.rpm` | ✅ Supported |
| RHEL | DNF | `.rpm` | ✅ Supported |
| Rocky Linux | DNF | `.rpm` | ✅ Supported |
| AlmaLinux | DNF | `.rpm` | ✅ Supported |
| CentOS | DNF | `.rpm` | ✅ Supported |
| openSUSE | Zypper | `.rpm` | ✅ Supported |
| SLES | Zypper | `.rpm` | ✅ Supported |

### Generic Linux

A generic `.tar.gz` package is also provided for systems where a native package is not available.

---

# 🚀 Installation

## One-Line Installer

The easiest way to install Shellcraft:

```bash
curl -fsSL https://github.com/mohammadanarul/starship-shellcraft/main/install.sh | bash
```

The installer automatically detects the Linux distribution and uses:

```text
Debian/Ubuntu → APT
Arch family   → Pacman
Fedora/RHEL   → DNF
openSUSE/SLES → Zypper
```

---

# 📦 Native Package Installation

GitHub Releases provide native packages for supported Linux distributions.

## Debian / Ubuntu

Download the `.deb` package:

```bash
sudo dpkg -i starship-shellcraft_1.2.0_all.deb
```

Then configure the current user:

```bash
starship-shellcraft install
```

Or:

```bash
ssc install
```

If dependency resolution is required:

```bash
sudo apt-get install -f
```

---

## Fedora / RHEL / Rocky / AlmaLinux

Download the `.rpm` package:

```bash
sudo dnf install ./starship-shellcraft-1.2.0-1.noarch.rpm
```

Then:

```bash
ssc install
```

---

## openSUSE / SLES

The RPM package can also be installed using Zypper:

```bash
sudo zypper install ./starship-shellcraft-1.2.0-1.noarch.rpm
```

Then:

```bash
ssc install
```

---

## Arch / Manjaro / EndeavourOS

Download the Arch package:

```bash
sudo pacman -U starship-shellcraft-1.2.0-1-any.pkg.tar.zst
```

Then:

```bash
ssc install
```

---

# 🖥️ WSL Support

Starship Shellcraft is designed to work with Windows Subsystem for Linux.

When running inside WSL, Shellcraft automatically detects the Windows username.

For example:

```text
Windows user:
mdana

Detected startup path:
/mnt/c/Users/mdana
```

No username is hard-coded.

Shellcraft checks whether the detected Windows directory exists.

If it does:

```text
/mnt/c/Users/<detected-user>
```

is used as the default startup path.

If it does not exist, Shellcraft safely falls back to:

```text
$HOME
```

---

# 🐧 Native Linux Behavior

Outside WSL, Shellcraft does **not** attempt to use a Windows path.

Native Linux systems use:

```text
$HOME
```

For example:

```text
/home/user
```

---

# 🎨 Theme Manager

Shellcraft includes a built-in theme manager.

List themes:

```bash
ssc theme list
```

Show current theme:

```bash
ssc theme current
```

Change theme:

```bash
ssc theme set nord
```

Preview a theme:

```bash
ssc theme preview nord
```

Reset to the default theme:

```bash
ssc theme reset
```

---

## 🎨 Built-in Themes

Shellcraft currently includes:

```text
Tokyo Night
Nord
Dracula
Gruvbox
Catppuccin Mocha
Minimal
```

Theme files are stored in:

```text
~/.config/shellcraft/themes/
```

You can add your own Starship theme:

```text
~/.config/shellcraft/themes/my-theme.toml
```

Then:

```bash
ssc theme set my-theme
```

No reinstall is required.

---

# 🧰 CLI

Shellcraft provides both a full command and a short command.

Full command:

```bash
starship-shellcraft
```

Short command:

```bash
ssc
```

---

# 📋 Commands

## Install

Install/configure Shellcraft:

```bash
ssc install
```

---

## Information

Show Shellcraft and system information:

```bash
ssc info
```

Example:

```text
Starship Shellcraft
===================

Version            : 1.2.0
OS                 : Ubuntu 24.04 LTS
Package manager    : apt
Architecture       : x86_64
WSL                : yes
Kernel             : ...
User               : mdana
Shell              : /bin/bash
Bash               : ...
Default path       : /mnt/c/Users/mdana
Current theme      : tokyo-night
Config             : ~/.config/shellcraft
Starship config    : ~/.config/starship.toml
```

---

## Doctor

Check the installation:

```bash
ssc doctor
```

The doctor checks:

- Operating system
- Architecture
- WSL
- User
- Shell
- Package manager
- Starship
- fzf
- zoxide
- git
- `.bashrc`
- Starship configuration

---

## Repair

Repair dependencies and Shellcraft configuration:

```bash
ssc repair
```

This can reinstall missing dependencies and restore the managed Bash configuration.

---

## Update

Check update information:

```bash
ssc update
```

---

## Version

```bash
ssc version
```

or:

```bash
ssc --version
```

---

## Help

```bash
ssc help
```

---

## Uninstall

Remove Shellcraft-managed configuration:

```bash
ssc uninstall
```

Shellcraft does not intentionally remove your manually installed Starship installation.

---

# 🧠 Shell Intelligence

Shellcraft combines several tools to provide a modern Bash experience.

## Starship

Provides the modern terminal prompt.

```text
~/project main ❯
```

---

## ble.sh

Provides:

- Autosuggestions
- Syntax highlighting
- Better interactive Bash editing

---

## bash-completion

Provides contextual completion.

Examples:

```bash
cd <TAB>
```

shows directories.

```bash
nvim <TAB>
```

shows files.

Command-specific completion can work for:

```text
git
docker
ssh
systemctl
apt
pacman
dnf
zypper
```

where supported by the installed completion definitions.

---

## fzf

Fuzzy searching from the terminal.

Common shortcuts:

```text
Ctrl + R
```

Search command history.

```text
Ctrl + T
```

Search files.

---

## zoxide

Smart directory navigation.

Example:

```bash
z project
```

Instead of manually typing a long path.

---

# 🛡️ Safe `.bashrc` Management

Shellcraft does **not** replace the entire `.bashrc`.

It manages only a dedicated block:

```bash
# >>> starship-shellcraft >>>

...

# <<< starship-shellcraft <<<
```

Everything outside this block is preserved.

This means existing aliases, functions and personal configuration remain untouched.

---

# ⚙️ Configuration

Shellcraft configuration:

```text
~/.config/shellcraft/
```

Themes:

```text
~/.config/shellcraft/themes/
```

State:

```text
~/.config/shellcraft/state
```

Starship configuration:

```text
~/.config/starship.toml
```

---

# 🔤 Nerd Font

For the best terminal icons, install:

**FiraCode Nerd Font**

on Windows and select it in Windows Terminal.

Shellcraft does not attempt to install Windows fonts from inside Linux/WSL.

For WSL users:

```text
Windows
   ↓
Windows Terminal
   ↓
FiraCode Nerd Font
   ↓
WSL Bash
   ↓
Starship Shellcraft
```

---

# 📦 Package Architecture

Shellcraft separates the shell environment from the Linux package manager.

```text
                  Starship Shellcraft
                         │
              Automatic OS Detection
                         │
        ┌────────────────┼────────────────┐
        │                │                │
       APT            Pacman            DNF
        │                │                │
      Debian           Arch            Fedora
      Ubuntu          Manjaro           RHEL
        │                │                │
      .deb          .pkg.tar.zst        .rpm
                         │
                         │
                      Zypper
                         │
                     openSUSE
                         │
                       .rpm
```

This architecture makes it possible to add additional package managers later without changing the core Shellcraft CLI.

---

# 🏗️ Project Structure

```text
starship-shellcraft/
│
├── .github/
│   └── workflows/
│       └── release.yml
│
├── lib/
│   ├── common.sh
│   ├── detect.sh
│   ├── packages.sh
│   ├── runtime.sh
│   └── theme.sh
│
├── themes/
│   ├── tokyo-night.toml
│   ├── nord.toml
│   ├── dracula.toml
│   ├── gruvbox.toml
│   ├── catppuccin-mocha.toml
│   └── minimal.toml
│
├── packaging/
│   ├── deb/
│   │   └── build-deb.sh
│   │
│   ├── rpm/
│   │   ├── build-rpm.sh
│   │   └── starship-shellcraft.spec
│   │
│   ├── arch/
│   │   ├── build-pkg.sh
│   │   └── PKGBUILD
│   │
│   └── tarball/
│       └── build-tarball.sh
│
├── install.sh
├── shellcraft
├── VERSION
├── README.md
├── LICENSE
└── .gitignore
```

---

# 🚀 GitHub Releases

Shellcraft uses semantic versioning:

```text
v1.0.0
v1.1.0
v1.2.0
v1.3.0
```

Creating a version tag triggers the GitHub Actions release workflow.

Example:

```bash
git tag -a v1.2.0 -m "Starship Shellcraft v1.2.0"
git push origin v1.2.0
```

GitHub Actions automatically builds:

```text
starship-shellcraft_1.2.0_all.deb

starship-shellcraft-1.2.0-1.noarch.rpm

starship-shellcraft-1.2.0-1-any.pkg.tar.zst

starship-shellcraft-1.2.0.tar.gz
```

The generated artifacts are automatically attached to the GitHub Release.

---

# 🔄 Release Pipeline

```text
Git Tag
  │
  │ v1.2.0
  ▼
GitHub Actions
  │
  ├── Ubuntu Runner
  │      └── .deb
  │
  ├── Fedora Runner
  │      └── .rpm
  │
  ├── Arch Runner
  │      └── .pkg.tar.zst
  │
  └── Ubuntu Runner
         └── .tar.gz
  │
  ▼
GitHub Release
```

---

# 🧪 Development

Clone the repository:

```bash
git clone https://github.com/mohammadanarul/starship-shellcraft.git
cd starship-shellcraft
```

Run the installer locally:

```bash
./install.sh
```

Run the CLI directly:

```bash
./shellcraft info
```

Run syntax checks:

```bash
bash -n shellcraft

find . -name "*.sh" -print0 |
  xargs -0 -n1 bash -n
```

---

# 📦 Building Packages Locally

## Debian

```bash
./packaging/deb/build-deb.sh
```

Output:

```text
starship-shellcraft_1.2.0_all.deb
```

---

## RPM

On Fedora/RHEL:

```bash
./packaging/rpm/build-rpm.sh
```

Requires:

```bash
sudo dnf install rpm-build
```

---

## Arch

On Arch Linux:

```bash
./packaging/arch/build-pkg.sh
```

Requires:

```bash
sudo pacman -S base-devel
```

The build uses `makepkg` as a non-root user.

---

## Generic Tarball

```bash
./packaging/tarball/build-tarball.sh
```

Output:

```text
starship-shellcraft-1.2.0.tar.gz
```

---

# 🗺️ Roadmap

## v1.x

- [x] Starship integration
- [x] Bash environment
- [x] ble.sh integration
- [x] bash-completion
- [x] fzf integration
- [x] zoxide integration
- [x] Theme manager
- [x] WSL support
- [x] Automatic package-manager detection
- [x] APT support
- [x] Pacman support
- [x] DNF support
- [x] Zypper support
- [x] `.deb` package
- [x] `.rpm` package
- [x] Arch package
- [x] Generic tarball
- [x] GitHub Actions release pipeline
- [x] Doctor
- [x] Repair
- [x] Safe `.bashrc` management

## Future

- [ ] Automatic self-update
- [ ] More built-in themes
- [ ] Theme marketplace/repository
- [ ] Additional Linux package managers
- [ ] Homebrew support
- [ ] Better shell plugin architecture
- [ ] Automated integration tests
- [ ] Distribution repository packages

---

# 🤝 Contributing

Contributions are welcome.

Fork the repository:

```bash
git clone https://github.com/YOUR_USERNAME/starship-shellcraft.git
cd starship-shellcraft
```

Create a branch:

```bash
git checkout -b feature/my-feature
```

Make your changes and test them.

Then:

```bash
git add .
git commit -m "Add my feature"
git push origin feature/my-feature
```

Open a Pull Request on GitHub.

---

# 📜 License

Starship Shellcraft is released under the MIT License.

See [`LICENSE`](LICENSE) for details.

---

# ⭐ Star the Project

If Starship Shellcraft is useful to you, consider giving the project a ⭐ on GitHub.

**Starship Shellcraft**

> A beautiful, portable and intelligent Bash environment for Linux & WSL.