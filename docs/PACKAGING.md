# BetterTTY packaging

BetterTTY 1.0.0 has helper workflows for Linux, Windows, and macOS.

## Naming

```text
Linux executable:    bettertty
Windows executable:  BetterTTY.exe
macOS application:   BetterTTY.app
Config file:          BetterTTY.json
```

Release artifacts:

```text
bettertty_1.0.0_<arch>.deb
BetterTTY-1.0.0-Windows-x86_64-portable.zip
BetterTTY-1.0.0-macOS-x86_64.dmg
```

## Linux

```bash
./scripts/linux-build-release.sh
./scripts/linux-deploy-release.sh
./scripts/linux-package-deb.sh
```

## Windows

After a supported MSVC/Qt build:

```bat
scripts\windows-deploy-release.bat
scripts\windows-package-portable.bat
```

## macOS

```bash
./scripts/macos-build-release.sh
./scripts/macos-deploy-release.sh
```

## Microsoft Store

Microsoft Store packaging is planned for a maintenance release after the initial BetterTTY 1.0.0 release. Store identity/publisher values must be taken from the Microsoft Partner Center listing rather than guessed in source. The Store build should use Store-managed updates.

## Security

Never package a real `BetterTTY.json`, backups, private keys, passwords, or user diagnostic logs.
