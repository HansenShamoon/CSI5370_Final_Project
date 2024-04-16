Implementation
The automatic testing framework uses proot and dpb. proot begins by filling up a chroot directory for ports building usage. It will perform a set of actions that should fill up a destination chroot directory from the base system. The project’s proot is the following code snippet:
proot chroot=/build extra=/usr/local/obbt/dpb-start.sh WRKOBJDIR=/tmp/pobj LOCKDIR=/tmp/locks PLIST_REPOSITORY=/data/plist DISTDIR=/data/distfiles PACKAGE_REPOSITORY=/data/packages chown_all=1

proot uses an action=value syntax. The above code snippet does the following:
Sets the chroot new root directory to /build
Copies the dbp script into the chroot directory
Sets the port working directory to /tmp/pobj
Sets the user lock settings directory to /tmp/locks
Sets the user base directory used to save generated packing-lists to /data/plist
Sets the cache of all distribution files to /data/distfiles
Sets the default package repo to /data/packages
Change the appropriate permissions
By default, proot will verify the state of mount points in the system, remove everything from the chroot directory that is not needed for building, regenerate system and device special files, rerun ldconfig, create ports infrastructure subdirs, according to users required for dpb and change permissions appropriately, copy the system resolv.conf and host files, and write a skeleton mk.conf file if some values are different from the default. 
dpb is used to build ports on a cluster of machines, or on a single machine with several cores. The mentioned dpb-start.sh shell script contains the following code snippet:
HOSTS="localhost"
JOBS="2"
dpb -B /build -h  "${HOSTS}" -j "${JOBS}"  "${pkgpath}"

All the default parameters are used for dpb [6] with a few exceptions. The HOSTS variable can be modified to contain other hostnames for clustering. The JOBS variable is used to define how many jobs should be run on the localhost machine. The pkgpath variable is the list of packages that will be built and tested.
In the /usr/ports/infrastructure/post_package.sh script that was created for the project, we find the following snippet:
#!/bin/sh
/usr/ports/infrastructure/bin/pkg_check-manpages -p "${@}" 2>&1 | tee "/var/log/build/${@} $(date).log"

This script is called automatically by the OpenBSD build system with an argument of the package that was just built. This argument can be accessed with the special $@ variable. The “-p” argument indicates to be picky with the manpages. If any error output is given, it means an error occurred in the checking of the manpage. This error message is displayed and saved by “tee” for viewing later. 
This implementation so far is enough to automatically check for errors found in test cases for manpages. In the future, this same implementation can be expanded to include the other categories of test cases by expanding the post_package.sh script to include them.
