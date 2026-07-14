THE IDEA

  Before you can run a container you need its IMAGE — the packaged,
  read-only filesystem it starts from. Images live in registries
  (registry.access.redhat.com, docker.io, ...) and get copied to your
  local image store with `podman pull`. Everything you run afterwards
  comes from that local copy; no network needed once it's cached.

  An image is identified by a full reference:

    registry.access.redhat.com/ubi9/ubi:latest
    \__________ registry ________/\_ repo _/\_tag_/

  A TAG is just a human-friendly name pointing at an image. One image
  can carry many tags at once — they're like extra labels, not copies.
  `podman tag` adds another label to an image you already have. That's
  this task: pull an image, then give it your own local tag,
  localhost/myapp:v1.

---

  See what's already in the local store (setup pre-pulled something):

```run
podman images
```

  You'll see ubi9/ubi or alpine cached. That base image is what we'll
  re-tag.

---

WHY IT MATTERS

  Pulling and tagging is the bread and butter of working with images:
  you pull a base, tag it under your own name/version so builds and
  deployments refer to a stable label, and later push it to a
  registry. The localhost/ prefix specifically means "a local image
  not tied to any remote registry" — exactly what you use for images
  you build or tag yourself.

---

HOW TO DO IT

  Step 1: make sure the base image is present. pull is idempotent — if
  it's already cached it returns instantly:

```run
podman pull registry.access.redhat.com/ubi9/ubi 2>/dev/null || podman pull docker.io/library/alpine
```

  (In an exam with a registry reachable you'd just
  `podman pull registry.access.redhat.com/ubi9/ubi`. The || here just
  falls back to alpine if ubi isn't reachable.)

---

  Step 2: add the new tag. `podman tag SOURCE NEW-TAG` — the source is
  the image you have, the new tag is the label you're adding:

```run
podman tag $(podman image exists registry.access.redhat.com/ubi9/ubi && echo registry.access.redhat.com/ubi9/ubi || echo docker.io/library/alpine) localhost/myapp:v1
```

  Plainly, that's:

    podman tag registry.access.redhat.com/ubi9/ubi localhost/myapp:v1

  No output means success. The image now answers to BOTH its original
  name and localhost/myapp:v1 — same underlying image, two labels.

---

CHECK IT WORKED

  The direct check the grader uses:

```run
podman image exists localhost/myapp:v1
```

  Exit status 0 (no output) means the tag exists — that's a pass. You
  can also eyeball it:

```run
podman images | grep myapp
```

  You'll see localhost/myapp with tag v1, and note its IMAGE ID
  matches the base image's — proof it's the same image wearing a
  second label, not a second copy.

---

GOTCHAS

  - tag order is SOURCE then NEW-NAME. Reversing them tags the wrong
    way (or errors if the "source" doesn't exist).
  - Include the tag part. localhost/myapp with no :v1 defaults to
    :latest — the grader wants :v1 specifically.
  - The localhost/ prefix matters. A bare `myapp:v1` may be stored as
    localhost/myapp:v1 by default, but type the full localhost/myapp:v1
    to be certain you match what's graded.
  - Tagging makes a new NAME, not a new image. Removing one tag with
    `podman rmi` only drops that label while others remain; the image
    data goes only when its last tag is removed.
