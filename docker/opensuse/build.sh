#!/bin/sh

[ -z "$NAME" ]    && NAME="lmg"
[ -z "$VERSION" ] && VERSION=0.0.2
[ -z "$DIRNAME" ] && DIRNAME="$(dirname "$0")"

DIRNAME="$(sh -c "cd \"$DIRNAME\" && pwd")"

docker build -t "$NAME:$VERSION" "$DIRNAME"
