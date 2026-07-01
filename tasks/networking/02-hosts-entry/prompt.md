Add a static name-resolution entry to /etc/hosts so that the name

  db.example.com   (with the short alias  db)

resolves to the IP address:

  192.168.55.10

After this, `getent hosts db.example.com` must return 192.168.55.10.
The entry lives in /etc/hosts, so it is persistent by nature.
