# 05. Permissions and Ownership: Controlling Access

> 🎯 **By the end of this chapter you will be able to:**
> - Read permission strings like `-rwxr-xr--` at a glance
> - Convert between symbolic (`rwx`) and numeric (`755`) permissions
> - Fix "Permission denied" and "403 Forbidden" errors for real
> - Know why `chmod 777` is a security hazard

---

## Step 1 — Why Permissions Exist

Linux permissions answer one question: **who can do what to this file?** Without them:

- Your app might not start (can't read its own config)
- Logs may fail to write (directory not writable by the service user)
- Attackers exploit loose access (a world-writable script is a welcome mat)

Understanding permissions is **non-negotiable** for system security and reliability.

## Step 2 — Reading the Permission String

Run:

```bash
ls -l somefile.txt
```

```
-rwxr-xr-- 1 nimesha devs 1200 Jul 23 12:00 somefile.txt
```

Break it down position by position:

```
-  rwx  r-x  r--
│   │    │    └─ Others (everyone else): read only
│   │    └────── Group (devs): read + execute
│   └─────────── Owner (nimesha): read + write + execute
└─────────────── File type: - = regular file, d = directory, l = symlink
```

**The three letters:**

| Letter | Meaning for files | Meaning for directories |
|---|---|---|
| `r` (4) | Read contents | List files (`ls`) inside |
| `w` (2) | Modify contents | Create/delete files inside |
| `x` (1) | Execute as a program | Enter (`cd`) into it |

> 💡 Directories need `x` to *enter* — a directory with `r--` lets you see names but not open anything inside.

## Step 3 — Numeric Permissions: The Math

Each letter has a value: **r = 4, w = 2, x = 1**. Add within each group:

| Symbolic | Calculation | Value |
|---|---|---|
| `rwx` | 4+2+1 | 7 |
| `rw-` | 4+2+0 | 6 |
| `r-x` | 4+0+1 | 5 |
| `r--` | 4+0+0 | 4 |
| `--x` | 0+0+1 | 1 |

### Common combinations (memorize these three)

| Number | Owner | Group | Others | Typical use |
|---|---|---|---|---|
| `755` | rwx | r-x | r-x | Scripts, executables, directories |
| `644` | rw- | r-- | r-- | Config files, static content |
| `700` | rwx | --- | --- | Private files (`~/.ssh`) |
| `770` | rwx | rwx | --- | Shared team directories |
| `777` | rwx | rwx | rwx | ❌ **Never in production** |

> ⚠️ `chmod 777` means "anyone, including the web server process or a compromised service, can modify this file." It's the #1 shortcut to a hacked server. Use the least privilege that works.

## Step 4 — Changing Permissions with `chmod`

**Symbolic mode** (modify specific bits):

```bash
chmod +x deploy.sh          # add execute for everyone
chmod u+x deploy.sh         # execute for owner only
chmod g-w report.txt        # remove write from group
chmod o= notes.txt          # others get nothing
```

**Numeric mode** (set everything at once):

```bash
chmod 755 script.sh         # rwx r-x r-x
chmod 644 index.html        # rw- r-- r--
chmod -R 755 /var/www/myapp # recursive: everything inside
```

**Make a script runnable:**
```bash
chmod +x deploy.sh
./deploy.sh                  # now you can run it directly
```

## Step 5 — Changing Ownership with `chown`

`chmod` controls *what can be done*; `chown` controls *who the file belongs to*:

```bash
sudo chown alice report.txt          # change owner
sudo chown alice:devs report.txt     # change owner AND group
sudo chown -R www-data:www-data /var/www/html/   # recursive
```

> 💡 `-R` (recursive) applies to everything inside a directory. Powerful — and dangerous if pointed at the wrong path.

## Step 6 — Real-World Scenario: Fixing a 403 Forbidden Flask App

You deployed a Flask app and the browser shows **403 Forbidden** — the web server can see the files but isn't allowed to serve them.

**Diagnose:**
```bash
ls -l /var/www/myapp          # check current ownership & permissions
```

**Fix:**
```bash
sudo chown -R www-data:www-data /var/www/myapp   # web server owns the files
sudo chmod -R 755 /var/www/myapp                 # owner full, others read/execute
```

Now `www-data` (the web server user) can read and execute the app, and nobody can write over it from the outside.

## Step 7 — Real-World Scenario: SSH Refuses to Connect

SSH is strict about key permissions:

```
Permissions 0644 for '/home/nimesha/.ssh/id_rsa' are too open.
```

The private key must be readable only by its owner:

```bash
chmod 600 ~/.ssh/id_rsa
```

`600` = `rw-------` — owner read/write only. One of the most-used `chmod` commands in DevOps.

## Step 8 — Decoding a Permission Check

```
-rwxr-x--- 1 nimesha devs 512 Oct  3 10:00 backup.sh
```

Read it: **owner** (nimesha) can run it; **group** (devs) can run it; **others** can't even read it. The numeric form is `750`.

---

## ⚠️ Common Pitfalls

| Mistake | Fix |
|---|---|
| `chmod 777` "to make it work" | Find the *actual* required user and grant just what's needed |
| Script won't run: `Permission denied` | `chmod +x script.sh` |
| `chmod -R` on the wrong path | Double-check with `pwd`/`ls` first; recovery is painful |
| Editing perms as non-owner | Most changes need `sudo` |
| Directory set to `644` and `cd` fails | Directories need execute (`755`) to enter |

---

## ✅ Try It Yourself

1. Create `secret.txt`, write a line in it, then set permissions to `600`. Can another user read it? (`sudo -u nobody cat secret.txt`)
2. Create `run.sh` containing `#!/bin/bash` and `echo hello`. What happens before and after `chmod +x run.sh`?
3. Make a directory `team` with `770`, owned by a group you're in. Can a non-member enter it?
4. Decode these into letters: `640`, `754`, `751`.
5. Your web app returns 403. Write the exact two commands you'd run.

➡️ Continue to [Chapter 06: Installing Software](../06-installing-software.md) — or practice with the [Permissions Lab](../exercises/05-permissions-lab.md).
