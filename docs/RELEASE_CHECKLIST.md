# BetterTTY release checklist

## Identity

- [ ] Product name is BetterTTY everywhere user-facing.
- [ ] Version and codename are correct.
- [ ] Website is `https://bettertty.dev`.
- [ ] Copyright is © 2026 Dalibor Klobučarić.
- [ ] License is MIT.
- [ ] Application/publisher identity is DD-LAB.
- [ ] Config filename is `BetterTTY.json`.
- [ ] BetterTTY icon is present in all platform packages.

## Source hygiene

- [ ] No obsolete product-name tokens remain.
- [ ] No obsolete pre-BetterTTY release history remains in active docs.
- [ ] No build directories or binaries are committed.
- [ ] No real config, password, private key, log, or personal host data is committed.

## Runtime

- [ ] Session CRUD works.
- [ ] Password auth works.
- [ ] Private-key auth works.
- [ ] Known-host verification works.
- [ ] Terminal rendering/paste/resize/lifecycle work.
- [ ] SFTP browsing and transfer queue work.
- [ ] Config backup/import/export/recovery work.
- [ ] Logging privacy rules hold.
- [ ] Exit safety works.

## Packaging

- [ ] Linux release build passes.
- [ ] Debian package metadata is correct.
- [ ] Windows `BetterTTY.exe` metadata is correct.
- [ ] Windows portable ZIP launches on a clean test system.
- [ ] macOS `BetterTTY.app` launches on the intended test system.
- [ ] macOS dependency audit is clean.
- [ ] SHA-256 checksums are generated.

## BetterTTY 1.0.2 release gate

- [ ] Windows **1.0.2** build, About and PE properties match.
- [ ] `.deb` reports package version `1.0.2`, installs, launches and removes on tested distro.
- [ ] macOS `.app` and `.dmg` report 1.0.2, launch on actual target architecture, dependency audit clean.
- [ ] Ctrl+Tab verified, Ctrl+Shift+Tab is not listed as supported.
- [ ] All three Copy behaviors and three Paste modes tested with Settings persistence.
- [ ] All screenshots reviewed/redacted and added only when available.
- [ ] `plain-v1` human-readable credentials warning present in README and release notes.
- [ ] Source and binaries contain NO real `BetterTTY.json`, backup files, passwords, private keys or logs.
- [ ] `docs/RELEASE_STATUS_1.0.2.md` and `docs/QA_MATRIX_1.0.2.md` filled with tester evidence.
- [ ] Final published tag, checksum files and install instructions use `1.0.2`.
