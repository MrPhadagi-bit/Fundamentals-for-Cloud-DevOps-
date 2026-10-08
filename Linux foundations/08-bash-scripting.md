# 08. Bash Scripting: Automate Everything

>  **By the end of this chapter you will be able to:**
> - Write, make executable, and run a Bash script
> - Use variables, conditions, and loops to add logic
> - Handle errors so failures don't go unnoticed
> - Automate a real deployment workflow

---

## Step 1 — Why Script?

Tired of repeating the same commands every time you set up a server, install dependencies, or deploy an app? A **Bash script** is just a file of commands that runs in order — turning 20 typed commands into one.

Use scripts for:

- Installing packages & dependencies
- Backing up files
- Deploying code
- Scheduled cron jobs
- Health checks

> Bash is your Linux automation superpower. DevOps without Bash is like a pilot without a checklist.

## Step 2 — Anatomy of a Script

```bash
#!/bin/bash

echo "Updating system..."
sudo apt update && sudo apt upgrade -y
echo "Done!"
```

Two things to notice:

1. **`#!/bin/bash`** — the **shebang**. Line 1 tells the system "interpret this file with Bash." Without it, the file might run with the wrong shell.
2. **`echo`** — prints text to the screen (your script's voice).

## Step 3 — Create → Make Executable → Run

```bash
# 1. Create the file
nano myscript.sh

# 2. Make it executable (Chapter 05!)
chmod +x myscript.sh

# 3. Run it
./myscript.sh
```

>  You **must** use `./myscript.sh`, not just `myscript.sh` — the current directory isn't in your `PATH` by default (a deliberate security measure).

## Step 4 — Variables

```bash
name="Nimesha"
echo "Hello, $name!"
```

- No spaces around `=` (`name = "x"` breaks!)
- Reference with `$name` or `${name}`
- Capture command output into a variable:

```bash
current_date=$(date +%F)
echo "Today is $current_date"
```

## Step 5 — Conditions

```bash
if [ -f /etc/passwd ]; then
  echo "User file exists."
else
  echo "File missing!"
fi
```

**Common test expressions:**

| Test | True when |
|---|---|
| `[ -f file ]` | file exists and is a regular file |
| `[ -d dir ]` | directory exists |
| `[ -z "$var" ]` | variable is empty |
| `[ "$a" = "$b" ]` | strings are equal (note spaces!) |
| `[ $? -eq 0 ]` | last command succeeded |

>  Spaces inside `[ ... ]` are **mandatory**: `[ -f x ]` works, `[-f x]` fails with "command not found".

## Step 6 — Loops

```bash
for file in *.log
do
  echo "Found log file: $file"
done
```

`*.log` expands to every matching filename in the directory. Loops shine for batch operations — compressing logs, renaming files, checking multiple hosts.

## Step 7 — Exit Codes and Error Handling

Every command returns an **exit code**: `0` = success, anything else = failure. Check it with `$?`:

```bash
tar -czf /backup/home.tar.gz /home
echo $?          # 0 = success
```

**Fail fast with `set -e`** — the moment anything fails, the script stops:

```bash
#!/bin/bash
set -e
sudo apt update
sudo apt install -y nginx     # if this fails, script exits here
echo "This line only runs if everything above worked"
```

**Handle a specific failure with `||`:**

```bash
#!/bin/bash
echo "Starting backup..."

tar -czf /backup/home.tar.gz /home || {
  echo "Backup failed!" >&2
  exit 1
}

echo "Backup complete."
```

`A || B` runs B only if A failed; `A && B` runs B only if A succeeded.

## Step 8 — Real-World Example: Deployment Script

```bash
#!/bin/bash
set -e

echo "Deploying Flask App..."

cd /home/ubuntu/myapp
git pull origin main

sudo systemctl restart flaskapp
echo "Deployment complete!"
```

**What it does:**
1. `set -e` — abort on any failure (don't restart a half-updated app!)
2. `cd` into the project
3. Pull the latest code
4. Restart the app service

>  Schedule it with `cron` (e.g., nightly auto-deploy), or trigger it from a CI/CD pipeline. That's DevOps in a nutshell.

## Step 9 — Pro Tips

- **Always** start with `#!/bin/bash`
- Use `set -e` so failures aren't silently ignored
- **Comment** with `#` — future-you will thank present-you
- Quote variables: `"$var"` prevents word-splitting surprises
- Never run destructive commands (`rm -rf`) without a guard:

```bash
if [ -z "$TARGET_DIR" ]; then
  echo "TARGET_DIR not set, refusing to delete." >&2
  exit 1
fi
rm -rf "$TARGET_DIR"
```

## Step 10 — A Complete Example: Backup with Checks

```bash
#!/bin/bash
set -e

BACKUP_DIR="/backup"
SOURCE="/home/ubuntu/myapp"
STAMP=$(date +%F_%H%M)
ARCHIVE="$BACKUP_DIR/app_$STAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "Backing up $SOURCE → $ARCHIVE"
tar -czf "$ARCHIVE" "$SOURCE" || { echo "Backup failed!" >&2; exit 1; }

echo "Backup complete: $ARCHIVE"
```

---

##  Common Pitfalls

| Mistake | Fix |
|---|---|
| `myscript.sh: Permission denied` | `chmod +x myscript.sh` |
| `name = "x"` (spaces around =) | `name="x"` |
| Script continues after a failure | `set -e` and/or `||` handlers |
| `[-f x]` errors | Spaces: `[ -f x ]` |
| `./script.sh: command not found` | You're not in the right directory, or use the full path |

---

##  Try It Yourself

1. Write `hello.sh` that prints your name and today's date.
2. Write a script that creates a directory `~/backups`, copies `/etc/hostname` into it, and prints the result with `ls -l`.
3. Add an `if` that warns when a file `important.txt` doesn't exist.
4. Write a loop that prints each `.md` file in the current directory.
5. Combine it all: a script that backs up a folder, fails loudly on error, and ends with `echo "Backup OK: <path>"`.

➡️ Finish with the [Scripting Lab](../exercises/08-scripting-lab.md), then review the [Cheatsheet](../cheatsheet.md). 🎉 You now know the Linux fundamentals every DevOps engineer uses daily.
