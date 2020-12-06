#!/usr/bin/env sh
DIRNAME="$(dirname "$0")" &&
[ "$1" ] && PKG_FOLDER="$1" || PKG_FOLDER="$DIRNAME"
mkdir -p "$PKG_FOLDER" &&
echo "Downloading Google Chrome..." &&
curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o "$PKG_FOLDER/google-chrome-stable_current_amd64.deb" &&
echo "Installing Google Chrome via dpkg..." &&
sudo dpkg -i "$PKG_FOLDER/google-chrome-stable_current_amd64.deb" &&
echo "Done!"
