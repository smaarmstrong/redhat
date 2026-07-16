Work in /opt/rhce/adhoc-script/. Write an **executable** shell script named
`check.sh` that validates the managed nodes are reachable by running an *ad-hoc*
Ansible command that pings every host in the `managed` group:

    ansible managed -m ping

The script must exit non-zero if the ad-hoc command fails (so it can be used in a
health check). Make the script executable (`chmod +x check.sh`).

Run it from this directory (`./check.sh`); with the managed node being the local
host it should succeed and exit 0.
