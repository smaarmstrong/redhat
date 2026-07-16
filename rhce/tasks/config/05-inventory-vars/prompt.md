Work in /opt/rhce/inventory-vars/. A starter `inventory` file is already present
with a `webservers` group containing the host `node1.example.com`.

Define a group variable `http_port` with the value `8080` for the `webservers`
group by creating a `group_vars/webservers` file (do NOT edit the inventory file).

When done, `ansible-inventory -i inventory --host node1.example.com` should report
`http_port` = `8080` for that host.
