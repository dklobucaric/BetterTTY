# BetterTTY 1.0 test matrix

Use this matrix for broad cross-platform validation. The focused release checklist is `TESTCASE_1.0.md`.

| Area | Linux | Windows | macOS |
|---|---|---|---|
| Application launches with BetterTTY icon/title | [ ] | [ ] | [ ] |
| About shows 1.0.0 / Andromeda | [ ] | [ ] | [ ] |
| Config path resolves under DD-LAB / BetterTTY | [ ] | [ ] | [ ] |
| Create/edit/delete session | [ ] | [ ] | [ ] |
| Password authentication | [ ] | [ ] | [ ] |
| Private-key authentication | [ ] | [ ] | [ ] |
| Unknown-host verification | [ ] | [ ] | [ ] |
| Changed-host protection | [ ] | [ ] | [ ] |
| xterm.js terminal opens | [ ] | [ ] | [ ] |
| PTY resize | [ ] | [ ] | [ ] |
| Ctrl+C remote interrupt | [ ] | [ ] | [ ] |
| Single-line paste | [ ] | [ ] | [ ] |
| Multiline paste | [ ] | [ ] | [ ] |
| SFTP remote browsing | [ ] | [ ] | [ ] |
| File upload | [ ] | [ ] | [ ] |
| File download | [ ] | [ ] | [ ] |
| Recursive folder queueing | [ ] | [ ] | [ ] |
| Overwrite / skip decisions | [ ] | [ ] | [ ] |
| Retry selected | [ ] | [ ] | [ ] |
| Local delete confirmation | [ ] | [ ] | [ ] |
| Remote delete confirmation | [ ] | [ ] | [ ] |
| SSH Session Traffic | [ ] | [ ] | [ ] |
| SFTP Session Traffic | [ ] | [ ] | [ ] |
| Config export/import | [ ] | [ ] | [ ] |
| Config backup/restore | [ ] | [ ] | [ ] |
| Corrupt-config recovery | [ ] | [ ] | [ ] |
| Diagnostic logging privacy | [ ] | [ ] | [ ] |
| Exit safety with active tabs/queue | [ ] | [ ] | [ ] |
| Release packaging launches | [ ] | [ ] | [ ] |

## Identity regression

Search the source/release tree before publishing:

```bash
grep -RIn -E 'obsolete-product-token' .
```

There should be no previous product branding or pre-BetterTTY release history in active source/docs.
