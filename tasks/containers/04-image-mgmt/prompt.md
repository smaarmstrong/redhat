Pull a container image and give it a local tag.

Requirements:

  • Pull any small image (e.g. registry.access.redhat.com/ubi9/ubi
    or docker.io/library/alpine).
  • Tag it as:   localhost/myapp:v1

Example:
  podman pull registry.access.redhat.com/ubi9/ubi
  podman tag  registry.access.redhat.com/ubi9/ubi localhost/myapp:v1

Verify with:  podman image exists localhost/myapp:v1

NOTE: This is a bonus RHEL8-era container task, not part of the core RHEL9
EX200 objectives. It requires `podman`, and pulling an image needs access to a
container registry (internet). setup.sh best-effort installs container-tools
and pre-pulls a tiny image; if that is unavailable the grader will note it and
the task cannot be completed offline.

NOTE: Rootless is the production norm; here images are managed and graded as
root so the grader (which runs as root) sees the same image store.
