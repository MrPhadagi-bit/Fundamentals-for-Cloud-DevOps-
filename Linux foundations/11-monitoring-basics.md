# 11. Monitoring Basics: Watching Your System's Health

>  **By the end of this chapter you will be able to:**
> - Check live CPU, memory, and process usage with `top`/`htop`
> - Find disk hogs with `df` and `du` before they take a server down
> - Watch network usage and identify bandwidth consumers
> - Troubleshoot a slow server methodically in minutes, not hours

---

Whether you're managing a local VM, a bare-metal server, or a Kubernetes node — your system is only as reliable as your ability to monitor it.

In real-world DevOps, it's not enough to deploy an app — you need to know:

- Is it consuming too much memory?
- Is disk space running low?
- Is the CPU being maxed out?
- Which process is causing issues?

Linux provides built-in tools that give you **real-time and historical** system health insights. Master these before reaching for fancy dashboards.

---

## Step 1 — Check CPU & Memory Usage

**View live system stats:**

```bash
top
```

Shows real-time updates on CPU usage, memory, and running processes. You'll see:

| Column | What It Tells You |
|---|---|
| `%CPU` | How much of the processor is being used |
| `%MEM` | Memory usage per process |
| `COMMAND` | What is using the resources |

**More readable version:**

```bash
htop
```

- Use **arrow keys** to sort by CPU or memory usage
- Press **F9** to kill a process
- Color-coded meters make bottlenecks obvious at a glance

>  If it's not installed:

```bash
sudo apt install htop   # Debian/Ubuntu
sudo yum install htop   # CentOS/RHEL
```

>  In `top`, press `1` to see per-core CPU breakdown, `M` to sort by memory, and `P` to sort by CPU. Press `q` to quit.

---

## Step 2 — Monitor Disk Usage

**Check free space:**

```bash
df -h
```

- `-h`: human-readable (MB, GB)
- Useful to check if `/` or `/home` is almost full

**Example output:**

```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        50G   45G  2.5G  95% /
```

>  Here, you're in trouble — only 5% free. You'd better clean up logs or expand storage *now*, before the disk fills completely (a full root disk breaks services in strange ways).

**Check folder size:**

```bash
du -sh /var/log
```

- `-s`: summary only (don't list every file)
- `-h`: human-readable

Shows how much space logs or a specific folder take.

**To list top disk-consuming directories:**

```bash
du -sh /* | sort -hr | head -10
```

This one-liner ranks the biggest directories under `/` — your first move when `df -h` says the disk is full.

---

## Step 3 — Monitor Network Usage

**Real-time network:**

```bash
iftop
```

This shows which IPs/ports are using your bandwidth, live.

>  To install:

```bash
sudo apt install iftop
```

**Check port usage:**

```bash
netstat -tulnp
```

Shows open ports and listening services.

Or use the more modern, faster replacement:

```bash
ss -tuln
```

> You met `ss -tuln` in [Chapter 09 — Networking Essentials](../09-linux-networking-essentials.md) — monitoring and networking go hand in hand.

---

## Step 4 — Real-World Scenario: Troubleshoot a Slow Server

Imagine your web app is slow. Here's the methodical drill:

**1. Check CPU usage:**

```bash
top
```

→ You find a Python process using 98% CPU.

**2. Kill it:**

```bash
kill -9 <PID>
```

>  `kill -9` (SIGKILL) is the *last resort* — the process can't clean up after itself. Try plain `kill <PID>` (SIGTERM) first; escalate to `-9` only if it ignores you.

**3. Check disk space:**

```bash
df -h
```

→ You see `/var` is full. You find large log files:

```bash
du -sh /var/log/*
```

**4. Clear unnecessary logs:**

```bash
sudo rm /var/log/old-app.log
```

>  Prefer truncating active logs (`sudo truncate -s 0 /var/log/app.log`) instead of deleting them — deleting a file an app still holds open doesn't actually free the space until the app restarts.

**5. Restart the service:**

```bash
sudo systemctl restart nginx
```

**Problem resolved in 5 minutes.** That's DevOps. 

---

## Step 5 — Set Up Alerts (Optional Next Step)

Once you're familiar with the manual tools, level up with automatic monitoring platforms:

- **Nagios** — classic, battle-tested alerting
- **Prometheus + Grafana** — the cloud-native standard; metrics + beautiful dashboards
- **Zabbix** — enterprise-grade monitoring suite
- **Netdata** — real-time, per-second metrics with minimal setup

These tools provide dashboards and alerts when thresholds are breached (e.g., CPU above 90% for 5 minutes, or disk below 10% free) — so you hear about problems from a notification, not from users.

---

##  Common Pitfalls

| Mistake | Fix |
|---|---|
| Killing processes with `kill -9` first | Try plain `kill` (SIGTERM) first; `-9` skips cleanup |
| Deleting a log file that's still open | Use `sudo truncate -s 0 file.log` instead |
| Disk at 100% → services failing mysteriously | Run `df -h`, then `du -sh /* \| sort -hr \| head -10` |
| `top` overwhelming you | Use `htop` — sort with arrow keys, F9 to kill |
| Monitoring only CPU, forgetting disk | Disks fill silently: `df -h` belongs in every health check |
| `du` hanging on huge directories | Add `--max-depth=1` or target specific paths |

---

##  Try It Yourself

1. Run `top`, press `1`, and identify which cores are busiest. Then install and explore `htop`.
2. Run `df -h`. Which mount point has the least free space?
3. Use `du -sh /* | sort -hr | head -10` to find the three biggest directories on your system.
4. Run `ss -tuln` and cross-reference with `htop` — can you spot which process owns port 80/22?
5. Simulate the slow-server drill: find a process, note its PID, check disk with `df -h`, and write down the exact commands you'd use to fix each failure mode.

---

##  Final Thoughts

Congratulations! You now have a solid foundation in:

- Navigating the Linux filesystem
- Understanding file permissions
- Managing users and groups
- Installing software
- Running and monitoring services
- Writing Bash scripts
- Scheduling cron jobs
- Diagnosing networks
- Monitoring system performance

This isn't just theory — **this is how real systems work.**

### You're Not "Too Late" to Learn Linux

Every DevOps expert once googled *"How do I exit Vim?"* 

➡️ Review the [Cheatsheet](../cheatsheet.md) and practice with the [Exercises](../exercises/). You did it — bootcamp complete! 🎉
