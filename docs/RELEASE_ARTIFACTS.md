# BetterTTY release artifacts

## BetterTTY 1.0.0 — Andromeda

Expected release outputs:

### Linux

```text
bettertty_1.0.0_<arch>.deb
```

Optional release staging tree:

```text
dist/linux-release/
```

### Windows

```text
BetterTTY-1.0.0-Windows-x86_64-portable.zip
```

The deployed folder must contain `BetterTTY.exe`, Qt runtime files, and required libssh/vcpkg runtime DLLs.

### macOS

```text
BetterTTY-1.0.0-macOS-x86_64.dmg
BetterTTY-1.0.0-macOS-x86_64-otool-report.txt
```

The application bundle is:

```text
BetterTTY.app
```

### Checksums

Generate SHA-256 checksum files with the platform checksum helpers before publishing release assets.

## Release hygiene

Artifacts must not contain:

- a real `BetterTTY.json`
- passwords or private keys
- personal host/session data
- development logs containing user data
- build-system caches or source `.git` metadata

See `RELEASE_CHECKLIST.md` and `RELEASE_PROCESS.md`.
