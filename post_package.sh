#!/bin/sh
/usr/ports/infrastructure/bin/pkg_check-manpages -p "${@}" 2>&1 | tee "/var/log/build/${@} $(date).log"