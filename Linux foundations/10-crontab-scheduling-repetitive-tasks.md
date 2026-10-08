# 10. Crontab: Scheduling Repetitive Tasks

> 🎯 **By the end of this chapter you will be able to:**
> - Read and write crontab expressions for any schedule
> - Create, view, and remove your own crontab
> - Automate backups and cleanup jobs like a real DevOps engineer
> - Debug cron jobs when they silently fail

---

In the world of DevOps, automation isn't just about running tasks — it's about running them **at the right time** without human intervention.

Want to:

- Back up logs every night?
- Run health checks every 5 minutes?
- Clean up temp files weekly?

You don't need a fancy scheduler. Just use **cron** — the built-in job scheduler for Unix/Linux.

---

## Step 1 — What Is Crontab?

- **Cron** is the background daemon (`cron`d) that runs scheduled tasks.
- **Crontab** (short for "**cron** **tab**le") is the file where you define those tasks.
- Every user (even root) can have their **own** crontab.

Check that cron is running:

```bash
systemctl status cron        # Ubuntu/Debian
systemctl status crond       # CentOS/RHEL
```

---

## Step 2 — Crontab Syntax

Each line in a crontab follows this format:

```
* * * * * command_to_run
| | | | |
| | | | +----- Day of the week (0 - 6) (Sunday = 0)
| | | +------- Month (1 - 12)
| | +--------- Day of the month (1 - 31)
| +----------- Hour (0 - 23)
+------------- Minute (0 - 59)
```

**Examples:**

| Schedule | Crontab Expression |
|---|---|
| Every minute | `* * * * *` |
| Every hour | `0 * * * *` |
| Every day at 2:00 AM | `0 2 * * *` |
| Every Monday at 5:30 PM | `30 17 * * 1` |
| Every Sunday at midnight | `0 0 * * 0` |
| Every 5 minutes | `*/5 * * * *` |
| 1st of every month at noon | `0 12 1 * *` |

> 🧠 Read the expression aloud field-by-field: `30 17 * * 1` = "at minute 30, hour 17, any day of month, any month, day-of-week 1 (Monday)".

---

## Step 3 — Creating and Editing a Crontab

**To edit your crontab:**

```bash
crontab -e
```

Choose a text editor (if prompted), then add your scheduled commands. Save and exit — cron picks up the changes automatically.

**To view your crontab:**

```bash
crontab -l
```

**To remove your crontab (all jobs!):**

```bash
crontab -r
```

> ⚠️ `crontab -r` deletes *every* job without confirmation. Prefer commenting out lines in `crontab -e` instead, so you can restore them later.

**To edit another user's (or root's) crontab:**

```bash
sudo crontab -e -u username
```

---

## Step 4 — Pro Tip: Use Full Paths

When using cron, **always use full paths** to files and commands, because cron doesn't load your normal shell environment (no `~/.bashrc`, no custom `PATH`).

For example, instead of:

```
python script.py          # ❌ cron may not find "python"
```

Use:

```
/usr/bin/python3 /home/ubuntu/scripts/backup.py   # ✅ full paths everywhere
```

**Find full paths with:**

```bash
which python3
which node
which bash
```

> 💡 A very common beginner failure: the command works perfectly in your terminal but silently does nothing in cron — because cron's `PATH` is minimal. Full paths fix this.

---

## Step 5 — Real-World Example: Log Backup Script

Let's say you want to back up logs every night at 11 PM.

**1. Create a script** (`/home/ubuntu/scripts/log_backup.sh`):

```bash
#!/bin/bash
tar -czf /backups/logs_$(date +\%F).tar.gz /var/log
```

> ⚠️ Notice the `\%` — inside crontab, `%` is a special character (it means "newline"), so it **must be escaped** as `\%`. In the script itself it's fine either way.

**2. Make it executable** (Chapter 08!):

```bash
chmod +x /home/ubuntu/scripts/log_backup.sh
```

**3. Add it to your crontab:**

```bash
crontab -e
```

Add this line:

```
0 23 * * * /home/ubuntu/scripts/log_backup.sh >> /var/log/cronlog.log 2>&1
```

**What it does:**
- Runs at **11:00 PM every day** (`0 23 * * *`)
- `>> /var/log/cronlog.log` — appends output to a log file
- `2>&1` — redirects errors (`stderr`) to the same log (so failures aren't invisible)

---

## Step 6 — Bonus Example: Automate Temp File Cleanup

```
0 2 * * * find /tmp -type f -mtime +7 -delete
```

Deletes files older than 7 days in `/tmp` every day at 2 AM.

**Breakdown:**
- `find /tmp` — search in `/tmp`
- `-type f` — files only (not directories)
- `-mtime +7` — modified more than 7 days ago
- `-delete` — remove them

> ⚠️ Be careful with `-delete` in cron — a typo in the path can remove the wrong things. Test the `find` command *without* `-delete` first and inspect the list.

---

## Step 7 — Debugging Cron Jobs

Cron failures are famously silent. Here's your debugging checklist:

**1. Log everything:**

Append `>> /path/to/logfile 2>&1` to every job. No exceptions.

**2. Check the cron logs:**

```bash
grep CRON /var/log/syslog      # Ubuntu/Debian
grep CRON /var/log/cron        # CentOS/RHEL
```

You'll see when each job ran and whether the command was executed.

**3. Test the exact command in your terminal first** — including the full paths, exactly as cron would run it:

```bash
env -i /usr/bin/python3 /home/ubuntu/scripts/backup.py
```

`env -i` runs the command with an empty environment — mimicking cron's bare environment. If it fails here, it will fail in cron.

**4. Common failure causes:**

| Symptom | Likely Cause |
|---|---|
| Job runs, nothing happens | Relative paths or missing `PATH` — use full paths |
| `%` in date formats broke things | Escape it: `\%F` |
| Script works in shell, not in cron | Cron uses `sh`-style environment; test with `env -i` |
| No log output at all | Job never ran — check `grep CRON /var/log/syslog` |

---

## ⚠️ Common Pitfalls

| Mistake | Fix |
|---|---|
| Using relative paths (`script.py`) | Use full paths: `/usr/bin/python3 /home/ubuntu/scripts/script.py` |
| Unescaped `%` in crontab | Write `\%F` instead of `%F` |
| Job fails silently | Always append `>> /var/log/myjob.log 2>&1` |
| Script not executable | `chmod +x script.sh` |
| `crontab -r` wiped everything | Comment lines out instead; keep a backup (`crontab -l > crontab.backup`) |
| Wrong day-of-week numbering | `0` and `7` are both Sunday; Monday is `1` |

---

## ✅ Try It Yourself

1. Run `crontab -e` and add a job that appends the current date to `~/cron_test.log` every minute (`* * * * *`). Watch the file fill up.
2. Write a script that copies `/etc/hostname` into `~/backups/` with a timestamp, and schedule it every day at 6 AM.
3. Schedule a cleanup job that deletes files in `~/tmp_downloads/` older than 3 days, every Sunday at 3 AM.
4. Deliberately break a job (use a relative path), then find the evidence in `grep CRON /var/log/syslog` and your log file. Fix it.

➡️ Review the [Cheatsheet](../cheatsheet.md), then continue to [Chapter 11 — Monitoring Basics: Watching Your System's Health](../11-monitoring-basics.md).
