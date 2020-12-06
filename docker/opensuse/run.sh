#!/bin/sh

[ -z "$NAME" ]    && NAME="lmg-opensuse"
[ -z "$VERSION" ] && VERSION=0.0.12
[ -z "$DIRNAME" ] && DIRNAME="$(dirname "$0")/../.."
[ -z "$USER" ]    && USER="root"

DIRNAME="$(sh -c "cd \"$DIRNAME\" && pwd")"

docker run -ti --rm -v "$DIRNAME/src:/mnt/app" -v "$DIRNAME/data:/mnt/data" -e LMG_DATA_FOLDER="$DIRNAME/data" --user="$USER" "$NAME:$VERSION" "$@"
