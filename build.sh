#!/bin/bash
#
# build.sh
# GPhoto2.framework
# https://github.com/lnxbil/GPhoto2.framework
# 
# Copyright (C) 2011-2012 Andreas Steinel
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 



# On fishy behaviour, please uncomment this line
#set -ex

# loading configuration file
source ./config

###############################################################################
# Variables
###############################################################################

# Setting up paths relative to the FRAMEWORK_BASE
PREFIX=${FRAMEWORK_BASE}/prefix
MANPAGES=${PREFIX}/man/man1
LICENSES=${FRAMEWORK_BASE}/Resources/Licenses
GPHOTOSVN=libgphoto2-SVN

# Compiler flags
export CFLAGS="-I${PREFIX}/include"
export CPPFLAGS="-I${PREFIX}/include"
#For building on the iPad with myreaddir library
#export LDFLAGS="-F/var/mobile/Frameworks -L/usr/lib -lmyreaddir"
export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig
export PATH=${PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH}
export LD_LIBRARY_PATH=${PREFIX}/lib
export LDFLAGS="-L${PREFIX}/lib"

export CC="gcc $ARCH"
export CXX="g++ $ARCH"
export CPP=/usr/bin/cpp
export CXXCPP=/usr/bin/cpp
export CFLAGS="$CFLAGS -pipe"
export CXXFLAGS="$CXXFLAGS -pipe"

# other flags
export LANG=C
DATE=`date +%Y%m%d_%H%M%S `
DCORES=$(( `sysctl -n hw.ncpu` * 2 ))

###############################################################################
# Functions
###############################################################################

function download_files()
{
    echo "+ Download and extracting files"

    mkdir -p download
    cd download

    # build download list
    cat <<EOF > download.list
http://ftpmirror.gnu.org/libtool/libtool-${LIBTOOL}.tar.gz
http://pkgconfig.freedesktop.org/releases/pkg-config-${PKGCONFIG}.tar.gz
http://switch.dl.sourceforge.net/project/libusbx/releases/${LIBUSB}/source/libusbx-${LIBUSB}.tar.bz2
http://switch.dl.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-${LIBUSBC}/libusb-compat-${LIBUSBC}.tar.bz2
http://ftp.de.debian.org/debian/pool/main/libj/libjpeg6b/libjpeg6b_6b${JPEG}.orig.tar.gz
EOF
    if [ $GPHOTO != "SVN" ]
    then
        cat <<EOF >> download.list
http://switch.dl.sourceforge.net/project/gphoto/libgphoto/${GPHOTO}/libgphoto2-${GPHOTO}.tar.bz2
EOF
    else
        if [ -d $GPHOTOSVN ]
        then
            cd $GPHOTOSVN
            svn up -q
            autoreconf --install --symlink
        else
            svn checkout -q https://gphoto.svn.sourceforge.net/svnroot/gphoto/trunk/libgphoto2 $GPHOTOSVN
            cd $GPHOTOSVN
            autoreconf --install --symlink
            cd $OLDPWD
        fi
    fi


    # Downloading required files as compressed tar archives
    wget --timeout 5 --tries 2 -c -i download.list > download.log 2>&1

    # get downloaded file list
    GZFILES=`ls -1 *.tar.gz *.tgz 2>/dev/null`
    BZFILES=`ls -1 *.tar.bz2 *.tbz 2>/dev/null`

    # uncompress each file
    for i in $GZFILES; do tar -zxf $i; done
    for i in $BZFILES; do tar -jxf $i; done

    cd ..
}


function check_wget()
{
    if ! which wget >/dev/null 2>&1
    then
        echo "Please get 'wget' as downloader"
        exit 1
    fi
}

function check_permissions()
{
    echo "+ Checking permissions on $FRAMEWORK_BASE"

    TMPFILE=`mktemp -t GPhoto.framework`

    # FRAMEWORK_BASE directory has to exist
    if ! [ -d $FRAMEWORK_BASE ]
    then
        if ! mkdir -p $FRAMEWORK_BASE 2>/dev/null
        then
            echo -n "FRAMEWORK_BASE '$FRAMEWORK_BASE' does not exist, try to create it . . . FAILED!"
            echo ""
            echo "Please try to create the directory manually as root (e.g. with sudo):"
            echo "  sudo mkdir -m 777 -p $FRAMEWORK_BASE"
            exit 1
        fi
    fi

    # FRAMEWORK_BASE directory has to be writeable
    if ! touch $FRAMEWORK_BASE/test 2>/dev/null
    then
        echo "Check if the FRAMEWORK_BASE is writeable . . . . . . . . . . .  FAILED!"
        echo ""
        echo "Please try to fix it manuall as root (e.g. with sudo)"
        echo "  sudo chmod 777 $FRAMEWORK_BASE"
        exit 1
    fi
}

function compile_me_real()
{
    CONFIGURE="./configure --prefix=$PREFIX --enable-shared --disable-iconv --enable-osx-universal-binary --disable-nls "

    cd $1
    echo "--------------------------------------------------------------------------------"
    echo "Starting to build $1"
    echo "--------------------------------------------------------------------------------"
    echo "- Cleaning"
    make -s clean || true

    echo "- Configuring"
    echo "Running '$CONFIGURE'"
    $CONFIGURE
    [ $? -gt 0 ] && return 1
    
    echo "- Building"
    make -s -j${DCORES} all
    [ $? -gt 0 ] && return 1

    echo "- Installing"
    make install -s
    [ $? -gt 0 ] && return 1

    make install-lib -s
    make install-headers -s

    echo "- Finishing"
    cd ..
}

function compile_me()
{
    echo "  - Building $1"
    MYPWD=$PWD
    mkdir -p $MYPWD/logs

    # strip / is present and append _buildlog-$DATE.log
    LOGFILE=$(echo $1 | cut -d/ -f1)_buildlog-$DATE.log

    compile_me_real $1 >logs/$LOGFILE 2>&1

    if [ $? -gt 0 ]
    then
        cd ..
        echo ""
        echo "An error occured"
        echo "(Full Log at $MYPWD/logs/$LOGFILE):"
        echo ""
        tail -20 $MYPWD/logs/$LOGFILE
        exit 1
    fi

    # Copying Licensing information
    if [ -e $1/COPYING ]
    then
        cp -a $1/COPYING $LICENSES/$1
    fi
}

function build()
{
    # Cleaning up
    rm -rf ${FRAMEWORK_BASE}/*
    mkdir -p $MANPAGES $LICENSES

    # switch to work directory
    cd download 

    echo "+ Start building at `date` with ${DCORES} threads"

    compile_me "libtool-${LIBTOOL}"
    compile_me "pkg-config-${PKGCONFIG}"
    compile_me "libusbx-${LIBUSB}"
    compile_me "libusb-compat-${LIBUSBC}"
    compile_me "jpeg-6b${JPEG}"
    compile_me "libgphoto2-${GPHOTO}"

    echo "+ Finished building at `date`"
}

function cleanup_build()
{
    echo "+ Cleaning up framework directory"

    # Cleaning up unneccessary files
    rm -rf ${PREFIX}/{share,man,bin} \
           ${PREFIX}/lib/pkgconfig \
           ${PREFIX}/lib/udev \
           ${PREFIX}/lib/libgphoto2/print-camera-list
    find $PREFIX/lib/ -iname "*.a" | xargs rm -f
    find $PREFIX/lib/ -iname "*.la" | xargs rm -f
}

function linking_headers()
{
    echo "+ Linking headers"

    # Linking GPhoto2 Headers 
    mkdir -p $FRAMEWORK_BASE/Headers
    for i in $PREFIX/include/gphoto2/*h
    do
        file=$(basename $i)
        ln -fs ../prefix/include/gphoto2/$file $FRAMEWORK_BASE/Headers/$file
    done

    # Links libusb and ltdl
    ln -fs ../prefix/include/usb.h $FRAMEWORK_BASE/Headers
    ln -fs ../prefix/include/ltdl.h $FRAMEWORK_BASE/Headers
}

function build_framework_infrastructure()
{
    echo "+ Building Apple Framework infrastructure"

    # Build versions directory
    mkdir -p $FRAMEWORK_BASE/Versions/Current
    ln -fs ../../prefix/lib/libgphoto2.dylib $FRAMEWORK_BASE/Versions/Current/GPhoto2
    ln -fs prefix/lib/libgphoto2.dylib $FRAMEWORK_BASE/GPhoto2

    # Populate Info.plist
    cat <<EOF > $FRAMEWORK_BASE/Resources/Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>English</string>
        <key>CFBundleExecutable</key>
        <string>GPhoto2</string>
        <key>CFBundleIdentifier</key>
        <string>com.github.lnxbil.gphoto2.framework</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>GPhoto2</string>
        <key>CFBundlePackageType</key>
        <string>FMWK</string>
        <key>CFBundleShortVersionString</key>
        <string>${GPHOTO}</string>
        <key>CFBundleVersion</key>
        <string>${GPHOTO}</string>
</dict>
</plist>
EOF

}

function main()
{
    echo "Build Process of the GPhoto2.framework"
    echo "https://github.com/lnxbil/GPhoto2.framework"
    echo ""

    check_wget
    check_permissions
    download_files
    build
    cleanup_build
    linking_headers
    build_framework_infrastructure
}


###############################################################################
# Main
###############################################################################

# Running main
main

