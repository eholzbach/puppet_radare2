# puppet_radare2

Quick configuration of a debian 7 x86_64 reverse engineering box. Handy for building a remote host at a non-cloud type provider without custom iso's or snapshotting.

Fork repo, edit username in bootstrap.sh and edit params.pp to fit your needs. 
Unfortunately preseed.cfg needs to be hosted on a site that doesn't support https. At install screen hit escape:

```
auto url=http://yourlamedomain.com/preseed.cfg
```
 
Root pass is radare2. You will be forced to change on first login. Edit username for the following: 

```
wget https://raw.githubusercontent.com/eholzbach/puppet_radare2/master/bootstrap.sh \
; sh bootstrap.sh
```

Root sshd login and password authentication will be disabled.
