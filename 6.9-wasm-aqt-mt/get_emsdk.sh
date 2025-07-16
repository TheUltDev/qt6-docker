#!/bin/sh -xe
# Script to get emscripten sdk

[ "$SDK_VERSION" ] || SDK_VERSION=3.1.70
[ "$SDK_URL" ]    || SDK_URL="https://github.com/emscripten-core/emsdk/archive/refs/tags/$SDK_VERSION.tar.gz"
[ "$SDK_SHA256" ] || SDK_SHA256=6df4b778f52e0e86c721cc6f97e7ad8fd6c842be2451e39f2bc528facb5d4cde

[ "$SDK_PATH" ] || SDK_PATH=/opt/emsdk

root_dir=$PWD
[ "$root_dir" != '/' ] || root_dir=""

# Init the package system
apt update

echo
echo '--> Save the original installed packages list'
echo

dpkg --get-selections | cut -f 1 > /tmp/packages_orig.lst

echo
echo '--> Install EmSDK'
echo

apt install -y curl python-is-python3

echo "$SDK_SHA256 -" > sum.txt && curl -fLs "$SDK_URL" | tee /tmp/emsdk.tar.gz | sha256sum -c sum.txt
mkdir -p "$SDK_PATH"
tar --strip-components 1 -C "$SDK_PATH" -xf /tmp/emsdk.tar.gz
rm -f /tmp/emsdk.tar.gz
emsdk install "$SDK_VERSION"
emsdk activate "$SDK_VERSION"

# Make sure node tool exist
ls "$EMSDK_NODE"

echo
echo '--> Restore the packages list to the original state'
echo

dpkg --get-selections | cut -f 1 > /tmp/packages_curr.lst
grep -Fxv -f /tmp/packages_orig.lst /tmp/packages_curr.lst | xargs apt remove -y --purge

# Complete the cleaning

cd /tmp
rm -rf $root_dir/build
apt -qq clean
rm -rf /var/lib/apt/lists/*
