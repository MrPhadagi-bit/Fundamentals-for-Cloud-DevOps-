# 🏋️ Lab 04 — Users and Groups

**Prereqs:** [Chapter 04](../04-users-and-groups.md) · **Time:** ~20 min · **Needs:** sudo access

## Objective
Create users, manage groups, and understand `sudo`.

## Tasks

1. **Meet your system**
   - Run `id` and `cat /etc/passwd | tail -5`.
   - How many real human users (UID ≥ 1000) are on this system?

2. **Create a user**
   - Create user `dev1` with a password.
   - Switch to them: `su - dev1`. Run `pwd` — where do you land?
   - Try `cat /etc/shadow` as dev1. Why does it fail?

3. **Group power**
   - Create group `webteam`.
   - Add `dev1` to it with `sudo usermod -aG webteam dev1` (run from your own user — exit dev1 first).
   - Verify: `groups dev1`.

4. **Shared workspace**
   - Create `/var/webteam` owned by group `webteam`, permissions `770`.
   - As dev1, create a file in it. Can you? (Hint: you may need `newgrp` or re-login to activate group membership.)

5. **Cleanup**
   - As dev1, run `sudo ls /root`. What happens? (dev1 isn't in the sudo group.)
   - Back as your user, remove `dev1` and the `webteam` group.

## ✅ Check Yourself
- Why is `-a` critical in `usermod -aG`?
- What does `sudo` add compared to running as root directly?
- Why did group membership need re-activation?

## Solutions
<details><summary>Click to reveal</summary>

```bash
# 2
sudo adduser dev1
su - dev1
pwd                 # /home/dev1 — the user's home
cat /etc/shadow     # fails: only root can read password hashes

# 3
sudo groupadd webteam
sudo usermod -aG webteam dev1
groups dev1

# 4
sudo mkdir /var/webteam
sudo chgrp webteam /var/webteam
sudo chmod 770 /var/webteam
su - dev1
newgrp webteam              # activate new group without re-login
touch /var/webteam/test.txt # works!
exit; exit

# 5
sudo deluser dev1
sudo groupdel webteam
sudo rm -r /var/webteam
```
</details>
