# 🐧 Installing Linux (Ubuntu) on Windows with WSL — Complete Guide

> **WSL (Windows Subsystem for Linux)** lets you run a full Linux environment — bash, apt, systemd tools, Docker — directly on Windows, without a virtual machine or dual boot. This is the exact same Linux you'll manage in the cloud as a DevOps engineer, running natively on your laptop.

[![WSL](https://img.shields.io/badge/WSL-2-blue?logo=windows)](https://learn.microsoft.com/en-us/windows/wsl/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange?logo=ubuntu)](https://ubuntu.com/wsl)

---

## 📑 Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Method 1: One-Command Install (Recommended)](#2-method-1-one-command-install-recommended)
3. [Method 2: Manual Install via Windows Features](#3-method-2-manual-install-via-windows-features)
4. [First Launch — Creating Your User](#4-first-launch--creating-your-user)
5. [Verifying the Installation](#5-verifying-the-installation)
6. [Post-Install Setup (Do This Every Time)](#6-post-install-setup-do-this-every-time)
7. [Making It Feel Professional](#7-making-it-fe-professional)
8. [Troubleshooting Common Errors](#8-troubleshooting-common-errors)
9. [Essential WSL Commands Cheat Sheet](#9-essential-wsl-commands-cheat-sheet)
10. [What's Next?](#10-whats-next)

---

## 1. Prerequisites

| Requirement | How to check |
|-------------|--------------|
| **Windows 10 version 2004+ (Build 19041+)** or **Windows 11** | Press `Win + R` → type `winver` → Enter |
| **Virtualization enabled** in BIOS/UEFI | Task Manager → Performance → CPU → "Virtualization: **Enabled**" |

Check your build from PowerShell:

```powershell
# Must return 19041 or higher on Win10, or any Win11 build
[System.Environment]::OSVersion.Version
```

> 💡 If you see `Virtualization: Disabled` in Task Manager, you must enable **Intel VT-x** or **AMD-V** in your BIOS/UEFI (usually under *Advanced → CPU Configuration*). This is the #1 cause of WSL 2 errors — see §8.

---

## 2. Method 1: One-Command Install (Recommended)

Microsoft now ships a single command that enables all required features **and** installs Ubuntu in one shot. <REF>cite✦tools://web_search:3#0:~:text=You can now install everything you need...then restart your machine</REF>

### Step 1 — Open PowerShell **as Administrator**

- Press `Win` → type `powershell`
- Right-click **Windows PowerShell** → **Run as administrator**

### Step 2 — Run the install command

```powershell
wsl --install
```

**What this does under the hood:**

| Action | Equivalent manual step |
|--------|------------------------|
| Enables the *Virtual Machine Platform* feature | `dism ... /featurename:VirtualMachinePlatform` |
| Enables the *Windows Subsystem for Linux* feature | `dism ... /featurename:Microsoft-Windows-Subsystem-Linux` |
| Downloads & installs WSL 2 kernel | Manual MSI download |
| Sets WSL 2 as default | `wsl --set-default-version 2` |
| **Installs Ubuntu** (default distro) | Microsoft Store install |

You'll see output like:

```
Installing: Virtual Machine Platform
Virtual Machine Platform has been installed.
Installing: Windows Subsystem for Linux
Windows Subsystem for Linux has been installed.
Installing: Ubuntu
Ubuntu has been installed.
The requested operation is successful. Changes will not be effective until the system is rebooted.
```

### Step 3 — **Restart your computer** 🔄

The features only activate after a reboot. Don't skip this.

> 💡 Want a different distro? List all available ones first: `wsl --list --online`, then install with `wsl --install -d Debian` (replace `Debian` with your choice). <REF>cite✦tools://web_search:3#0:~:text=To see a list of available Linux distributions...wsl.exe --list --online</REF>

---

## 3. Method 2: Manual Install via Windows Features

Use this on older builds, locked-down machines, or when Method 1 fails.

### Step 1 — Enable the two Windows features

Press `Win` → type **"Windows Features"** → open **"Turn Windows features on or off"** → check both:

- ☑ **Virtual Machine Platform**  ← needed for WSL 2
- ☑ **Windows Subsystem for Linux**

Click OK and **restart**. <REF>cite✦tools://web_search:3#3:~:text=Toggle on the following...Subsistema de Windows para Linux</REF>

Or via PowerShell (admin):

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

### Step 2 — Set WSL 2 as the default version

```powershell
wsl --set-default-version 2
```

> 📖 **WSL 1 vs WSL 2:** WSL 2 runs a real Linux kernel inside a lightweight VM — full system call compatibility (Docker works!), much faster filesystem I/O. WSL 1 was a translation layer. Always choose WSL 2 in 2026. <REF>cite✦tools://web_search:3#0:~:text=New Linux installations...set to WSL 2 by default</REF>

### Step 3 — Install Ubuntu from the Microsoft Store

1. Open **Microsoft Store** → search **"Ubuntu"**
2. Pick **Ubuntu 24.04 LTS** (or 22.04 LTS)
3. Click **Get** / **Install**

> 🏪 Store blocked by policy? Install via `wsl --install -d Ubuntu-24.04` in admin PowerShell, or download the `.wsl`/`.appx` package from the official distribution info.

---

## 4. First Launch — Creating Your User

After the reboot, Ubuntu needs one-time initialization:

1. Launch **Ubuntu** from the Start menu (or run `ubuntu` in PowerShell)
2. Wait a few seconds while it decompresses files — *"Installing, this may take a few minutes..."*
3. You'll be prompted to create your Linux credentials:

```
Enter new UNIX username: devops
New password: ********        ← typing is INVISIBLE — that's normal Linux behavior
Retype new password: ********
```

> ⚠️ **Important:**
> - These credentials are **only for Ubuntu** — independent of your Windows password
> - This user gets `sudo` privileges automatically
> - When you type the password, **nothing appears on screen**. It's working — just type and press Enter
> - **Remember it!** You'll need it for every `sudo` command

Success looks like:

```
Welcome to Ubuntu 24.04 LTS (GNU/Linux 5.15.x-microsoft-standard-WSL2 x86_64)
...
devops@DESKTOP-ABC123:~$
```

🎉 **You're now running Linux on Windows.**

---

## 5. Verifying the Installation

Run these inside your Ubuntu terminal:

```bash
# Linux kernel version (note "microsoft-standard-WSL2" — that's your kernel)
uname -a
# Linux DESKTOP-ABC123 5.15.153.1-microsoft-standard-WSL2 #1 SMP x86_64 GNU/Linux

# Which distro & version
cat /etc/os-release | head -3
# PRETTY_NAME="Ubuntu 24.04 LTS"

# WSL version from PowerShell (Windows side)
# → open PowerShell and run:
wsl -l -v
#   NAME      STATE           VERSION
# * Ubuntu    Running         2          ← VERSION 2 ✅
```

---

## 6. Post-Install Setup (Do This Every Time)

### 6.1 Update all packages — first thing, always

```bash
sudo apt update && sudo apt upgrade -y
```

### 6.2 Install the essentials

```bash
sudo apt install -y \
  build-essential \    # gcc, make — compile tools
  curl wget \          # downloads
  git \                # version control
  htop tmux \          # process viewer, terminal multiplexer
  unzip jq \           # archives + JSON processor
  net-tools dnsutils   # ifconfig, dig
```

### 6.3 Verify the Windows ↔ Linux integration

```bash
# Your Windows drives are auto-mounted under /mnt
ls /mnt
# c  d

# Access Windows files from Linux
cat /mnt/c/Users/YourName/Desktop/notes.txt

# Access Linux files from Windows Explorer (type in address bar):
# \\wsl$\Ubuntu\home\devops
```

> 📁 **Golden rule of WSL file I/O:** keep project files **inside the Linux filesystem** (`~/projects`), not under `/mnt/c/...`. Cross-filesystem access is ~10x slower — this alone makes WSL feel "fast" vs "unusable".

---

## 7. Making It Feel Professional

### Install Windows Terminal (highly recommended)

Microsoft's terminal: tabs, panes, profiles for PowerShell + Ubuntu side by side.

```powershell
# From PowerShell (any level):
winget install Microsoft.WindowsTerminal
```

Or get it from the Microsoft Store. Then set Ubuntu as the default profile: `Ctrl + ,` → Startup → Default profile → **Ubuntu**.

### VS Code + WSL extension

1. Install VS Code on Windows
2. Install extension: **WSL** (`ms-vscode-remote.remote-wsl`)
3. Inside Ubuntu run: `code .` → VS Code opens connected to Linux

Now you edit with Windows GUI while tools (node, python, docker) run in Linux. This is the standard DevOps/dev workflow.

### Enable systemd (modern WSL)

```bash
# Edit /etc/wsl.conf
sudo tee /etc/wsl.conf <<'EOF'
[boot]
systemd=true
EOF
```

Then in PowerShell: `wsl --shutdown` and reopen Ubuntu. Verify:

```bash
ps -p 1 -o comm=
# systemd   ← services like snap, docker work properly now
```

---

## 8. Troubleshooting Common Errors

| Error code / symptom | Cause | Fix |
|---------------------|-------|-----|
| **`0x80370102`** | Virtualization disabled in BIOS | Reboot → BIOS/UEFI → enable **Intel VT-x** / **AMD-V** / **SVM Mode** <REF>cite✦tools://web_search:3#1:~:text=Fail with error 0x80370102...Go into BIOS and enable Virtualization Technology</REF> |
| **`0x8007019e`** | WSL feature not enabled | Enable both Windows features (§3) and reboot |
| **`0x8004032d`** | VM Platform conflict (Hyper-V) | Enable *Virtual Machine Platform*; check Hyper-V services |
| **Stuck at 0.0% installing** | Slow Store download | `wsl --install --web-download -d Ubuntu` (downloads directly, bypasses Store) <REF>cite✦tools://web_search:3#0:~:text=If the install process hangs at 0.0%...prior to installing</REF> |
| **`wsl --install` shows help text** | WSL already partially installed | Use `wsl --list --online` then `wsl --install -d <Distro>` <REF>cite✦tools://web_search:3#0:~:text=see WSL help text...wsl --list --online</REF> |
| **`Please enable the Virtual Machine Platform`** | Feature missing | `dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart` then reboot |
| **Nothing happens on launch** | Corrupted install | `wsl --unregister Ubuntu` (⚠️ deletes data) → reinstall |

**Diagnostic sequence when WSL won't start:**

```powershell
# 1. Is WSL itself OK?
wsl --status

# 2. Is virtualization available?
wsl --version

# 3. Fully shut down and restart WSL
wsl --shutdown
wsl -l -v
```

---

## 9. Essential WSL Commands Cheat Sheet

Run these in **PowerShell** (Windows side) unless noted:

```powershell
wsl --install                    # install WSL + Ubuntu
wsl --list --online              # list downloadable distros
wsl --install -d Ubuntu-24.04    # install specific distro
wsl -l -v                        # list installed distros + WSL version
wsl -s Ubuntu                    # set default distro
wsl                              # open default distro shell
wsl -d Ubuntu -u root            # open as root user
wsl --shutdown                   # stop ALL WSL VMs (frees RAM)
wsl --terminate Ubuntu           # stop one distro
wsl --update                     # update WSL kernel
wsl --unregister Ubuntu          # ☠️ completely remove a distro (data loss!)
wsl --export Ubuntu backup.tar   # backup a distro
wsl --import Ubuntu C:\WSL\Ubuntu backup.tar  # restore a distro
```

Inside Ubuntu, these work too:

```bash
explorer.exe .        # open current Linux folder in Windows Explorer
notepad.exe file.txt  # edit a Linux file in Notepad
ipconfig.exe          # run Windows commands from Linux (!)
```

---

## 10. What's Next?

You now have a real Linux box on your Windows machine — the perfect sandbox to practice everything in `linux-for-cloud-devops.md`:

| Practice | Command to start with |
|----------|----------------------|
| Navigate the filesystem | `pwd`, `ls -lah`, `cd /etc` |
| Manage packages | `sudo apt install nginx` |
| Run a web server | `python3 -m http.server 8000` → browse `localhost:8000` |
| Permissions & users | `chmod`, `sudo`, `/etc/passwd` |
| Bash scripting | write `deploy.sh`, run `bash -x deploy.sh` |
| Networking tools | `curl`, `dig`, `ss -tulpn` |
| Containers | install Docker Desktop with WSL2 backend → `docker run hello-world` |

> 🎯 **Pro tip:** whatever you break in WSL can be wiped and reinstalled in 5 minutes (`wsl --unregister`). That's exactly why WSL is the safest place to learn Linux aggressively.

---

*Happy hacking — see you in the cloud! ☁️🐧*
