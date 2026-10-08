# 🏋️ Lab 01 — The Filesystem

**Prereqs:** [Chapter 01](../01-the-filesystem.md) · **Time:** ~15 min

## Objective
Navigate the Linux filesystem confidently using absolute and relative paths.

## Tasks

1. **Orientation**
   - Run `pwd`. Note your current directory.
   - Run `ls /` and list all top-level directories you see.

2. **Absolute navigation**
   - Go to `/etc` with a single command.
   - List its contents: `ls -l`. Find `passwd` and `hostname`.

3. **Relative navigation**
   - From `/etc`, go up one level. Where are you?
   - Now go into `var`, then `log`, using relative paths only.

4. **Home sweet home**
   - Return home with `cd` (no arguments). Verify with `pwd`.
   - Create a practice area: `mkdir -p ~/labs/ch01`.
   - Navigate into it using `~` and Tab completion.

5. **Path decoding**
   For each path, write one sentence explaining what it points to:
   - `/var/log/nginx/error.log`
   - `~/projects/app/config.yml`
   - `./backup.tar.gz`

## ✅ Check Yourself
- Can you reach `/var/log` from anywhere with one command?
- Do you know the difference between `cd logs` and `cd /logs`?
- What lives in `/etc`? In `/var`?

## Solutions
<details><summary>Click to reveal</summary>

```bash
# 1
pwd
ls /

# 2
cd /etc
ls -l          # look for passwd, hostname

# 3
cd ..          # back to /
cd var
cd log         # now in /var/log

# 4
cd
mkdir -p ~/labs/ch01
cd ~/labs/ch01 && pwd

# 5
# - The nginx web server's error log file
# - A config file in your personal projects folder
# - A file in the CURRENT directory
```
</details>
