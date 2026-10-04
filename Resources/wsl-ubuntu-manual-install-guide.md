# 🐧 Installing Linux (Ubuntu) on Windows with WSL — Manual Install Guide

> **WSL (Windows Subsystem for Linux)** lets you run a full Linux environment — bash, apt, systemd tools, Docker — directly on Windows, without a virtual machine or dual boot.
>
> This guide covers the **manual installation entirely from PowerShell**, showing the **exact command output** you should see at every step, so you can compare your screen against this document.

[![WSL](https://img.shields.io/badge/WSL-2-blue?logo=windows)](https://learn.microsoft.com/en-us/windows/wsl/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange?logo=ubuntu)](https://ubuntu.com/wsl)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?logo=powershell)](https://learn.microsoft.com/en-us/powershell/)

---

## 📑 Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Step 1 — Open PowerShell as Administrator](#2-step-1--open-powershell-as-administrator)
3. [Step 2 — Check Your Windows Version from PowerShell](#3-step-2--check-your-windows-version-from-powershell)
4. [Step 3 — Enable the Required Windows Features](#4-step-3--enable-the-required-windows-features)
5. [Step 4 — Restart Your Computer](#5-step-4--restart-your-computer)
6. [Step 5 — Set WSL 2 as the Default Version](#6-step-5--set-wsl-2-as-the-default-version)
7. [Step 6 — Install Ubuntu from PowerShell](#7-step-6--install-ubuntu-from-powershell)
8. [Step 7 — First Launch: Create Your Linux User](#8-step-7--first-launch-create-your-linux-user)
9. [Step 8 — Verify the Installation](#9-step-8--verify-the-installation)
10. [Post-Install Setup](#10-post-install-setup)
11. [Making It Feel Professional](#11-making-it-feel-professional)
12. [Troubleshooting Common Errors](#12-troubleshooting-common-errors)
13. [Essential WSL Commands Cheat Sheet](#13-essential-wsl-commands-cheat-sheet)
14. [What's Next?](#14-whats-next)

---

## 1. Prerequisites

| Requirement | How to check |
|-------------|--------------|
| **Windows 10 version 2004+ (Build 19041+)** or **Windows 11** | PowerShell: `winver` or `(Get-ComputerInfo).OsBuildNumber` |
| **Virtualization enabled** in BIOS/UEFI | Task Manager → Performance → CPU → "Virtualization: **Enabled**" |
| **Administrator rights** | Needed to enable Windows features |

> 💡 If you see `Virtualization: Disabled` in Task Manager, you must enable **Intel VT-x** or **AMD-V / SVM Mode** in your BIOS/UEFI (usually under *Advanced → CPU Configuration*). This is the #1 cause of WSL 2 errors — see §12.

---

## 2. Step 1 — Open PowerShell as Administrator

1. Press `Win` → type `powershell`
2. Right-click **Windows PowerShell** → **Run as administrator**
3. Click **Yes** on the UAC prompt

You know it worked when the window title says **"Administrator: Windows PowerShell"**:

```
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

PS C:\Windows\system32>
```

> 🔒 All commands in this guide must be run from this **elevated** PowerShell window (unless stated otherwise).

---

## 3. Step 2 — Check Your Windows Version from PowerShell

```powershell
# Check OS build — must be 19041 or higher on Win10, or any Win11 build
[System.Environment]::OSVersion.Version
```

**Expected output (Windows 11):**

```
Major  Minor  Build  Revision
-----  -----  -----  --------
10     0      22631  0
```

**Expected output (Windows 10 — build 19045):**

```
Major  Minor  Build  Revision
-----  -----  -----  --------
10     0      19045  0
```

Or with a one-liner:

```powershell
# Returns True if your build supports WSL
[System.Environment]::OSVersion.Version.Build -ge 19041
```

```
True
```

---

## 4. Step 3 — Enable the Required Windows Features

WSL 2 needs **two** Windows features enabled. Run these one at a time in your admin PowerShell:

### 4.1 Enable the Windows Subsystem for Linux feature

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

**Expected full output:**

```
Deployment Image Servicing and Management tool
Version: 10.0.22621.1

Image Version: 10.0.22631.4037

Enabling feature(s)
[==========================100.0%==========================]
The operation completed successfully.
```

### 4.2 Enable the Virtual Machine Platform feature

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

**Expected full output:**

```
Deployment Image Servicing and Management tool
Version: 10.0.22621.1

Image Version: 10.0.22631.4037

Enabling feature(s)
[==========================100.0%==========================]
The operation completed successfully.
```

> 📌 The `Version:` and `Image Version:` numbers will differ on your machine — that's fine. What matters is **"The operation completed successfully."**
>
> 🔁 We use `/norestart` so both features enable before a single reboot (Step 4). If you prefer the GUI: `Win` → *"Turn Windows features on or off"* → check ☑ **Virtual Machine Platform** and ☑ **Windows Subsystem for Linux**.

---

## 5. Step 4 — Restart Your Computer

```powershell
# Optional: reboot straight from PowerShell (or use the Start menu)
Restart-Computer
```

> 🔄 The features only activate after a reboot. **Don't skip this step** — WSL commands will fail with feature errors until you restart.

After the machine boots, open **admin PowerShell again** and continue.

---

## 6. Step 5 — Set WSL 2 as the Default Version

> 📖 **WSL 1 vs WSL 2:** WSL 2 runs a real Linux kernel inside a lightweight VM — full system-call compatibility (Docker works!) and much faster filesystem I/O. Always choose WSL 2.

```powershell
wsl --set-default-version 2
```

**Expected output:**

```
For information on key differences with WSL 2 please visit https://aka.ms/wsl2
The operation completed successfully.
```

> ⚠️ If you instead see an error about a missing kernel, update it with `wsl --update` first.

---

## 7. Step 6 — Install Ubuntu from PowerShell

You don't need the Microsoft Store — PowerShell can download and install the distro directly.

### 7.1 (Optional) List what distros are available

```powershell
wsl --list --online
```

**Expected output:**

```
The following is a list of valid distributions that can be installed.
Install using 'wsl --install -d <Distro>'.

NAME                            FRIENDLY NAME
Ubuntu                          Ubuntu
Debian                          Debian GNU/Linux
kali-linux                      Kali Linux Rolling
openSUSE-Tumbleweed             openSUSE Tumbleweed
...
```

### 7.2 Install Ubuntu 24.04 LTS

```powershell
wsl --install -d Ubuntu-24.04
```

**Expected full output:**

```
Installing: Ubuntu 24.04 LTS
Ubuntu 24.04 LTS has been installed.
Launching Ubuntu 24.04 LTS...
```

> 💾 The launcher then runs in the **same PowerShell window** and switches to Ubuntu's first-time setup (Step 7).
>
> 🌐 Store download hanging? Add `--web-download` to pull the package directly from Microsoft servers instead of the Store: `wsl --install -d Ubuntu-24.04 --web-download`

---

## 8. Step 7 — First Launch: Create Your Linux User

The Ubuntu window opens automatically and decompresses its filesystem:

```
Installing, this may take a few minutes...
Please create a default UNIX user account. The username does not need to match your Windows username.
For more information visit: https://aka.ms/wslusers
```

Then you'll be prompted for credentials:

```
Enter new UNIX username: devops
New password: ********        ← typing is INVISIBLE — that's normal Linux behavior
Retype new password: ********
```

**Success looks like this:**

```
Welcome to Ubuntu 24.04 LTS (GNU/Linux 5.15.153.1-microsoft-standard-WSL2 x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Sat Oct  4 21:55:00 CEST 2026

  System load:  0.0                Processes:             35
  Usage of /:   0.4% of 1006.85GB  Users logged in:       0
  Memory usage: 4%                 IPv4 address for eth0: 172.21.148.25
  Swap usage:   0%

devops@DESKTOP-ABC123:~$
```

> ⚠️ **Important:**
> - These credentials are **only for Ubuntu** — independent of your Windows password
> - This user gets `sudo` privileges automatically
> - When you type the password, **nothing appears on screen**. It's working — just type and press Enter
> - **Remember it!** You'll need it for every `sudo` command

🎉 **You're now running Linux on Windows.**

---

## 9. Step 8 — Verify the Installation

### 9.1 From the Ubuntu terminal (Linux side)

```bash
# Linux kernel version — note "microsoft-standard-WSL2" in the output
uname -a
```
```
Linux DESKTOP-ABC123 5.15.153.1-microsoft-standard-WSL2 #1 SMP Thu Oct 10 09:15:13 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
```

```bash
# Which distro & version
cat /etc/os-release | head -3
```
```
PRETTY_NAME="Ubuntu 24.04 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
```

### 9.2 From PowerShell (Windows side)

Open a **new** PowerShell window and run:

```powershell
wsl -l -v
```

**Expected output — make sure VERSION says `2`:**

```
  NAME            STATE           VERSION
* Ubuntu-24.04    Running         2
```

```powershell
wsl --status
```

**Expected output:**

```
Default Version: 2
```

---

## 10. Post-Install Setup

### 10.1 Update all packages — first thing, always

```bash
sudo apt update && sudo apt upgrade -y
```

### 10.2 Install the essentials

```bash
sudo apt install -y \
  build-essential \
  curl wget \
  git \
  htop tmux \
  unzip jq \
  net-tools dnsutils
```

### 10.3 Verify the Windows ↔ Linux integration

```bash
# Your Windows drives are auto-mounted under /mnt
ls /mnt
```
```
c  d
```

```bash
# Access Windows files from Linux
cat /mnt/c/Users/YourName/Desktop/notes.txt
```

Access Linux files from Windows Explorer (type in the address bar):

```
\\wsl$\Ubuntu-24.04\home\devops
```

> 📁 **Golden rule of WSL file I/O:** keep project files **inside the Linux filesystem** (`~/projects`), not under `/mnt/c/...`. Cross-filesystem access is ~10x slower — this alone makes WSL feel "fast" vs "unusable".

---

## 11. Making It Feel Professional

### Install Windows Terminal (highly recommended)

Microsoft's terminal: tabs, panes, profiles for PowerShell + Ubuntu side by side.

```powershell
# From PowerShell (any level):
winget install Microsoft.WindowsTerminal
```

Or get it from the Microsoft Store. Then set Ubuntu as the default profile: `Ctrl + ,` → Startup → Default profile → **Ubuntu 24.04**.

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
```
```
systemd
```
Now services like `snap` and `docker` work properly.

---

## 12. Troubleshooting Common Errors

| Error code / symptom | Cause | Fix |
|---------------------|-------|-----|
| **`0x80370102`** | Virtualization disabled in BIOS | Reboot → BIOS/UEFI → enable **Intel VT-x** / **AMD-V** / **SVM Mode** |
| **`0x8007019e`** | WSL feature not enabled | Re-run both `dism.exe` commands from §4 and reboot |
| **`0x8004032d`** | VM Platform conflict (Hyper-V) | Enable *Virtual Machine Platform*; check Hyper-V services |
| **Stuck at 0.0% installing** | Slow Store download | `wsl --install -d Ubuntu-24.04 --web-download` (bypasses the Store) |
| **`wsl --install` shows help text** | WSL already partially installed | Use `wsl --list --online` then `wsl --install -d <Distro>` |
| **`Please enable the Virtual Machine Platform`** | Feature missing | `dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart` then reboot |
| **Nothing happens on launch** | Corrupted install | `wsl --unregister Ubuntu-24.04` (⚠️ deletes data) → reinstall |

**Diagnostic sequence in PowerShell when WSL won't start:**

```powershell
# 1. Is WSL itself OK?
wsl --status

# 2. Is the WSL kernel installed and up to date?
wsl --version

# 3. Fully shut down and restart WSL
wsl --shutdown
wsl -l -v
```

**Expected output of `wsl --version`:**

```
WSL version: 2.3.24.0
Kernel version: 5.15.153.1-2
WSLg version: 1.0.65
MSRDC version: 1.2.5620
Direct3D version: 1.611.1-81528511
DXCore version: 10.0.26100.1-240331-1435.ge77c84a
Windows version: 10.0.22631.4037
```

---

## 13. Essential WSL Commands Cheat Sheet

Run these in **PowerShell** (Windows side) unless noted:

```powershell
wsl --list --online                    # list downloadable distros
wsl --install -d Ubuntu-24.04          # install a specific distro
wsl -l -v                              # list installed distros + WSL version
wsl -s Ubuntu-24.04                    # set default distro
wsl                                    # open default distro shell
wsl -d Ubuntu-24.04 -u root            # open a distro as root
wsl --shutdown                         # stop ALL WSL VMs (frees RAM)
wsl --terminate Ubuntu-24.04           # stop one distro
wsl --update                           # update WSL kernel
wsl --status                           # show WSL config status
wsl --unregister Ubuntu-24.04          # ☠️ completely remove a distro (data loss!)
wsl --export Ubuntu-24.04 backup.tar   # backup a distro
wsl --import Ubuntu-24.04 C:\WSL\Ubuntu backup.tar  # restore a distro
```

Inside Ubuntu, these Windows commands work too:

```bash
explorer.exe .        # open current Linux folder in Windows Explorer
notepad.exe file.txt  # edit a Linux file in Notepad
ipconfig.exe          # run Windows commands from Linux (!)
```

---

## 14. What's Next?

You now have a real Linux box on your Windows machine — the perfect sandbox to practice DevOps fundamentals:

| Practice | Command to start with |
|----------|----------------------|
| Navigate the filesystem | `pwd`, `ls -lah`, `cd /etc` |
| Manage packages | `sudo apt install nginx` |
| Run a web server | `python3 -m http.server 8000` → browse `http://localhost:8000` |
| Permissions & users | `chmod`, `sudo`, `/etc/passwd` |
| Bash scripting | write `deploy.sh`, run `bash -x deploy.sh` |
| Networking tools | `curl`, `dig`, `ss -tulpn` |
| Containers | install Docker Desktop with the WSL2 backend → `docker run hello-world` |

> 🎯 **Pro tip:** whatever you break in WSL can be wiped and reinstalled in 5 minutes (`wsl --unregister`). That's exactly why WSL is the safest place to learn Linux aggressively.

---

*Happy hacking — see you in the cloud! ☁️🐧*
