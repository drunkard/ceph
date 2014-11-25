#!/bin/bash
#
# Ceph distributed storage system
#
# Copyright (C) 2014 Red Hat <contact@redhat.com>
#
# Author: Loic Dachary <loic@dachary.org>
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
if lsb_release -si | grep --quiet 'Ubuntu\|debian' ; then
    if which dpkg-checkbuilddeps > /dev/null ; then
        DIR=/tmp/deps.deb.$$
        trap "rm -fr $DIR" EXIT
        mkdir -p $DIR
        touch $DIR/status
        dpkg-checkbuilddeps --admindir=$DIR debian/control 2>&1 |
        perl -p -e 's/.*Unmet build dependencies: *//;' \
            -e 's/build-essential:native/build-essential/;' \
            -e 's/\(.*?\)//g;' \
            -e 's/ +/\n/g;' | sort
        exit 0
    else
        cat >&2 <<EOF
dpkg-checkbuilddeps is required to display the list of dependencies.
It is provided by the dpkg-dev package:

   apt-get install dpkg-dev

EOF
    fi
else
    cat >&2 <<EOF
$(lsb_release -si) does not rely on debian/control to determine
the list of package required to build from sources.
EOF
fi
