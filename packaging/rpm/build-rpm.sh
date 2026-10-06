#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VERSION="$(cat "$ROOT/VERSION")"
NAME="starship-shellcraft"
ARCH="noarch"

TOP="$(mktemp -d)"
trap 'rm -rf "$TOP"' EXIT

mkdir -p "$TOP"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

STAGE="$TOP/${NAME}-${VERSION}"
mkdir -p "$STAGE"

cp -a \
  "$ROOT/lib" \
  "$ROOT/themes" \
  "$ROOT/VERSION" \
  "$ROOT/shellcraft" \
  "$STAGE/"

tar -C "$TOP" \
  -czf "$TOP/SOURCES/${NAME}-${VERSION}.tar.gz" \
  "${NAME}-${VERSION}"

cat > "$TOP/SPECS/${NAME}.spec" <<EOF
Name:           $NAME
Version:        $VERSION
Release:        1%{?dist}
Summary:        Modern Bash environment powered by Starship
License:        MIT
BuildArch:      noarch
Source0:        %{name}-%{version}.tar.gz

Requires:       bash
Requires:       curl
Requires:       git

%description
Starship Shellcraft provides a modern Bash environment with Starship,
themes, completion, autosuggestions, fuzzy search and smart directory navigation.

%prep
%setup -q

%install
mkdir -p %{buildroot}/usr/share/$NAME

cp -a lib themes VERSION shellcraft \
  %{buildroot}/usr/share/$NAME/

chmod 0755 %{buildroot}/usr/share/$NAME/shellcraft

mkdir -p %{buildroot}/usr/bin

cat > %{buildroot}/usr/bin/starship-shellcraft <<'LAUNCHER'
#!/usr/bin/env bash
set -euo pipefail

SC_ROOT="/usr/share/starship-shellcraft"

source "\$SC_ROOT/lib/common.sh"
source "\$SC_ROOT/lib/detect.sh"
source "\$SC_ROOT/lib/packages.sh"
source "\$SC_ROOT/lib/theme.sh"
source "\$SC_ROOT/lib/runtime.sh"

main "\$@"
LAUNCHER

chmod 0755 %{buildroot}/usr/bin/starship-shellcraft

ln -s starship-shellcraft %{buildroot}/usr/bin/ssc

%files

/usr/bin/starship-shellcraft
/usr/bin/ssc
/usr/share/$NAME

%changelog
* Thu Jan 01 2026 Starship Shellcraft contributors - $VERSION-1
- Native RPM release
EOF

if command -v rpmbuild >/dev/null 2>&1; then

    rpmbuild \
      --define "_topdir $TOP" \
      -bb "$TOP/SPECS/${NAME}.spec"

    cp "$TOP"/RPMS/*/*.rpm "$ROOT/"

    echo "Built RPM successfully."

else

    cp "$TOP/SPECS/${NAME}.spec" \
      "$ROOT/packaging/rpm/starship-shellcraft.spec"

    echo "rpmbuild not installed."
    echo "RPM spec generated."

fi