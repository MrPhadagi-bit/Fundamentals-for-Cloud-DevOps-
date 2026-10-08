# 🏋️ Lab 02 — The Terminal

**Prereqs:** [Chapter 02](../02-the-terminal.md) · **Time:** ~15 min

## Objective
Use core terminal commands, help pages, and history efficiently.

## Tasks

1. **Help yourself**
   - Run `man ls` and find what `-t` does. Quit with `q`.
   - Compare with `ls --help`.

2. **History power**
   - Run 3 different commands (e.g., `pwd`, `whoami`, `hostname`).
   - Press `Ctrl+R`, type `hos`, and re-run the match.
   - Run `history | grep nano` — what does it show?

3. **The sudo save**
   - Run `apt install sl` **without** sudo. (It fails.)
   - Use `sudo !!` to redo it properly. (Install `sl` — a fun surprise, quit with `q`.)

4. **Editor warmup**
   - `cd ~/labs/ch01` (create if missing) and open `notes.txt` in nano.
   - Write two lines, save with `Ctrl+O`, exit with `Ctrl+X`.
   - Print it back with `cat`.

5. **Detail reading**
   - Run `ls -l ~/labs/ch01/notes.txt`.
   - What are the file's size, date, and owner?

## ✅ Check Yourself
- How do you search for a past command without scrolling?
- What does `cd -` do?
- How do you safely re-run the last command with sudo?

## Solutions
<details><summary>Click to reveal</summary>

```bash
# 1
man ls          # -t: sort by modification time, newest first

# 3
apt install sl  # fails: Permission denied
sudo !!         # runs: sudo apt install sl
sl              # a steam locomotive drives across your terminal

# 4
cd ~/labs/ch01 || mkdir -p ~/labs/ch01 && cd ~/labs/ch01
nano notes.txt
cat notes.txt
```
</details>
