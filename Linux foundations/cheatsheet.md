# 📌 Linux DevOps Cheatsheet

One page with every essential command from the bootcamp. Bookmark it.

---

## 🗂️ Filesystem & Navigation

```bash
pwd                 # where am I?
ls -l               # list with details
ls -a               # include hidden files
cd /path            # go to absolute path
cd folder           # go to relative path
cd ..               # up one level
cd ~ / cd           # home directory
cd -                # previous directory
```

**Key directories:** `/etc` configs · `/var/log` logs · `/home` users · `/usr` software · `/tmp` temp files

## 📝 Files & Directories

```bash
mkdir dir                  # create directory
mkdir -p a/b/c             # create nested directories
touch file.txt             # create empty file
nano file.txt              # edit (Ctrl+O save, Ctrl+X exit)
cat file.txt               # show whole file
less file.txt              # scrollable view (q to quit)
head / tail file.txt       # first/last 10 lines
tail -f /var/log/syslog    # live log stream (Ctrl+C to stop)
mv old new                 # rename / move
cp -r src dst              # copy (recursively)
rm file / rm -r dir        # delete (permanent!)
```

## 👥 Users & Groups

```bash
whoami / id                # who am I?
cat /etc/passwd            # list users
sudo adduser john          # create user
su - john                  # switch user
groups john                # user's groups
sudo usermod -aG docker john   # add to group (keep -a!)
sudo groupadd devs         # create group
sudo <cmd>                 # run as root
sudo !!                    # re-run last command with sudo
```

## 🔐 Permissions

```bash
ls -l                      # view permissions
chmod 755 script.sh        # rwxr-xr-x (owner full, rest rx)
chmod 644 file.txt         # rw-r--r-- (config/static files)
chmod 600 ~/.ssh/id_rsa    # private key — owner only
chmod +x script.sh         # make executable
chmod -R 755 dir/          # recursive
sudo chown user:group file # change owner
sudo chown -R www-data:www-data /var/www/
```

**Numbers:** r=4, w=2, x=1 → `rwx`=7, `rw-`=6, `r-x`=5, `r--`=4
**String:** `-rwxr-x---` → `-` file type, `rwx` owner, `r-x` group, `---` others

## 📦 Packages (APT)

```bash
sudo apt update            # refresh package list
sudo apt install nginx     # install
sudo apt upgrade           # upgrade all packages
sudo apt remove nginx      # remove (keep config)
sudo apt purge nginx       # remove + config
sudo apt autoremove        # clean orphaned deps
apt search / apt show pkg  # find / inspect
dpkg -l | grep pkg         # is it installed?
```

## ⚙️ Services & Processes

```bash
ps aux | grep nginx        # find a process
top / htop                 # live process view
kill <PID>                 # stop (SIGTERM)
kill -9 <PID>              # force stop (last resort)

sudo systemctl start|stop|restart|reload <svc>
sudo systemctl status <svc>        # health + recent logs
sudo systemctl enable <svc>        # start on boot
sudo systemctl enable --now <svc>  # enable + start

journalctl -u <svc>                # service logs
journalctl -u <svc> -f             # follow live
journalctl -u <svc> --since today  # today's logs
```

## 🤖 Bash Scripting

```bash
#!/bin/bash                # shebang — line 1 always
chmod +x script.sh && ./script.sh

name="value"               # variable (no spaces!)
echo "$name"               # use variable
$(command)                 # capture output

if [ -f file.txt ]; then ... fi
for f in *.log; do echo "$f"; done

set -e                     # exit on first failure
cmd || { echo "failed"; exit 1; }
exit 0 / exit 1            # success / failure
```

---

## ⏱️ 60-Second Troubleshooting Flow

1. **"Permission denied"** → `ls -l` → wrong perms? `chmod`. Wrong owner? `sudo chown`.
2. **"Command not found"** → not installed? `sudo apt install`. Typo? Use Tab.
3. **"403 Forbidden"** (web) → `sudo chown -R www-data:www-data /var/www/app && sudo chmod -R 755 /var/www/app`
4. **Service down** → `sudo systemctl status <svc>` → `journalctl -u <svc> -e`
5. **Forgot sudo** → `sudo !!`
6. **Disk full** → `df -h` → `du -sh /*` to find the culprit

---

[← Back to README](README.md)
