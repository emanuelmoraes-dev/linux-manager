#!/usr/bin/env bash

function main {
    local folder_instalation="$1" &&
    if [ -z "$folder_instalation" ]; then
        [ "$UID" == "0" ] && folder_instalation="/usr/local/share/lmg" ||
        folder_instalation="$HOME/.local/share/lmg"
    fi &&
    mkdir -p "$folder_instalation" &&
    cp -rf src/* "$folder_instalation" &&
    printf "$(./template.sh)" "$folder_instalation" > lmg &&
    chmod +x lmg &&
    sudo mv lmg /usr/bin
}

main "$@"