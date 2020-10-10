#!/bin/sh

[ -z "$NAME" ]    && NAME="lmg"
[ -z "$VERSION" ] && VERSION=0.0.1
[ -z "$DIRNAME" ] && DIRNAME="$(dirname "$0")/../../src"
[ -z "$DATA" ]    && DATA="$(dirname "$0")/../../data"

DIRNAME="$(sh -c "cd \"$DIRNAME\" && pwd")"
DATA="$(sh -c "cd \"$DATA\" && pwd")"

docker run -ti --rm -v "$DIRNAME:/root/app" -v "$DATA:/root/.lmg" -e lmg=/root/app/lmg.sh -e app=/root/app "$NAME:$VERSION" "$@"
