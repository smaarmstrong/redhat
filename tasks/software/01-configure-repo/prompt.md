Create a yum/dnf repository definition file:

  /etc/yum.repos.d/local.repo

It must define a repository with:

  • Repo id:   localdvd        (the [localdvd] section header)
  • Name:      any descriptive name
  • baseurl:   file:///mnt/dvd/BaseOS
  • enabled:   1
  • gpgcheck:  0

The baseurl does not need to actually exist for this task — only the
repository definition file is graded. It persists as a normal file.
