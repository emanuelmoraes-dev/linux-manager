#!/usr/bin/env sh
echo "Removing ppa:teejee2008/timeshift..." &&
sudo add-apt-repository -r -y ppa:teejee2008/timeshift &&
echo "Updating mirrors..." &&
sudo apt-get update &&
echo "Uninstalling timeshift..." &&
sudo apt-get remove timeshift &&
echo "Done!"

