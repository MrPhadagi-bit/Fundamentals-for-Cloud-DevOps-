# 07. Services and Processes: Keeping Things Running

>  **By the end of this chapter you will be able to:**
> - Distinguish a process from a service
> - Manage any service with `systemctl` (start/stop/restart/enable/status)
> - Make services survive reboots and crashes
> - Diagnose a crashed service using its status and logs

---

## Step 1 — Process vs Service

| Term | What it is | Example |
|---|---|---|
| **Process** | Any individual running task | Your Python script, a `sleep` command |
| **Service** | A process **managed by systemd** — with start/stop rules, restart policies, and logging | Nginx, Docker, PostgreSQL |

When you need a program to **start on boot**, **restart automatically after a crash**, and be **managed uniformly**, you turn it into a service. On virtually all modern Linux systems, the manager responsible for this is **systemd**, and its control tool is `systemctl`.

> Mastering services = controlling what's running on your system. That's DevOps gold.

## Step 2 — Seeing Processes

```bash
ps aux              # snapshot of ALL processes
top                 # live, updating view
htop                # enhanced top (sudo apt install htop)
ps aux | grep nginx # find a specific process
```

**Reading `ps aux` output:**

```
USER   PID  %CPU %MEM  COMMAND
www-data 812  0.1  0.4  nginx: worker process
```

- **PID** — Process ID, the process's unique number
- **USER** — which user owns it (here: the web server user)

## Step 3 — Killing Processes

```bash
kill <PID>          # polite stop (SIGTERM — "please exit")
kill -9 <PID>       # force kill (SIGKILL — no cleanup possible)
```

>  Reach for `-9` only when the process ignores normal termination. It can't clean up temp files or close connections gracefully.

**Kill by name:**
```bash
killall nginx
pkill -f myscript.py
```

## Step 4 — Managing Services with `systemctl`

The six verbs you'll use daily:

| Action | Command |
|---|---|
| Start | `sudo systemctl start nginx` |
| Stop | `sudo systemctl stop nginx` |
| Restart | `sudo systemctl restart nginx` |
| Reload config (no downtime) | `sudo systemctl reload nginx` |
| Check status | `sudo systemctl status nginx` |
| Enable at boot | `sudo systemctl enable nginx` |
| Disable at boot | `sudo systemctl disable nginx` |

**Example — checking Docker:**
```bash
sudo systemctl status docker
```

The status output tells you everything at a glance:

```
● docker.service - Docker Application Container Engine
   Active: active (running) since Sat 2026-10-03 10:12:00 CEST
   ...
```

- `active (running)` = healthy 
- `failed` = crashed — scroll down for the last log lines, right in the same output
- `inactive (dead)` = stopped

## Step 5 — Enable = Survive Reboots

**`start` vs `enable` — the crucial difference:**

```bash
sudo systemctl start nginx     # runs NOW (until reboot/crash)
sudo systemctl enable nginx    # starts automatically on EVERY boot
```

Production servers reboot after updates, power events, crashes. A service that is started but not enabled will silently stay down after the next reboot. **Always do both for production services:**

```bash
sudo systemctl enable --now nginx    # enable + start in one command
```

## Step 6 — Reading Logs with `journalctl`

systemd captures service output in the journal:

```bash
journalctl -u nginx                # all logs for the nginx service
journalctl -u nginx -e             # jump to the END (latest)
journalctl -u nginx -f             # follow live (like tail -f)
journalctl -u nginx --since today  # since midnight
journalctl -u nginx --since "1 hour ago"
journalctl -p err                  # only errors (all services)
```

The `-u` flag means **unit** — systemd's name for a service (e.g., `nginx`, `docker`, `ssh`).

## Step 7 — Real-World Example: A Crashed Web Server

Your site is down. The playbook:

```bash
# 1. Check status — is it running? what's the error?
sudo systemctl status apache2

# 2. Restart it
sudo systemctl restart apache2

# 3. Verify it's healthy again
sudo systemctl status apache2

# 4. Read today's logs to find the root cause
journalctl -u apache2 --since today
```

Common root causes you'll see in logs: bad config syntax (`apache2ctl configtest` helps), port already in use, missing files, permission errors (Chapter 05!).

## Step 8 — When a Service Hangs

Sometimes `stop` doesn't work:

```bash
sudo systemctl stop nginx
sudo killall nginx            # harder stop
# Last resort:
sudo reboot
```

And if a service keeps crash-looping, check *why* before restarting blindly — the answer is almost always in `journalctl -u <service> -e`.

---

##  Common Pitfalls

| Mistake | Fix |
|---|---|
| Service "works" but dies after reboot | You forgot `systemctl enable` |
| Editing config without reloading | Use `reload` (graceful) or `restart` |
| Restarting blindly in a crash loop | Read `journalctl -u <svc> -e` first |
| `kill -9` as first instinct | Try plain `kill` first; `-9` skips cleanup |
| Looking in the wrong log file | `journalctl -u` beats guessing paths |

---

##  Try It Yourself

1. Check the status of `ssh` (or `cron`): is it active? enabled?
2. Stop `cron` with `systemctl`, verify with `status`, then `enable --now` it again.
3. Run `journalctl --since today -p err` — any errors on your system today?
4. Start `htop` in one terminal, find its PID in another with `ps aux | grep htop`, then kill it.
5. Write the full sequence of commands to recover a crashed `docker` service and investigate why it failed.

➡️ Continue to [Chapter 08: Bash Scripting](../08-bash-scripting.md) — or practice with the [Services Lab](../exercises/07-services-lab.md).
