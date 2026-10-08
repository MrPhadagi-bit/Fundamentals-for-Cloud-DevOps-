# 03. Files and Directories: Create, Edit, Move, Delete

>  **By the end of this chapter you will be able to:**
> - Create files and directories (including nested trees in one command)
> - View file contents with `cat`, `less`, `head`, `tail` — and live-tail logs
> - Move, rename, and copy files like a professional
> - Delete files safely (and know exactly when `rm -rf` is acceptable)

---

## Step 1 — Why This Matters

In Linux, **almost everything is a file** — configs, logs, user data. Every task you'll do (set up a web server, write a script, debug a container) involves creating, editing, organizing, and deleting files. Master these operations and the rest of Linux becomes easy.

## Step 2 — Create Directories with `mkdir`

```bash
mkdir myproject
```

Creates a folder called `myproject` in the current location.

**Real-world use:** starting a new automation project:

```bash
mkdir ~/projects/docker-cleanup
cd ~/projects/docker-cleanup
```

**Create nested directories in one go** with `-p` (parents):

```bash
mkdir -p reports/2025/July
```

Without `-p`, this fails unless `reports/2025` already exists. With `-p`, every missing level is created.

>  The pattern `mkdir -p` also **succeeds silently** if the directory already exists — which makes it perfect for scripts.

## Step 3 — Create Files with `touch`

```bash
touch notes.txt
```

Creates an empty file. It also **updates the timestamp** of an existing file without changing content.

```bash
touch docker-compose.yml     # placeholder before you write content
touch file1.txt file2.txt    # create several at once
```

## Step 4 — Edit Files with `nano`

```bash
nano notes.txt
```

Nano is the friendliest terminal editor for beginners:

| Key | Action |
|---|---|
| Type | Insert text |
| `Ctrl + O` | Save (Write **O**ut) |
| `Enter` | Confirm filename |
| `Ctrl + X` | Exit |
| `Ctrl + W` | Search |
| `Ctrl + K` | Cut a line |
| `Ctrl + U` | Paste |

This is where you'll write Bash scripts and configuration files.

## Step 5 — View File Contents

| Command | Shows | Best for |
|---|---|---|
| `cat file.txt` | Entire file, dumped to screen | Small files |
| `less file.txt` | Scrollable, page-by-page view | Large files (quit with `q`) |
| `head file.txt` | First 10 lines | Quick peek |
| `tail file.txt` | Last 10 lines | Log endings |
| `tail -n 50 file.txt` | Last 50 lines | Longer endings |
| `tail -f /var/log/syslog` | **Live stream** — updates as written | Debugging! |

`tail -f` (follow) is a DevOps superpower: open a log in one terminal, trigger an action in another, and watch errors appear in real time. Exit with `Ctrl + C`.

## Step 6 — Move and Rename with `mv`

```bash
mv oldname.txt newname.txt        # rename
mv notes.txt ~/documents/         # move to another directory
mv config.yml /etc/nginx/nginx.conf   # move AND rename in one step
```

>  **Pitfall:** `mv` **overwrites** destination files without warning. There's no undo.

**Safety trick — never clobber files:**
```bash
mv -i notes.txt ~/documents/      # -i = ask before overwriting
```
Or enable it permanently by adding `alias mv='mv -i'` to `~/.bashrc`.

## Step 7 — Copy with `cp`

```bash
cp source.txt destination.txt     # copy a file
cp -r folder1 folder2             # copy a whole folder (-r = recursive)
cp -r folder1/. folder2/          # copy folder1's *contents* into folder2
```

**The golden DevOps habit — back up before editing:**
```bash
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
```
If your edit breaks the server, restore instantly:
```bash
sudo cp /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf
```

## Step 8 — Delete with `rm` (Carefully!)

```bash
rm file.txt            # delete a file (asks if aliased with -i)
rm -r myfolder/        # delete a folder and everything inside
rm -rf myfolder/       # -f = force, never ask
```

>  ** `rm -rf` permanently deletes. There is no trash, no undo.** One classic disaster is `rm -rf /home/user /tmp` (a stray space) — it deletes your entire home directory. Double-check every path.

**Safer habits:**
- `ls` the path first to confirm what you're deleting
- Use `rm -ri bigfolder/` for interactive confirmation on big deletes
- Prefer `mv` to a `~/trash/` folder when unsure

## Step 9 — Verify Everything with `ls`

After **every** create/move/delete, verify:

```bash
ls -l
```

Build this reflex now and you'll catch mistakes before they become incidents.

## Step 10 — Real-World Task: Full Workflow

```bash
# 1. Create a project directory
mkdir -p ~/devops/log-rotator
cd ~/devops/log-rotator

# 2. Create and edit a script
touch rotate.sh
nano rotate.sh          # add your commands

# 3. Back it up before making changes
cp rotate.sh rotate_backup.sh

# 4. Move the backup elsewhere
mkdir -p ~/backups
mv rotate_backup.sh ~/backups/

# 5. Inspect the backup is safe
ls -l ~/backups/

# 6. Clean up the working copy
rm rotate.sh
ls -l                   # confirm it's gone
```

---

##  Common Pitfalls

| Mistake | Fix |
|---|---|
| `cp folder1 folder2` fails on directories | Add `-r` for recursive copy |
| Overwrote a file with `mv`/`cp` | Use `-i` to be asked first |
| Ran `rm -rf` on the wrong path | `ls` the exact path first; there is no undo |
| Edited a config without a backup | Always `cp file file.bak` first |

---

##  Try It Yourself

1. Create `~/practice/docs` with one command (nested).
2. Inside it, create `readme.txt` and write two lines with nano.
3. View the file with `cat`, then only its first line using `head -n 1`.
4. Copy it to `readme_v2.txt`, then rename the copy to `archive.txt`.
5. Delete `archive.txt` — but `ls` first to confirm the name.

➡️ Continue to [Chapter 04: Users and Groups](../04-users-and-groups.md) — or practice with the [Files Lab](../exercises/03-files-lab.md).
