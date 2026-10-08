# 06. Installing Software: Package Managers

>  **By the end of this chapter you will be able to:**
> - Explain what a package manager does and why Linux doesn't need an "app store"
> - Install, update, and remove software with `apt`
> - Understand the difference between `remove` and `purge`
> - Install Docker end-to-end and verify it works

---

## Step 1 — What Is a Package Manager?

Linux doesn't have an App Store like Windows or macOS — it has something better: a **package manager**. It's a command-line tool that can:

- Install new software
- Remove it cleanly
- Update it safely
- Resolve **dependencies** automatically (if app A needs library B, B is installed too)

Everything in DevOps — Docker, Nginx, Python tooling, even VS Code on a server — goes through a package manager.

## Step 2 — Know Your Package Manager

| Package Manager | Used by |
|---|---|
| **APT** | Debian-based: Ubuntu, Kali, Debian |
| **DNF / YUM** | Red Hat-based: Fedora, CentOS, RHEL |
| **Zypper** | openSUSE |
| **Pacman** | Arch Linux |

> Ubuntu dominates cloud/DevOps, so this guide uses **APT**. The concepts transfer 1:1 to the others — only the command names differ (`dnf install` vs `apt install`).

## Step 3 — The Two-Step Install Workflow

```bash
sudo apt update          # Step 1: refresh the package list
sudo apt install nginx   # Step 2: install
```

### Why `apt update` first?

Your system keeps a local **index** of available packages. `apt update` re-downloads that index from the configured repositories — like refreshing your app store. Without it, you might install an outdated version, or fail to find a package at all.

>  **Pitfall:** `apt update` updates the *list*; it updates **nothing** on your system. `apt upgrade` updates the *software*. Beginners confuse these constantly.

```bash
sudo apt install git           # version control
sudo apt install htop          # better process viewer
sudo apt install python3-pip   # Python package installer
```

## Step 4 — Updating Everything

```bash
sudo apt upgrade                # upgrade all installed packages
sudo apt full-upgrade           # also handles dependency changes (safer on servers: read the prompt!)
```

**The classic combo:**
```bash
sudo apt update && sudo apt upgrade -y
```

- `&&` means "run the second command only if the first succeeded"
- `-y` auto-answers "yes" to prompts — essential for scripts and CI

## Step 5 — Removing Software

Three levels, from gentle to thorough:

```bash
sudo apt remove nginx       # removes the program, KEEPS config files
sudo apt purge nginx        # removes program AND its configs
sudo apt autoremove         # deletes leftover dependencies no longer needed
```

**When to use which:**
- Reinstalling to fix corruption? → `remove`
- Decommissioning the service forever? → `purge`
- Cleaning up after any of the above? → `autoremove`

## Step 6 — Search and Inspect

```bash
apt search nginx             # search for packages
apt show nginx               # details: version, description, dependencies
apt list --installed         # everything installed on this system
dpkg -l | grep nginx         # check if a specific package is installed
```

## Step 7 — Real-World Example: Installing Docker

```bash
sudo apt update
sudo apt install docker.io
sudo systemctl enable docker     # start automatically on boot
sudo systemctl start docker      # start now
```

**Verify it works:**
```bash
docker --version
sudo docker run hello-world
```

(After Chapter 04 you know how to drop the `sudo`: `sudo usermod -aG docker $USER`.)

## Step 8 — External Repositories (Advanced)

Some software (newer Node.js, VS Code) isn't in Ubuntu's default repos. Vendors provide their own **repository** — a trusted download source your package manager can use:

```bash
# Add NodeSource's repository, then install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
```

Adding a repository means trusting that vendor — so only add repos from sources you recognize.

>  **Never blindly pipe `curl ... | sudo bash` from a random website.** Read the script first (`curl -fsSL URL | less`), then execute.

---

##  Common Pitfalls

| Mistake | Fix |
|---|---|
| `apt install` fails with "Unable to locate package" | Run `sudo apt update` first |
| Confusing `update` with `upgrade` | `update` = refresh list; `upgrade` = install newer software |
| `remove` and configs keep coming back | Use `purge` to delete configs too |
| Disk filling with old packages | Run `sudo apt autoremove` and `sudo apt clean` occasionally |
| `curl | sudo bash` from unknown sources | Inspect the script first |

---

##  Try It Yourself

1. Run `apt search json` and find one package you recognize.
2. Install `htop`, run it, and quit with `q`.
3. Run `apt show htop` — what's the installed size?
4. Remove it with `purge`, then clean up with `autoremove`.
5. What does `dpkg -l | wc -l` tell you about your system?

➡️ Continue to [Chapter 07: Services and Processes](../07-services-and-processes.md) — or practice with the [Packages Lab](../exercises/06-packages-lab.md).
