The directory `/srv/source` contains some files and a subdirectory.

Use `rsync` to make `/srv/backup` an **exact mirror** of `/srv/source`,
preserving file permissions and timestamps.

After you are done:

  • `/srv/backup` must contain the same files and subdirectory as
    `/srv/source`, with matching permissions and modification times.
  • Running rsync again in check mode must report no differences.

(Hint: `rsync -a` preserves permissions, timestamps, ownership, and
recurses into subdirectories. Mind the trailing slash on the source.)
