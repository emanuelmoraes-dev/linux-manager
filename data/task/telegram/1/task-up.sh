#!/bin/bash
[ -z "$DIR" ] && DIR="/usr/local"
[ -z "$TMP" ] && TMP="/tmp/$(date +%s)-linux-manager-task-telegram"

mkdir -p "$TMP" &&
echo "Downloadig Telegram ..." &&
curl -L https://telegram.org/dl/desktop/linux -o "$TMP/tsetup.tar.xz" &&
echo "Extracting Telegram to $DIR ..." &&
tar -xvJf "$TMP/tsetup.tar.xz" -C "$DIR" &&
echo "Extracted Telegram to $DIR" &&
rm -rvf "$TMP" &&
echo "Done!"
