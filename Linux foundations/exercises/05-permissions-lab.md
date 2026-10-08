# 🏋️ Lab 05 — Permissions and Ownership

**Prereqs:** [Chapter 05](../05-permissions-and-ownership.md) · **Time:** ~20 min · **Needs:** sudo access

## Objective
Read, set, and repair file permissions — including the classic 403 fix.

## Tasks

1. **Permission reading**
   - Run `ls -l /etc/passwd /etc/shadow /bin/ls`.
   - Decode each permission string into words (who can do what?).

2. **Numeric fluency**
   Convert to numbers, then verify with `chmod` + `ls -l`:
   - `rw-r--r--`
   - `rwxr-x---`
   - `rwx------`

3. **The executable script**
   - Create `hello.sh` with a shebang and `echo "it works"`.
   - Try `./hello.sh` BEFORE making it executable — what error?
   - Fix it, run again.

4. **Private key drill**
   - Create `~/.ssh` if missing and a fake key: `echo fake > ~/.ssh/id_rsa`.
   - SSH refuses keys with open permissions — set them correctly (`700` for `~/.ssh`, `600` for the key).
   - Verify both with `ls -la ~/.ssh`.

5. **The 403 fix (roleplay)**
   - Simulate a web root: `sudo mkdir -p /var/www/fakeapp && echo hello | sudo tee /var/www/fakeapp/index.html`
   - Break it: `sudo chmod 640 -R /var/www/fakeapp` (group-only read, no execute).
   - Fix ownership & permissions exactly as you would for a real web server.
   - Verify a "visitor" can read the file: `sudo -u nobody cat /var/www/fakeapp/index.html`

## ✅ Check Yourself
- What does `chmod 777` actually allow — and why is it dangerous?
- Why must SSH private keys be `600`?
- Decode: `-rwxr-xr-x 1 root root` — who can run this file?

## Solutions
<details><summary>Click to reveal</summary>

```bash
# 1
# /etc/passwd: 644 — everyone reads, only root writes
# /etc/shadow: 640/600 — root only (group shadow on some systems)
# /bin/ls: 755 — everyone executes, only root modifies

# 2
# rw-r--r-- = 644 | rwxr-x--- = 750 | rwx------ = 700

# 3
printf '#!/bin/bash\necho "it works"\n' > hello.sh
chmod +x hello.sh && ./hello.sh

# 4
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo fake > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
ls -la ~/.ssh

# 5
sudo chown -R www-data:www-data /var/www/fakeapp
sudo chmod -R 755 /var/www/fakeapp
sudo -u nobody cat /var/www/fakeapp/index.html   # prints: hello
sudo rm -r /var/www/fakeapp                       # cleanup
```
</details>
