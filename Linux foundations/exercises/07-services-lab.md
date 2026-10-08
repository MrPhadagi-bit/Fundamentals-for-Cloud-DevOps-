#  Lab 07 — Services and Processes

**Prereqs:** [Chapter 07](../07-services-and-processes.md) · **Time:** ~25 min · **Needs:** sudo access

## Objective
Manage services with systemd and diagnose problems from logs.

## Tasks

1. **Service census**
   - List running services: `systemctl list-units --type=service --state=running | less`
   - Pick one (e.g., `ssh`, `cron`, `dbus`) and check: `sudo systemctl status <name>`.
   - Is it `active`? Is it `enabled` (starts on boot)?

2. **Start/stop cycle**
   - Choose a safe service like `cron`.
   - Stop it → verify status → start it → enable it → verify with `systemctl is-enabled cron`.

3. **Kill a process**
   - Run `sleep 500 &` (a background process).
   - Find its PID: `ps aux | grep sleep`.
   - Kill it: `kill <PID>`. Verify it's gone.

4. **The crash investigation (roleplay)**
   - Create a broken service: copy the config below to `/etc/systemd/system/fakeapp.service`, then:
     ```bash
     sudo systemctl daemon-reload
     sudo systemctl start fakeapp
     sudo systemctl status fakeapp      # failed?
     journalctl -u fakeapp -e           # what's the error?
     ```
   - The log shows the command `/bin/false` always fails. Fix the service to run `/bin/sleep 3600` instead, `daemon-reload`, restart, and confirm it's `active (running)`.

   ```ini
   [Unit]
   Description=Fake App

   [Service]
   ExecStart=/bin/false

   [Install]
   WantedBy=multi-user.target
   ```

5. **Cleanup**
   - `sudo systemctl stop fakeapp && sudo systemctl disable fakeapp`
   - Delete the unit file, then `sudo systemctl daemon-reload`.

##  Check Yourself
- `start` vs `enable` — which survives a reboot?
- Where do you look first when a service fails?
- Why prefer `reload` over `restart` when possible?

## Solutions
<details><summary>Click to reveal</summary>

```bash
# 4
sudo sed -i 's|/bin/false|/bin/sleep 3600|' /etc/systemd/system/fakeapp.service
sudo systemctl daemon-reload
sudo systemctl restart fakeapp
sudo systemctl status fakeapp        # active (running)
```

</details>
