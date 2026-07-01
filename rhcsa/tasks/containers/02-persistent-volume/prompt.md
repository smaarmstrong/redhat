Run a detached container that keeps its data on persistent storage.

Requirements:

  • Container name:   datastore
  • State:            running (detached) — run `sleep infinity` as its command
  • Storage:          persistent storage mounted at /data INSIDE the container

The persistent storage may be either:
  - a named podman volume (e.g. `podman volume create appdata`
    then `-v appdata:/data`), or
  - a host bind mount (e.g. `-v /srv/datastore:/data`).

Any small image is fine (e.g. registry.access.redhat.com/ubi9/ubi or
docker.io/library/alpine).

NOTE: This is a bonus RHEL8-era container task, not part of the core RHEL9
EX200 objectives. It requires the `podman` command, and pulling an image needs
access to a container registry (internet). setup.sh best-effort installs
container-tools and pre-pulls a tiny image; if that is unavailable the grader
will note it and the task cannot be completed offline.

NOTE: Rootless is the production norm; here the container is run and graded as
root so the grader (which runs as root) can inspect its mounts.
