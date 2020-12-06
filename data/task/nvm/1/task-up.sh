#!/usr/bin/env bash
[ -z "$NVM_VERSION" ] && NVM_VERSION=0.37.2
rcs=("$@")
[ "${#rsc[@]}" == "0" ] && rcs=(.bashrc .zshrc)
echo "Installing nvm..." &&
(curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash) &&
echo "Setting nvm..." &&
for rc in "${rsc[@]}"; do
	echo "Updating $rc..." &&
	touch "$HOME/$rc" &&
	printf '
# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf  "${HOME}/.nvm" || printf  "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
' >> "$rc"
done &&
echo "Done!"