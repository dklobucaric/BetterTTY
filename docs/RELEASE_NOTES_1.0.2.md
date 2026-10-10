# BetterTTY 1.0.2 — Andromeda

**Source version:** 1.0.2 · **Code name:** Andromeda · **Owner:** DD-LAB · **License:** MIT.

This source milestone bundles maintenance and usability features developed in the unpublished `1.0.1-dev` series. **It is not yet a claim of a signed/notarized or independently qualified Windows/Linux/macOS binary.** Check [release status](RELEASE_STATUS_1.0.2.md) before distributing packages.

## Features and changes

- **Terminal:** xterm.js bundled offline, interactive SSH, PTY resize, tab management; **Ctrl+Tab** cycles forward, including from an active terminal.
- **Paste:** Automatic (negotiated Bracketed Paste), Legacy and Slow Paste; no automatically added trailing Enter; terminal Copy/Paste context menu uses one routing path.
- **Clipboard:** Copy on Selection **enabled by default**; can be disabled independently; right-click Copy and Ctrl+Shift+C still work.
- **Settings:** configurable paste notifications **disabled by default**; Light and Dark themes only with Light default; improved descriptive text, close-X and checkbox contrast.
- **About/Welcome:** 1.0.2 release identity, build ID and feature summary.
- **SSH sessions:** saved grouped profiles, password/key auth, pre-auth SSH host key verification, test connect and fallback shell.
- **SFTP:** two-pane local/remote browser, queued upload/download, conservative recursive folder transfers, queue retries and confirmation-driven deletes.
- **Config:** JSON import/export, backup/restore and corruption recovery; traffic diagnostics and opt-in metadata logs.

## Security and important limitations

**By design** the stored credentials/private-key contents under `BetterTTY.json` use `secrets.mode = plain-v1` and are **human-readable**. There is NO master password or encrypted secret vault. This includes backups and exported configs. Protect all of them with OS permissions and never post real copies on GitHub.

Remote SFTP overwrites are **not atomic**; interrupted uploads can damage an existing target. No resume, parallel transfer, recursive delete of nonempty folders, synchronization, or functional Multi-Exec.

## Platform verification

- **Windows:** previous dev builds have been compiled and manually exercised by the project owner (including Hermes multiline and Auto Copy); final 1.0.2 build/package still to be checked.
- **Linux:** 1.0.2 native GUI, `.deb` dependency and package install tests pending.
- **macOS:** 1.0.2 native GUI, `.app` and `.dmg` dependency/signing/Gatekeeper tests pending.

See [the test matrix](QA_MATRIX_1.0.2.md) and [full README](../README.md).
