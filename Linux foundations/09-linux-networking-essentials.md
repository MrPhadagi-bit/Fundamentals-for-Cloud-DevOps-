# 09. Linux Networking Essentials: Know Your Connections

> 🎯 **By the end of this chapter you will be able to:**
> - Inspect your machine's IP addresses, interfaces, and routing table
> - Test connectivity and diagnose DNS problems
> - Find which services are listening on which ports
> - Manage firewall rules with UFW to safely expose an application

---

Networking is the heart of DevOps. Whether you're:

- Deploying a web server,
- Debugging app latency,
- Exposing services via Kubernetes,
- Or connecting containers…

…you must understand how Linux handles networking. This chapter gives you the essentials to survive and thrive in DevOps environments.

> 💡 **Remember:** In Linux, *everything is a file* — even networks! Interfaces appear under `/sys/class/net/`, and network state is exposed through files like `/proc/net/tcp`.

---

## Step 1 — How Linux Sees Networking

Before typing commands, it helps to know the core concepts. Here's how the system understands its own connectivity:

| Concept | What It Does | Command Example |
|---|---|---|
| **IP Address** | Identifies your machine on a network | `ip a` or `ifconfig` |
| **Hostname** | Your system's network name | `hostname` |
| **DNS** | Converts domain names to IPs | `/etc/resolv.conf`, `nslookup` |
| **Routing Table** | Defines paths for outgoing packets | `ip route` |
| **Network Interfaces** | Physical or virtual devices (`eth0`, `lo`) | `ip link`, `ifconfig` |

> 💡 Interface names like `eth0` (older naming) or `ens33`/`enp0s3` (predictable naming) are just labels — what matters is each has a unique IP address.

---

## Step 2 — Check Your IP Address

```bash
ip a
```

Shows all interfaces and their assigned IPs.

**Look for:**
- `eth0` or `ens33` — that's usually your network interface (e.g. `192.168.1.100`)
- `127.0.0.1` — your **localhost** (the machine talking to itself)

**Alternative (older tool, may need install):**

```bash
ifconfig
```

> ⚠️ `ifconfig` is deprecated on many modern distros. Prefer `ip` — it's faster and shows more detail (including interface *state*: `UP`/`DOWN`).

---

## Step 3 — Test Connectivity

**Ping a website:**

```bash
ping google.com
```

**Ping an IP address:**

```bash
ping 8.8.8.8
```

> 🧠 **Diagnostic trick:** If DNS is down, pinging domain names fails but pinging IPs may still work. That's how you know the problem is name resolution, not connectivity.

**Check DNS resolution:**

```bash
nslookup google.com
```

This queries your configured DNS server and shows which IP it returns. Your DNS servers are listed in `/etc/resolv.conf`.

**Trace a route:**

```bash
traceroute google.com
```

This shows **every hop** your request takes to reach its destination — useful for spotting slow points in the network path.

> 🛠️ If `traceroute` isn't installed: `sudo apt install traceroute`

---

## Step 4 — Open Ports and Listening Services

What services are listening for connections right now?

```bash
ss -tuln
```

**Flag breakdown:**

| Flag | Meaning |
|---|---|
| `-t` | TCP connections |
| `-u` | UDP connections |
| `-l` | **L**istening (services waiting for connections) |
| `-n` | **N**umeric — don't resolve hostnames (much faster) |

**Example output:**

```
State      Recv-Q Send-Q Local Address:Port  Peer Address:Port
LISTEN     0      128    0.0.0.0:80          0.0.0.0:*
```

That means something (probably **Nginx** or **Apache**) is listening on port 80 from any address (`0.0.0.0` = all interfaces).

**Want to see *who's* using port 80?**

```bash
sudo lsof -i :80
```

This reveals the process name and PID bound to that port — invaluable when port conflicts occur.

---

## Step 5 — Firewall: Managing Access

Most Linux distros use **UFW** (*Uncomplicated Firewall*) on top of `iptables`.

**Enable the firewall:**

```bash
sudo ufw enable
```

**Allow traffic to port 22 (SSH) — *always do this first* or you'll lock yourself out!**

```bash
sudo ufw allow 22
```

**Deny traffic to port 80:**

```bash
sudo ufw deny 80
```

**View current rules:**

```bash
sudo ufw status
```

> ⚠️ **Classic trap:** enabling UFW *before* allowing port 22 cuts off your SSH session. Rule of thumb: `sudo ufw allow 22` **first**, `sudo ufw enable` **second**.

---

## Step 6 — Real-World Scenario: Exposing a Web App

Let's say you deploy a Node.js app on port 3000. Here's the complete checklist:

**1. Run the app:**

```bash
node app.js
```

**2. Ensure it's listening:**

```bash
ss -tuln | grep 3000
```

You should see a `LISTEN` line for port 3000. If nothing shows, the app didn't start correctly — check its logs.

**3. Allow external access (if needed):**

```bash
sudo ufw allow 3000
```

**4. Test locally:**

```bash
curl http://localhost:3000
```

`curl` is your best friend here — it makes an HTTP request and prints the response.

**5. Test from another machine (replace with your server's IP):**

```bash
curl http://192.168.1.100:3000
```

**Done!** You just exposed a local app over the network. This exact workflow applies whether the app runs on a VM, a cloud instance, or inside a Docker container with published ports.

> 🧠 **If local works but remote fails**, the problem is almost always the firewall (`sudo ufw status`) or the app binding to `127.0.0.1` instead of `0.0.0.0`.

---

## ⚠️ Common Pitfalls

| Mistake | Fix |
|---|---|
| `ifconfig: command not found` | Use `ip a` instead, or `sudo apt install net-tools` |
| Locked out of SSH after enabling UFW | Allow 22 **before** enabling: `sudo ufw allow 22` |
| App works locally, unreachable remotely | Check `sudo ufw status` and confirm the app binds to `0.0.0.0`, not `127.0.0.1` |
| Domain pings fail, IP pings work | DNS issue — check `/etc/resolv.conf` and `nslookup` |
| "Address already in use" on startup | Find the process: `sudo lsof -i :<port>` → kill or reconfigure it |
| Forgot `sudo` for `lsof` | Port info needs root: use `sudo lsof -i :80` |

---

## ✅ Try It Yourself

1. Run `ip a` and identify your machine's IP address and loopback interface.
2. Ping `8.8.8.8`, then ping `google.com`. Note the difference in output.
3. Use `nslookup` on a domain you own (or your company's). What DNS server answered?
4. Run `ss -tuln` and list every port currently listening on your system.
5. Start any simple HTTP server (`python3 -m http.server 8000`), verify it's listening with `ss`, then test it with `curl http://localhost:8000`.

➡️ Review the [Cheatsheet](../cheatsheet.md), then continue to [Chapter 10 — Crontab: Scheduling Repetitive Tasks](../10-crontab-scheduling-repetitive-tasks.md).
