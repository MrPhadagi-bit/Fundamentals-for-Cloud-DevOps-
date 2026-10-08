# 🏋️ Lab 03 — Files and Directories

**Prereqs:** [Chapter 03](../03-files-and-directories.md) · **Time:** ~20 min

## Objective
Create, edit, view, move, copy, and delete files and directories safely.

## Tasks

1. **Build a tree**
   - Create `~/labs/ch03/website/{css,js,img}` in ONE command (hint: `-p`).

2. **Create & edit**
   - Create `index.html` inside `website/` and write a valid HTML skeleton with nano.
   - Create `style.css` in `css/` with one rule.

3. **Backup habit**
   - Copy `index.html` to `index.html.bak` in the same directory.
   - Verify with `ls -l website/`.

4. **Move & rename**
   - Create `~/labs/ch03/draft.txt`, write a line in it.
   - Move it into `website/` AND rename it to `content.txt` in one command.

5. **Viewing skills**
   - Add 15+ lines to `content.txt` (repeated lines are fine).
   - Show only the first 3 lines (`head -n 3`).
   - Show only the last 3 lines (`tail -n 3`).
   - Open with `less` and navigate with arrows/spacebar, quit with `q`.

6. **Safe deletion**
   - `ls` the exact path, then delete `website/img` and `draft`'s old name.
   - Try `rm -ri website/` and answer the prompts. What does `-i` change?

## ✅ Check Yourself
- Which flag makes `mkdir` create parents? Which makes `rm` ask first?
- How do you copy a directory?
- Why do we back up before editing?

## Solutions
<details><summary>Click to reveal</summary>

```bash
# 1
mkdir -p ~/labs/ch03/website/{css,js,img}

# 2
nano ~/labs/ch03/website/index.html
nano ~/labs/ch03/website/css/style.css

# 3
cp ~/labs/ch03/website/index.html ~/labs/ch03/website/index.html.bak

# 4
echo "hello" > ~/labs/ch03/draft.txt
mv ~/labs/ch03/draft.txt ~/labs/ch03/website/content.txt

# 5
head -n 3 ~/labs/ch03/website/content.txt
tail -n 3 ~/labs/ch03/website/content.txt
less ~/labs/ch03/website/content.txt

# 6
ls ~/labs/ch03/website/
rm -r ~/labs/ch03/website/img
rm -ri ~/labs/ch03/website/   # -i asks for confirmation per file
```
</details>
