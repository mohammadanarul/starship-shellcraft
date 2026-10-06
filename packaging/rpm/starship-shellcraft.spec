Name:           starship-shellcraft
Version:        1.2.0
Release:        1%{?dist}
Summary:        Modern Bash environment powered by Starship
License:        MIT
BuildArch:      noarch
Requires:       bash
Requires:       curl
Requires:       git

%description
Starship Shellcraft provides a modern Bash environment with Starship,
themes, completion, autosuggestions, fuzzy search and smart directory navigation.

%install
mkdir -p %{buildroot}/usr/share/starship-shellcraft
cp -a lib themes VERSION shellcraft %{buildroot}/usr/share/starship-shellcraft/
chmod 0755 %{buildroot}/usr/share/starship-shellcraft/shellcraft
mkdir -p %{buildroot}/usr/bin
cat > %{buildroot}/usr/bin/starship-shellcraft <<'LAUNCHER'
#!/usr/bin/env bash
set -euo pipefail
SC_ROOT="/usr/share/starship-shellcraft"
source "$SC_ROOT/lib/common.sh"
source "$SC_ROOT/lib/detect.sh"
source "$SC_ROOT/lib/packages.sh"
source "$SC_ROOT/lib/theme.sh"
source "$SC_ROOT/lib/runtime.sh"
main "$@"
LAUNCHER
chmod 0755 %{buildroot}/usr/bin/starship-shellcraft
ln -s starship-shellcraft %{buildroot}/usr/bin/ssc

%files
/usr/bin/starship-shellcraft
/usr/bin/ssc
/usr/share/starship-shellcraft
