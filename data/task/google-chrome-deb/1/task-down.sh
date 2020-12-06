#!/usr/bin/env sh
DIRNAME="$(dirname "$0")" &&
[ "$1" ] && PKG_FOLDER="$1" || PKG_FOLDER="$DIRNAME" 
echo "Uninstaling Google Chrome via dpkg..." &&
sudo dpkg -p google-chrome-stable &&
echo "Done!"
