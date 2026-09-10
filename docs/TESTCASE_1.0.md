# BetterTTY 1.0.0 validation checklist

## Identity

- [ ] Window title and About dialog say BetterTTY.
- [ ] About shows version 1.0.0 and codename Andromeda.
- [ ] BetterTTY icon appears in the window and packaged application.
- [ ] Config file is named `BetterTTY.json`.
- [ ] Config/log paths include the BetterTTY application identity.
- [ ] No obsolete product name appears in UI, packages, or active documentation.

## Sessions and authentication

- [ ] Create and save a password session after successful authentication.
- [ ] Create and save a private-key session after successful authentication.
- [ ] Edit and delete saved sessions.
- [ ] Duplicate-session warning behaves as expected.
- [ ] Known-host trust flow works for a new host.
- [ ] Changed host key is not silently trusted.

## Terminal

- [ ] Double-click opens xterm.js terminal.
- [ ] PTY resize follows terminal size.
- [ ] `htop`, `nano`, `vim`, `top`, and `clear` render correctly.
- [ ] Ctrl+C reaches the remote shell.
- [ ] Toolbar/right-click/Ctrl+Shift+V paste works.
- [ ] Multiline paste preserves expected line breaks.
- [ ] Disconnect/reconnect lifecycle works.

## SFTP file manager

- [ ] File manager opens for a saved session.
- [ ] Local and remote navigation works.
- [ ] Upload and download queue correctly.
- [ ] Recursive folder scan creates expected queue items.
- [ ] Overwrite/skip decisions work.
- [ ] Retry selected works for eligible queue states.
- [ ] Local and remote delete confirmations appear only when the queue reaches the destructive item.
- [ ] SFTP transfer traffic increments Session Traffic counters.

## Config safety

- [ ] Export config works.
- [ ] Import preview works.
- [ ] Backup creation/rotation works.
- [ ] Restore latest backup works.
- [ ] Invalid JSON triggers recovery behavior instead of silent overwrite.
- [ ] Diagnostic logs do not contain secret values or file contents.

## Exit safety

- [ ] Closing with active terminal/SFTP tabs asks for confirmation.
- [ ] Closing with pending/running transfer work asks for confirmation.
