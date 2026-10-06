# Packaging

Native release artifacts:

| Family | Artifact | Builder |
|---|---|---|
| Debian / Ubuntu | `.deb` | `packaging/deb/build-deb.sh` |
| Fedora / RHEL | `.rpm` | `packaging/rpm/build-rpm.sh` |
| openSUSE / SLES | `.rpm` | RPM spec |
| Arch / Manjaro | `.pkg.tar.zst` | `packaging/arch/PKGBUILD` |
| Generic Linux | `.tar.gz` | `packaging/tarball/build-tarball.sh` |

GitHub Actions builds all release artifacts automatically when a `v*` tag is pushed.
