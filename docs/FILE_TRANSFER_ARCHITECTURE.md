# BetterTTY file transfer architecture

BetterTTY uses libssh SFTP APIs for remote file operations. The file manager is deliberately separated from terminal shell-command parsing so file transfer behavior stays predictable and platform-independent.

## Goals

- one saved SSH session can open either a terminal or a file manager
- local and remote files are shown side by side
- transfers are explicit and queue-first
- overwrite/delete decisions are visible to the user
- transfer failures do not silently replace existing files
- destructive operations remain conservative
- diagnostic logging records metadata, never file contents or secret values

## Session/authentication reuse

The SFTP workflow loads the same saved session profile used by SSH terminal connections:

```text
host
port
username
auth type
secret reference
known-host trust data
```

Host verification is performed before SFTP authentication. BetterTTY does not bypass the SSH trust chain for file-manager connections.

## Two-panel model

The file manager has two independent views:

```text
Local filesystem  <->  Remote SFTP filesystem
```

Local browsing uses Qt filesystem APIs. Remote browsing uses libssh SFTP operations.

## Queue model

Transfers are represented as queue items and run sequentially. Current queue item types include:

- upload file
- download file
- create destination directory as part of recursive transfer expansion
- local delete
- remote delete

Folder upload/download is implemented by scanning a selected folder and expanding supported contents into ordinary queue items. Symlinks and unsupported special files are skipped during recursive folder transfer.

Sequential execution is intentional in BetterTTY 1.0.0. It keeps overwrite prompts, cancellation, progress reporting, and destructive-operation confirmations easier to reason about.

## Overwrite behavior

When the destination already exists, the queue supports:

- Overwrite
- Skip
- Overwrite all
- Skip all
- Cancel queue

Where metadata is available, overwrite prompts show existing/incoming size and modified time.

Downloads use a safe temporary target so cancelling or failing a transfer does not replace the existing destination file with a partial download.

## Delete behavior

BetterTTY can queue deletion of supported local or remote entries:

- regular files
- symlinks
- empty directories

Recursive deletion of non-empty directories is intentionally not implemented in 1.0.0.

Destructive confirmation is shown when execution reaches the delete item. BetterTTY does not present queued delete as a recycle-bin operation.

## Retry

Finished queue items in eligible states can be returned to `Pending` with **Retry selected** and then executed again.

Typical retryable states:

```text
Done
Failed
Cancelled
Skipped
```

The normal overwrite/skip logic still applies when a retried item encounters an existing target.

## Progress and cancellation

Transfers report:

- bytes transferred
- total size when known
- percentage when known
- elapsed time
- transfer speed
- final result state

Cancellation stops the active transfer and leaves remaining queue items under user control.

## Session traffic integration

SSH terminal channel traffic and SFTP upload/download bytes contribute to the BetterTTY Session Traffic widget. Directory listing, mkdir, and delete operations are not treated as bulk transfer traffic.

## Logging

When diagnostic logging is enabled, file-manager logs may include:

- operation type
- local/remote path metadata
- byte counts
- elapsed time
- overwrite/skip decisions
- queue state transitions
- errors

Logs must not include passwords, private-key contents, file contents, clipboard contents, terminal input/output, or complete `BetterTTY.json` content.

## Current limits

BetterTTY 1.0.0 does not yet implement:

- sync/mirror
- partial-transfer resume
- parallel transfers
- recursive non-empty-directory delete
- rename
- chmod/chown
- permission/timestamp preservation
- symlink following during recursive folder transfer

These are future enhancements and should not be added by weakening existing transfer or trust-chain safety behavior.
