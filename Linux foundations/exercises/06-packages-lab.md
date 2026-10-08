#  Lab 06 — Installing Software

**Prereqs:** [Chapter 06](../06-installing-software.md) · **Time:** ~20 min · **Needs:** sudo access

## Objective
Install, inspect, update, and remove software with APT.

## Tasks

1. **Search & inspect**
   - Find a text editor: `apt search editor | less` (scroll, quit with `q`).
   - Inspect `htop`: `apt show htop`. What's its installed size?

2. **Install**
   - `sudo apt update` first — always.
   - Install `htop` and run it. Identify the process using the most CPU. Quit with `q`.

3. **Track what's installed**
   - `dpkg -l | grep htop` — confirm it's registered.
   - `dpkg -l | wc -l` — how many packages are on your system?

4. **Update cycle**
   - Run `sudo apt update && sudo apt upgrade -y`.
   - What's the difference between the two commands? (Explain aloud.)

5. **Remove — two ways**
   - Remove htop with `remove`. Check: `ls /etc/htop*` (if config existed, it survives).
   - Purge it: `sudo apt purge htop`.
   - Finish with `sudo apt autoremove` and `sudo apt clean`.

6. **(Bonus) Repo caution**
   - Look at `/etc/apt/sources.list.d/`. What third-party sources exist on your system?

##  Check Yourself
- Why run `apt update` before `install`?
- `remove` vs `purge` — when does each make sense?
- What cleans up orphaned dependencies?

## Solutions
<details><summary>Click to reveal</summary>

```bash
# 2
sudo apt update
sudo apt install htop
htop

# 3
dpkg -l | grep htop
dpkg -l | wc -l

# 4
# update = refresh the package index; upgrade = install newer versions

# 5
sudo apt remove htop
sudo apt purge htop
sudo apt autoremove
sudo apt clean

# 6
ls /etc/apt/sources.list.d/
```
</details>
