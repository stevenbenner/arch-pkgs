# arch-pkgs

This is my collection of [Arch Linux][archlinux] system configuration [PKGBUILD][pkgbuild] files.

The purpose of this project is to simplify the process of setting up and maintaining multiple Arch Linux systems, as well as cleaning up the list of explicitly installed packages. With these [meta packages][metapackages] I can install most everything needed for my uses and automate some basic setup tasks.

[archlinux]: https://archlinux.org/
[pkgbuild]: https://wiki.archlinux.org/title/PKGBUILD
[metapackages]: https://wiki.archlinux.org/title/Meta_package_and_package_group

## Usage

> **Note**\
> I would recommend that you use this project for inspiration or fork it as a template for your own custom setup. You probably do not want to install these packages as-is because they will be specific to my usage in places (e.g. US-English, US-pacific time zone).

### Building the packages

The makefile includes some basic operations:

* `make clean` - Remove build artifacts
* `make check` - Perform some basic syntax/validity checks
* `make` - Build the packages and create/update the repo

The packages are built with [`makepkg`][makepkg]. This method includes some information about your system, and is a little more susceptible to dependency errors. You may want to consider [building in a clean chroot][cleanchroot] if you want to serve the repo over the public internet or to other people.

[makepkg]: https://wiki.archlinux.org/title/makepkg
[cleanchroot]: https://wiki.archlinux.org/title/DeveloperWiki:Building_in_a_clean_chroot

### Publishing the packages

The "repo" folder will contain everything you need to host the [package repository][customrepo]. Serve this folder on your local network to make the repo available to all computers on the LAN.

I recommend that you sync the folder to a dedicated intranet server on your LAN. If the server is down when a client computer attempts to update the package repos for a `pacman -Syu` operation then it will report an error. Personally, I use a Raspberry Pi that I keep as a dedicated intranet server (running [Arch Linux ARM][archarm] btw).

[customrepo]: https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Custom_local_repository
[archarm]: https://archlinuxarm.org/

### Configure client systems to use the repo

Enable the repo on systems by editing the `/etc/pacman.conf` file and adding the repo with the following configuration:

```
[private]
SigLevel = Optional TrustAll
Server = http://serverhostname/repo
```

* Replace "private" with the `TARGET_REPO` specified in the makefile
* Replace "serverhostname" with the real host name or IP address of the server hosting the repo folder.

## Resources

Special thanks to the Arch Linux enthusiasts who published articles and code explaining how to accomplish this. Here are some particularly useful links for anyone wanting to make something like this.

### Articles

* https://disconnected.systems/blog/archlinux-meta-packages/
* https://ownyourbits.com/2019/07/21/replicate-your-system-with-self-hosted-arch-linux-metapackages/
* https://wiki.archlinux.org/title/Creating_packages

### Code

* https://github.com/mdaffin/arch-pkgs
* https://github.com/Foxboron/PKGBUILDS/tree/master/foxboron-system
* https://github.com/Earnestly/pkgbuilds/tree/master/system-config
* https://github.com/krathalan/pkgbuilds
* https://github.com/patatahooligan/meta-packages
