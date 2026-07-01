A local user account named `operator` already exists on this system.

Starting as root, switch to the `operator` account (for example with
`su - operator`) and, while acting as that user, create the file:

  /home/operator/created-by-me.txt

The file may be empty. What matters is that it ends up in operator's home
directory and is owned by `operator` — which happens naturally when operator
creates it.

Any method that results in operator owning the file will pass.
