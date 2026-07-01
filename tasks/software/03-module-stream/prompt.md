BONUS task.

Application Streams let you pick a specific version of a piece of software.
Enable the module stream:

  postgresql:15

so that the version 15 stream of the postgresql module is selected. You do
NOT need to install any packages from it — only enabling the stream is
graded.

The enabled stream is recorded persistently under /etc/dnf/modules.d/ and
survives a reboot.

Note: this requires a repository that carries module metadata (the Rocky
AppStream repo). If no such repo is configured, the task cannot be
completed on this machine.
