# For whom is this suitable?
- Do you need to perform a security assessment for 10, 20, or more Linux hosts? Then this script can help you out!
- Mostly for whitebox pentests, auditors, sys admins etc. with many linux systems in scope

# What does SudoRulesCollector.sh do?
- It will automatically check sudo rules for every found user, running automatically through every host in scope with SSH
- It will accept every SSH-fingerprint automatically, if the host is unkown
- It will supress users who dont have permissions to run sudo, which will help to keep the output clean and efficient
- It will write all sudo rules for users per host to `sudo-rules.txt`.
- It will write all unreachable hosts to `timeout.txt`.
- It will save your time ;)

# Tweak it your way
- Since there are many (technical) users like `daemon`, `ftp`, etc. on linux systems you dont want to check, you can customize the ignore-list to your own needs 

# Prerequisites
- <ins>sudo permission</ins> on targets
- SSH login enabled on hosts
- `hostlist.txt` with all the hosts you want check in the same path
- Dont forget to set up your SSH configuration for reaching out to the hosts, to something like this. The wildcard will ensure that all hosts are reached in that specific scope

```
Host host-name-wildcard* !*.testenv.of.some.company.com
        User someUser@of.some.company.com
        IdentityFile ~/.ssh/oemer_ed25519
        Hostname %h.testenv.of.some.company.com
        ProxyJump jumphost
```

# Usage and example
run `$ ./SudoRulesCollector.sh`

Output in `sudo-rules.txt`:
```
_______________________________________________

host: HOST01
_______________________________________________
User XXX may run the following commands on HOST01:
    (root) NOPASSWD: /bin/cat /var/log/messages
    (root) NOPASSWD: /usr/sbin/dmidecode
    (root) NOPASSWD: /usr/bin/du

_______________________________________________

host: HOST02
_______________________________________________
User YYY may run the following commands on HOST02:
    (ALL) NOPASSWD: /usr/lib64/nagios/plugins/*, /usr/bin/systemctl, /usr/bin/jstat, /usr/bin/jq

User ZZZ may run the following commands on HOST02:
    (ALL) NOPASSWD: ALL

[...]
```

# Logical flow
<img width="432" height="430" alt="SudoRulesCollector drawio" src="https://github.com/user-attachments/assets/d588368b-c24f-4d39-83bb-26a803a63733" />
