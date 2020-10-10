#!/bin/sh

[ -z "$NAME" ]    && NAME="lmg"
[ -z "$VERSION" ] && VERSION=0.0.6
[ -z "$DIRNAME" ] && DIRNAME="$(dirname "$0")/../../src"

DIRNAME="$(sh -c "cd \"$DIRNAME\" && pwd")"

docker run -ti --rm -v "$DIRNAME:/root/app" -e lmg=/root/app/lmg.sh -e app=/root/app "$NAME:$VERSION" "$@"
