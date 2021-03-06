#!/bin/sh

[ -z "$NAME" ]    && NAME="lmg-ubuntu"
[ -z "$VERSION" ] && VERSION=0.0.14
[ -z "$DIRNAME" ] && DIRNAME="$(dirname "$0")/../.."
[ -z "$USER" ]    && USER="root"

DIRNAME="$(sh -c "cd \"$DIRNAME\" && pwd")"

docker run -ti --rm -v "$DIRNAME/src:/mnt/app" -v "$DIRNAME/data:/mnt/data" -e LMG_DATA_FOLDER="/mnt/data" --user="$USER" "$NAME:$VERSION" "$@"
