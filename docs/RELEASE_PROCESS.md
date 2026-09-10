# BetterTTY release process

## Versioning

BetterTTY uses semantic-style application versions:

```text
1.0.0
1.0.1
1.0.2
```

The first release is **1.0.0 — Andromeda**.

## Before a release

1. Update `BETTERTTY_VERSION_STRING` and CMake project version.
2. Update release notes and changelog.
3. Run `docs/TESTCASE_1.0.md` or the corresponding release test case.
4. Build clean Linux, Windows, and macOS artifacts.
5. Verify application identity, icon, config path, and package names.
6. Run checksum helpers.
7. Confirm no real `BetterTTY.json`, passwords, private keys, logs, or machine-specific secrets are included.
8. Confirm active documentation contains only BetterTTY branding.

## Release naming

Expected 1.0.0 artifacts:

```text
bettertty_1.0.0_<arch>.deb
BetterTTY-1.0.0-Windows-x86_64-portable.zip
BetterTTY-1.0.0-macOS-x86_64.dmg
SHA256SUMS
```

## Microsoft Store

Store packaging will use the Store-assigned package identity when the listing is created. The desktop application identity remains BetterTTY / DD-LAB. Store builds should receive updates through Microsoft Store rather than replacing themselves with the standalone installer/update path.

## Security gate

Release artifacts must never contain real configs or secrets. Diagnostic logs must not contain passwords, private-key contents, terminal input/output, clipboard content, or file contents.
