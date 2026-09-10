# BetterTTY Linux packaging assets

This directory contains Debian package maintainer scripts used by the BetterTTY Linux packaging workflow.

The current package flow:

- builds from the CMake Release tree
- installs `bettertty`, the desktop launcher, icons, license, and documentation under `/usr`
- generates a `.deb` with `dpkg-deb`
- uses distribution-provided Qt/libssh runtime packages

See `docs/LINUX_PACKAGING.md` and `docs/DEBIAN_PACKAGE_TUTORIAL.md`.
