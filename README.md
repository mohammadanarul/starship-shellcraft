# Starship Shellcraft

**Starship Shellcraft — A beautiful, portable and intelligent Bash environment for Linux & WSL.**

Version: **v1.2.0**

Starship Shellcraft turns a normal Bash terminal into a modern shell environment using Starship, ble.sh, bash-completion, fzf and zoxide.

## Current package support

| Package manager | Status |
|---|---|
| **APT (Debian/Ubuntu)** | ✅ Supported — `.deb` |
| **Pacman (Arch/Manjaro/EndeavourOS)** | ✅ Supported — `.pkg.tar.zst` |
| **DNF (Fedora/RHEL family)** | ✅ Supported — `.rpm` |
| **Zypper (openSUSE/SLES)** | ✅ Supported — `.rpm` |

> Shellcraft automatically detects the Linux distribution and uses the appropriate package manager.

## Install

### One-line installer

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/starship-shellcraft/main/install.sh | bash
```

### Native packages

Download the matching artifact from the GitHub Release:

```text
Debian / Ubuntu       → .deb
Fedora / RHEL         → .rpm
openSUSE / SLES       → .rpm
Arch / Manjaro        → .pkg.tar.zst
Any Linux             → .tar.gz
```

Debian/Ubuntu example:

```bash
sudo dpkg -i starship-shellcraft_1.0.0_all.deb
```

Then configure your shell:

```bash
starship-shellcraft install
```

The package installs the CLI; `install` configures the current user's Bash environment.

## Commands

```text
starship-shellcraft
ssc
```

```bash
ssc install
ssc info
ssc doctor
ssc repair
ssc update
ssc version
ssc help
ssc uninstall
```

## Theme manager

Change themes without reinstalling:

```bash
ssc theme list
ssc theme current
ssc theme set tokyo-night
ssc theme set nord
ssc theme set dracula
ssc theme set gruvbox
ssc theme set catppuccin-mocha
ssc theme set minimal
ssc theme preview nord
ssc theme reset
```

Themes are stored under:

```text
~/.config/shellcraft/themes/
```

You can add your own theme later by placing a Starship TOML file there and running:

```bash
ssc theme set my-theme
```

## What it configures

- ⭐ Starship prompt
- 🧠 ble.sh autosuggestions + syntax highlighting
- 📦 bash-completion
- 🔎 fzf history/file search
- 📁 zoxide smart directory navigation
- 🐧 Debian/Ubuntu APT dependency management
- 🪟 WSL-aware default startup directory
- 🔧 doctor / repair commands
- 🎨 switchable Starship themes
- 🛡️ safe managed `.bashrc` block — existing user configuration outside the block is preserved

## WSL behavior

On WSL, Shellcraft detects the Windows username dynamically and uses:

```text
/mnt/c/Users/<detected-user>
```

when that directory exists.

On native Linux, it uses the normal:

```text
$HOME
```

No Windows username or path is hard-coded.

## Nerd Font

For the best icons, install **FiraCode Nerd Font** on Windows and select it in Windows Terminal.

Shellcraft does not attempt to install Windows fonts from inside Linux/WSL.

## Native package artifacts

Each tagged GitHub release is built automatically:

```text
starship-shellcraft_1.2.0_all.deb
starship-shellcraft-1.2.0-1.noarch.rpm
starship-shellcraft-1.2.0-1-any.pkg.tar.zst
starship-shellcraft-1.2.0.tar.gz
```

The `.rpm` artifact is usable by Fedora/RHEL-family systems and openSUSE/SLES.
The Arch artifact is built from the included `PKGBUILD`.

## Versioning

Releases use semantic versions:

```text
v1.0.0
v1.1.0
v2.0.0
```

## Roadmap

- [x] APT / Debian / Ubuntu
- [x] Pacman / Arch family
- [x] DNF / Fedora / RHEL family
- [x] Zypper / openSUSE / SLES
- [x] Automatic package-manager detection
- [x] Versioned CLI
- [x] `.deb` package
- [x] `ssc` shortcut
- [x] Theme manager
- [x] WSL detection
- [x] Doctor / repair
- [ ] Automatic self-update

## License

MIT
