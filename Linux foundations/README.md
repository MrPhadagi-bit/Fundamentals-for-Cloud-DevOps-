# Linux for DevOps Beginners

A complete, beginner-friendly guide to Linux fundamentals — designed for aspiring DevOps, SRE, and Cloud engineers. No prior Linux experience required: every concept is explained **step by step**, with commands you can copy, run, and practice.

> **Why this repo?** In DevOps, the terminal is your primary interface. Cloud servers, Docker containers, and CI/CD runners have no GUI — everything runs on the command line. This bootcamp takes you from zero to confidently managing a Linux system.

---

## Who Is This For?

- Complete beginners who want to learn Linux from scratch
- Developers moving into DevOps / Cloud / SRE roles
- Anyone preparing for Linux certifications or technical interviews

## Prerequisites

- A Linux system (Ubuntu recommended) — a VM, WSL2, or cloud instance all work
- Or a Docker container: `docker run -it ubuntu bash`
- Curiosity and a willingness to type commands yourself

---

## Repo Structure

| # | Chapter | What You'll Learn |
|---|---------|-------------------|
| 01 | [The Filesystem](01-the-filesystem.md) | How Linux organizes files, key directories, navigating with `cd`/`ls`/`pwd` |
| 02 | [The Terminal](02-the-terminal.md) | Your command-line interface, essential commands, history, tab completion |
| 03 | [Files and Directories](03-files-and-directories.md) | Create, edit, copy, move, delete files and folders safely |
| 04 | [Users and Groups](04-users-and-groups.md) | Multi-user Linux, creating users, groups, `sudo` |
| 05 | [Permissions and Ownership](05-permissions-and-ownership.md) | `rwx` explained, `chmod`, `chown`, fixing 403 errors |
| 06 | [Installing Software](06-installing-software.md) | Package managers (`apt`), installing, updating, removing software |
| 07 | [Services and Processes](07-services-and-processes.md) | `systemctl`, managing services, viewing logs, killing processes |
| 08 | [Bash Scripting](08-bash-scripting.md) | Automate everything with scripts, loops, conditions, error handling |
| 09 | [Linux Networking Essentials](09-linux-networking-essentials.md) | IP addresses, DNS, ports, firewall (`ufw`), exposing apps |
| 10 | [Crontab: Scheduling Repetitive Tasks](10-crontab-scheduling-repetitive-tasks.md) | Cron syntax, scheduling backups and cleanups, debugging jobs |
| 11 | [Monitoring Basics](11-monitoring-basics.md) | CPU/memory/disk/network health, troubleshooting slow servers |
|  | [Cheatsheet](cheatsheet.md) | All essential commands on one page |
|  | [Exercises](exercises/) | Hands-on labs to practice every chapter |

**Each chapter follows the same format:**
1.  **Learning objectives** — what you'll be able to do
2.  **Step-by-step concept explanations** — nothing assumed, nothing skipped
3.  **Copy-paste examples** — real commands with real output
4.  **Common pitfalls** — mistakes beginners make (and how to avoid them)
5.  **Try it yourself** — a mini task to lock in the knowledge

---

## How to Use This Repo

**Option A — Follow along (recommended):**
Open a terminal next to this guide and run every command yourself. Muscle memory > reading.

**Option B — Self-test:**
Read a chapter, then do the exercise in [`exercises/`](exercises/) without looking back.

**Suggested pace:** 1 chapter per day → done in about two weeks, with a solid foundation.

---

## Quick Start (2 Minutes)

Spin up a practice environment right now:

```bash
# With Docker
docker run -it --name linux-practice ubuntu bash
apt update && apt install -y nano curl

# Or with WSL on Windows
wsl --install Ubuntu
```

Then verify your terminal works:

```bash
whoami    # who are you?
pwd       # where are you?
ls -l     # what's here?
```

---

## Chapter Overview

```
linux-devops-bootcamp/
├── README.md                        ← you are here
├── 01-the-filesystem.md             ← the tree of everything
├── 02-the-terminal.md               ← your daily driver
├── 03-files-and-directories.md      ← create / edit / move / delete
├── 04-users-and-groups.md           ← who can do what
├── 05-permissions-and-ownership.md  ← rwx, chmod, chown
├── 06-installing-software.md        ← apt, package management
├── 07-services-and-processes.md     ← systemd, systemctl, logs
├── 08-bash-scripting.md             ← automate everything
├── 09-linux-networking-essentials.md ← IPs, DNS, ports, ufw
├── 10-crontab-scheduling-repetitive-tasks.md ← schedule it, forget it
├── 11-monitoring-basics.md          ← CPU, disk, network health
├── cheatsheet.md                    ← quick reference
└── exercises/
    ├── 01-filesystem-lab.md
    ├── 02-terminal-lab.md
    ├── 03-files-lab.md
    ├── 04-users-lab.md
    ├── 05-permissions-lab.md
    ├── 06-packages-lab.md
    ├── 07-services-lab.md
    └── 08-scripting-lab.md
```

---

## The DevOps Mindset

Throughout this bootcamp you'll notice a recurring theme: **commands over clicks**.

| GUI (Desktop) | CLI (Terminal) |
|---------------|----------------|
| Click, point, drag | Type, pipe, script |
| Hard to repeat | Easy to repeat |
| Can't automate | Fully automatable |
| Doesn't work over SSH | Works everywhere |

Every chapter ends with a **real-world scenario** — the kind of task you'd actually do on the job: fixing a broken web server, deploying an app, automating backups.

---

## Contributing

Found a typo? Want a better explanation? PRs are welcome:

1. Fork the repo
2. Create a branch (`git checkout -b fix/chapter-05-typo`)
3. Commit your change
4. Open a pull request

## License

MIT — use it, share it, teach with it.


