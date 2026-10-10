# BetterTTY agent guide

Guidelines for coding agents and contributors working on BetterTTY.

## Product identity

- Product: **BetterTTY**
- Version: **1.0.1-dev** (unreleased development; last stable baseline **1.0.0**)
- Codename: **Andromeda**
- Tagline: **A better way to SSH.**
- Secondary line: **Your servers. One dock.**
- Website: https://bettertty.dev
- Organization/publisher: DD-LAB
- Copyright: © 2026 Dalibor Klobučarić
- License: MIT

Do not introduce alternate product names, legacy names, or historical pre-BetterTTY versioning into user-facing text, filenames, packages, or documentation.

## Build identity

The CMake project is `BetterTTY`; the target is `bettertty`.

Key compile definitions:

```text
BETTERTTY_VERSION_STRING
BETTERTTY_CODENAME_STRING
BETTERTTY_MILESTONE_STRING
```

Platform outputs:

```text
Linux:   bettertty
Windows: BetterTTY.exe
macOS:   BetterTTY.app
```

## Config and secrets

The config filename is always:

```text
BetterTTY.json
```

Qt application identity is `DD-LAB / BetterTTY`.

Real BetterTTY configs and backups are sensitive because `plain-v1` values can contain human-readable passwords or private keys. Never commit, print, attach, or generate real secret values in tests or docs.

## Core safety rules

- Preserve known-host verification before authentication.
- Do not silently overwrite an invalid config.
- Keep config backup/restore safety behavior intact.
- Do not log secret values or file contents.
- Keep destructive file-manager operations explicitly confirmed.
- Do not replace libssh SFTP operations with shell-command parsing.
- Keep terminal and file-manager lifecycles independent.

## Documentation

For a user-facing behavior change, update the relevant current BetterTTY docs and, when appropriate:

```text
docs/CHANGELOG.md
docs/BUILD_AND_TEST_1.0.md
docs/TESTCASE_1.0.md
```

Do not add obsolete checkpoint documents to the repository.
