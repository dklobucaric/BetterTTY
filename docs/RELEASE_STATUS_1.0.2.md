# BetterTTY 1.0.2 — Release verification status

**Artifact status: source package prepared; Windows 1.0.2, Linux and macOS builds have NOT been run in this analysis environment.** The source package is intended to be reviewed, built and validated by the maintainer before publication as a stable release. The final GitHub `v1.0.2` tag and release assets should only be created after the platform checklist passes.

| Area | Evidence | State |
| --- | --- | --- |
| FR-001/FR-003/FR-004 paste behavior | User reported Windows tests working; Hermes reproduced all 10 coded lines | Preliminary Windows PASS on prior dev sources |
| Light/Dark UI and X contrast | User reported both themes working | Preliminary Windows PASS on prior dev sources |
| FR-009 Copy on Selection | User pasted selected multiline session output after closing the tab | Preliminary Windows PASS on prior dev sources |
| FR-010 Ctrl+Tab | User confirmed works on Windows | Preliminary Windows PASS on prior dev sources |
| Ctrl+Shift+Tab | User reported not working; intentionally removed from 1.0.2 advertised behavior | Not supported |
| Final 1.0.2 source compiled and launched on Windows | No new final-archive build log yet | PENDING |
| Windows portable ZIP on clean machine | Not yet verified | PENDING |
| Linux CMake + libssh + Qt WebEngine | Not yet verified on 1.0.2 | PENDING |
| Debian .deb metadata + install/remove | Not yet verified on 1.0.2 | PENDING |
| macOS native Qt6 build, .app startup | Not yet verified on 1.0.2 | PENDING |
| macOS .dmg bundling, dependent dylib audit, Gatekeeper | Not yet verified on 1.0.2 | PENDING |
| SSH host-key changed/unknown keys, credentials and import/export | Requires fresh manual regression | PENDING |
| SFTP overwrite/interruption/cancel, queue, backup safety | Requires fresh manual regression | PENDING |

**Do not announce macOS Gatekeeper/notarization support:** the existing script can produce an ad-hoc signed or unsigned DMG, not an automatically Apple Developer-ID notarized artifact.

This file is the release gate. Record dated OS details, Qt/libssh versions, SHA256, results and tester confirmation before tagging.
