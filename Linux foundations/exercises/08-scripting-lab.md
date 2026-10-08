# 🏋️ Lab 08 — Bash Scripting

**Prereqs:** [Chapter 08](../08-bash-scripting.md) · **Time:** ~30 min

## Objective
Write three progressively more advanced scripts, ending with a real-world backup tool.

## Tasks

### Script 1 — warmup.sh
- Shebang + `set -e`.
- Print: your username, the hostname, and today's date (use variables and `$(date)`).

### Script 2 — watchdog.sh
- Accept a file path in a variable (e.g., `TARGET=/etc/hostname`).
- If the file exists → print `OK: <path> exists`.
- If not → print `MISSING: <path>` to **stderr** and exit with code 1.

### Script 3 — backup.sh (the real deal)
Requirements:
- Variables: `SOURCE` (a folder, default `/etc/hostname` is fine), `DEST_DIR=~/backups`.
- Create `DEST_DIR` if missing (`mkdir -p`).
- Archive name includes a timestamp: `backup_$(date +%F_%H%M).tar.gz`.
- Compress with `tar -czf`, with an `||` error handler.
- On success, print `Backup OK: <full path>` and list the destination directory.

### Run & verify
- `chmod +x` all three, run them, and check exit codes with `echo $?`.
- Deliberately break Script 3 (point SOURCE at a nonexistent path) and confirm the error handler fires and the exit code is 1.
- Make watchdog.sh check multiple files with a `for` loop.

## ✅ Check Yourself
- Why the shebang? Why `set -e`?
- What's the difference between `exit 0` and `exit 1`?
- Why quote variables like `"$SOURCE"`?

## Solutions
<details><summary>Click to reveal</summary>

```bash
# Script 1 — warmup.sh
#!/bin/bash
set -e
user=$(whoami)
host=$(hostname)
today=$(date +%F)
echo "User: $user | Host: $host | Date: $today"

# Script 2 — watchdog.sh
#!/bin/bash
set -e
TARGET="${1:-/etc/hostname}"
if [ -f "$TARGET" ]; then
  echo "OK: $TARGET exists"
else
  echo "MISSING: $TARGET" >&2
  exit 1
fi

# Script 3 — backup.sh
#!/bin/bash
set -e
SOURCE="/etc/hostname"
DEST_DIR="$HOME/backups"
STAMP=$(date +%F_%H%M)
ARCHIVE="$DEST_DIR/backup_$STAMP.tar.gz"

mkdir -p "$DESTRICT_DIR" 2>/dev/null || true   # careful: no typos!
mkdir -p "$DEST_DIR"

tar -czf "$ARCHIVE" "$SOURCE" || {
  echo "Backup failed!" >&2
  exit 1
}
echo "Backup OK: $ARCHIVE"
ls -l "$DEST_DIR"

# Multi-file watchdog
for f in /etc/hostname /etc/passwd /nonexistent; do
  ./watchdog.sh "$f" || true
done
```

> 🎓 Did you spot the intentional `DESTRICT_DIR` typo in the solution? That's why we test scripts — and why `set -e` exists. Fix it to `$DEST_DIR` and it runs clean.
</details>
