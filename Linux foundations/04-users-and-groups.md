# 04. Users and Groups: Managing Access

>  **By the end of this chapter you will be able to:**
> - Explain what users and groups are (and why services run as their own users)
> - Create users and add them to groups
> - Give a user passwordless access to a specific tool (e.g., Docker)
> - Understand `sudo` and the root user — and when to use each

---

## Step 1 — Linux Is Multi-User (Even When You're Alone)

Linux was designed for many people to share one machine. Even on your laptop:

- **You** have a regular user account
- **Services** run as their own users (`nginx`, `postgres`, `www-data`)
- **root** exists as the superuser

Running everything as root would be like giving every app your house keys. Separation limits damage: if a web server process is compromised, the attacker is trapped inside the `www-data` user's limited world.

## Step 2 — Anatomy of a User

Every user has:

| Attribute | Example | Where it's stored |
|---|---|---|
| Username | `john` | `/etc/passwd` |
| UID (User ID) | `1001` | `/etc/passwd` |
| Home directory | `/home/john` | `/etc/passwd` |
| Default shell | `/bin/bash` | `/etc/passwd` |
| Password hash | `!` (locked) | `/etc/shadow` |

**Find out who you are:**
```bash
whoami            # current username
id                # username + UID + all your groups
```

**List all users:**
```bash
cat /etc/passwd
```
Each line is `username:x:UID:GID:comment:home:shell`. (Only real human users have UIDs ≥ 1000; lower UIDs belong to system services.)

## Step 3 — Create and Switch Users

```bash
sudo adduser john          # interactive: sets password, asks for info
sudo useradd -m john       # lower-level, no password set (scripting)
sudo passwd john           # set/change a password
```

**Switch to another user:**
```bash
su - john          # - = load their full environment (like logging in)
exit               # switch back
```

>  `adduser` is friendlier (Debian/Ubuntu); `useradd` is the portable standard.

## Step 4 — Groups: Permissions for Teams

A group is a named list of users. Permissions (Chapter 05) are assigned to groups, so adding someone to a group instantly grants them everything the group can do.

**View your groups:**
```bash
groups              # groups for current user
groups john         # groups for a specific user
```

**Add a user to a group:**
```bash
sudo usermod -aG docker john
```

>  **Don't forget `-a`!** `usermod -G` *replaces* all the user's groups; `-aG` **appends**. Forgetting `-a` can lock yourself out of `sudo`.

The user must log out and back in (or run `newgrp docker`) for the change to take effect.

### Common groups you'll meet in DevOps

| Group | What it grants |
|---|---|
| `sudo` | Run commands as root |
| `docker` | Run Docker without `sudo` |
| `www-data` | Web server file ownership |
| `adm` | Read system logs |

## Step 5 — sudo: Borrowing Root Power Safely

The **root user** has total control. Instead of logging in as root (which is unaudited and dangerous), use:

```bash
sudo somecommand
```

This runs a single command with admin privileges, using *your* password, and every sudo use is logged.

**Edit a protected file:**
```bash
sudo nano /etc/ssh/sshd_config
```

**Run a shell as root (use sparingly):**
```bash
sudo -i
```

## Step 6 — Real-World Scenario: Shared Project Directory

Your team needs a shared workspace on a server:

```bash
# 1. Create the shared directory
sudo mkdir /var/shared_project

# 2. Create a group for the team
sudo groupadd devs

# 3. Give the group ownership of the directory
sudo chgrp devs /var/shared_project

# 4. Permissions: owner rwx, group rwx, others nothing (we cover the numbers next chapter)
sudo chmod 770 /var/shared_project

# 5. Add team members
sudo usermod -aG devs alice
sudo usermod -aG devs bob
```

Now everyone in `devs` can read/write in `/var/shared_project` — and nobody else can. When a new teammate joins, **one command** gives them access.

## Step 7 — Real-World Scenario: Docker Without sudo

By default, running `docker` requires root. Add yourself to the `docker` group:

```bash
sudo usermod -aG docker $USER
newgrp docker          # activate without re-logging in
docker ps              # works, no sudo!
```

---

##  Common Pitfalls

| Mistake | Fix |
|---|---|
| `usermod -G docker john` (without `-a`) | John lost his other groups — always `-aG` |
| Group change "not working" | Log out/in, or use `newgrp` |
| Editing system files without `sudo` | Nano will say "Permission denied" — open with `sudo nano` |
| Running everything as root | Use a regular user + `sudo` for admin tasks |

---

##  Try It Yourself

1. Run `id` — what is your UID, and which groups are you in?
2. Create a user `trainee`, set a password, and switch to them with `su - trainee`.
3. As `trainee`, try `cat /etc/shadow` — it should fail. Why?
4. Create a group `reviewers`, add `trainee`, and verify with `groups trainee`.
5. Clean up: exit back to your user, then `sudo deluser trainee`.

➡️ Continue to [Chapter 05: Permissions and Ownership](../05-permissions-and-ownership.md) — or practice with the [Users Lab](../exercises/04-users-lab.md).
