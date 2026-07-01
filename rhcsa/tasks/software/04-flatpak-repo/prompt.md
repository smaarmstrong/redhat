BONUS TASK — requires the `flatpak` package and internet access.

Configure this system to access the Flathub Flatpak repository by adding it
as a remote named `flathub`:

  flatpak remote-add --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo

When you are done, `flatpak remotes` must list a remote called `flathub`.
