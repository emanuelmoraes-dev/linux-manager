#!/usr/bin/env sh
echo "Adding mirros..." &&
(curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -) &&
(echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list) &&
echo "Updating mirros..." &&
sudo apt update &&
echo "Installing spotify..." &&
sudo apt install spotify-client &&
echo "Done!"
