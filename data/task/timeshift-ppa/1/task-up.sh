#!/usr/bin/env sh
echo "Adding ppa:teejee2008/timeshift..." &&
sudo add-apt-repository -y ppa:teejee2008/timeshift &&
echo "Updating mirrors..." &&
sudo apt-get update &&
echo "Installing timeshift..." &&
sudo apt-get install timeshift &&
echo "Done!"

