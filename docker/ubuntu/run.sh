#!/bin/sh

[ -z "$NAME" ]    && NAME="lmg-ubuntu"
[ -z "$VERSION" ] && VERSION=0.0.11
[ -z "$DIRNAME" ] && DIRNAME="$(dirname "$0")/../../src"
[ -z "$USER" ]    && USER="root"

DIRNAME="$(sh -c "cd \"$DIRNAME\" && pwd")"

docker run -ti --rm -v "$DIRNAME:/mnt/app" -e lmg=/mnt/app/lmg.sh -e app=/mnt/app --user="$USER" "$NAME:$VERSION" "$@"
