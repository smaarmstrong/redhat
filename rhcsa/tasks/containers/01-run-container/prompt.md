Run a detached container that keeps running in the background.

Requirements:

  • Container name:   web
  • State:            running (detached)
  • Long-running:     it must not exit — run `sleep infinity` as its command
  • Published port:   host port 8080 -> container port 80

Any small image is fine (e.g. registry.access.redhat.com/ubi9/ubi or
docker.io/library/alpine).

NOTE: This is a bonus RHEL8-era container task, not part of the core RHEL9
EX200 objectives. It requires the `podman` command, and pulling an image needs
access to a container registry (internet). setup.sh best-effort installs
container-tools and pre-pulls a tiny image; if that is unavailable the grader
will note it and this task cannot be completed offline.

NOTE: In production a web container is usually run rootless (as a normal user).
Here the container is run and graded as root so the grader (which runs as root)
can inspect it. `podman run -d --name web -p 8080:80 <image> sleep infinity`.
