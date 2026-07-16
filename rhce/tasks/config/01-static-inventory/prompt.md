Work in /opt/rhce/static-inventory/. Create a static inventory file named
`inventory` that defines:

  • group `webservers` — hosts node1.example.com and node2.example.com
  • group `dbservers`  — host  node3.example.com
  • group `production` — a parent group whose children are webservers and dbservers

You only create the inventory file; the hosts don't need to be reachable.
