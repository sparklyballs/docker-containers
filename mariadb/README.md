This is a Dockerfile setup for mariadb v5.5 - https://mariadb.org/

To run:

```
docker run -d --name="mariadb" -v /path/to/db:/db -v /etc/localtime:/etc/localtime:ro -p 3306:3306 needo/mariadb
```

FIRST TIME USERS
---

A completely empty database will be generated upon first run. You must secure it by creating users and passwords.

RETURNING USERS
---

MAKE A BACKUP OF YOUR ORIGINAL DATABASE FIRST! I AM NOT RESPONSIBLE FOR ANY DATA LOSS

Put your previous mysql or mariadb data directory in /path/to/db/

For example a freshly generated /path/to/db/ looks like...

total 28692
    0 drwx------ 1 mysql  root       170 Jun 24 10:21 ./
    0 drwxrwxrwx 1 nobody users        8 Jun 24 10:18 ../
   16 -rw-rw---- 1 mysql  mysql    16384 Jun 24 10:21 aria_log.00000001
    4 -rw-rw---- 1 mysql  mysql       52 Jun 24 10:21 aria_log_control
 5120 -rw-rw---- 1 mysql  mysql  5242880 Jun 24 10:21 ib_logfile0
 5120 -rw-rw---- 1 mysql  mysql  5242880 Jun 24 10:18 ib_logfile1
18432 -rw-rw---- 1 mysql  mysql 18874368 Jun 24 10:18 ibdata1
    0 drwx------ 1 mysql  root      2094 Jun 24 10:18 mysql/
    0 drwx------ 1 mysql  mysql      868 Jun 24 10:21 performance_schema/
