# 01. The Filesystem: Everything Is a File

>  **By the end of this chapter you will be able to:**
> - Explain how the Linux filesystem is organized (and why there's no `C:\` drive)
> - Navigate to any directory using absolute and relative paths
> - Know what's inside the 10 most important system directories
> - Find configuration files and logs on a real server

---

## Step 1 — Understand the Core Idea: Everything Is a File

In Linux, **everything is treated as a file**:

- Your documents → files
- A hard drive → a file (`/dev/sda`)
- A running process → exposed as files in `/proc/`
- Even your screen and keyboard → device files

This design makes Linux incredibly consistent: the same tools that read a text file can (in principle) read information about hardware or processes.

## Step 2 — One Tree, One Root

The Linux filesystem is a **single hierarchical tree** that starts at the root directory `/`.

```
/
├── home/
│   └── nimesha/        ← your personal folder
├── etc/                ← configuration files
├── var/
│   └── log/            ← logs
├── usr/                ← installed software
├── bin/                ← essential commands
└── ...
```

> **Key difference from Windows:** Windows splits drives into `C:\`, `D:\`, etc. Linux has **one unified structure** — every disk, partition, and device is *mounted* somewhere inside this single tree under `/`.

Think of it like a family tree:
- `/` is the root — the top-most parent
- Every other directory is a child or descendant of `/`

## Step 3 — Learn the Key Directories (and When You'll Actually Use Them)

| Directory | What It Contains | Real Use Cases |
|-----------|------------------|----------------|
| `/` | Root directory. Everything starts here. | The base of the entire system. |
| `/home/` | User folders (`/home/nimesha`) | Store personal files, scripts, downloads. |
| `/etc/` | **System-wide configuration files** | Configure Nginx, SSH, cron, firewall… |
| `/var/` | Variable data: logs, mail, caches | Monitor logs (`/var/log/`), troubleshoot crashes. |
| `/usr/` | User-installed software & resources | Holds app binaries and libraries. |
| `/bin/` & `/sbin/` | Essential system binaries | `ls`, `cp`, `shutdown` live here. |
| `/tmp/` | Temporary files (cleared on reboot) | Scratch space for archives, quick tests. |
| `/opt/` | Optional third-party software | Anaconda, custom server software. |
| `/dev/` | Device files for hardware | Disks, USB, terminals. |
| `/proc/` & `/sys/` | Virtual files exposing kernel/process info | System monitoring & diagnostics. |

 **Memory trick:** `/etc/` = "**e**very **t**hing **c**onfigured", `/var/` = "**var**iable data (logs grow)".

## Step 4 — Navigate Like a Pro

Three commands cover 90% of navigation:

```bash
pwd          # Where am I? (Print Working Directory)
ls -l        # What's here, in detail?
cd /etc      # Go somewhere (Change Directory)
```

### Path types — the #1 beginner confusion

**Absolute path** — starts from `/`, works from anywhere:
```bash
cd /var/log/nginx
```

**Relative path** — starts from where you *currently* are:
```bash
cd logs          # a folder called 'logs' inside the current directory
cd ..            # up one level
cd ../..         # up two levels
cd ~/projects    # ~ is a shortcut for your home directory
cd               # no argument = home directory
```

>  **Pitfall:** `cd /logs` (absolute) is **not** the same as `cd logs` (relative). One looks for `/logs` at the root — which usually doesn't exist.

### Tab completion — use it always

```
cd /var/lo<TAB>     →  cd /var/log/
```

Pressing **Tab** auto-completes paths. Press it **twice** to see all options when ambiguous. It prevents typos and is dramatically faster than typing full paths.

## Step 5 — Real-World Example: Deploying Nginx

Here's how the directory knowledge pays off on a real task — deploying a web server:

**1. Find and edit the configuration:**
```bash
cd /etc/nginx/
ls -l
sudo nano nginx.conf
```

**2. Serve your website files from the web root:**
```bash
cd /var/www/html/
```

**3. Watch live traffic and errors:**
```bash
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

Notice the pattern: **config → `/etc/`, content → `/var/www/`, logs → `/var/log/`**. This holds true for almost every service you'll ever manage.

## Step 6 — Best Practices for Beginners

1. **Don't delete or modify** anything in `/etc` or `/bin` unless you know what it does.
2. **Keep personal work** in `/home/yourname/` — never in system directories.
3. **Create a projects folder** to separate each task:
   ```bash
   mkdir -p ~/projects/log-rotator
   ```
4. **Back up configs before editing:**
   ```bash
   sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
   ```
5. **Scripts break on wrong paths.** A single missing `/` can destroy automation:
   ```bash
   cp /etc/nginx/nginx.conf /home/nimesha/backup/   # correct
   ```

---

##  Try It Yourself

1. Run `pwd` — where are you right now?
2. Go to `/etc`, list its contents with `ls -l`, and find one file you recognize.
3. Return home with `cd`, then reach `/var/log` using **one** absolute-path command.
4. From `/var/log`, go up one level, then into `www` (if it exists) using relative paths.
5. Bonus: what does `ls /` show? Count how many directories you can now name.

 Ready for more? Do the [Filesystem Lab](../exercises/01-filesystem-lab.md), or continue to [Chapter 02: The Terminal](../02-the-terminal.md).
