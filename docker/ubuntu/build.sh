#!/bin/sh

[ -z "$NAME" ]    && NAME="lmg-ubuntu"
[ -z "$VERSION" ] && VERSION=0.0.13
[ -z "$DOCKER_FOLDER" ] && DOCKER_FOLDER="$(dirname "$0")"

DOCKER_FOLDER="$(sh -c "cd \"$DOCKER_FOLDER\" && pwd")"

docker build -t "$NAME:$VERSION" "$DOCKER_FOLDER"
