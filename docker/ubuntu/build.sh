#!/bin/sh

[ -z "$NAME" ]    && NAME="lmg-ubuntu"
[ -z "$VERSION" ] && VERSION=0.0.11
[ -z "$DIRNAME" ] && DIRNAME="$(dirname "$0")"

DIRNAME="$(sh -c "cd \"$DIRNAME\" && pwd")"

docker build -t "$NAME:$VERSION" "$DIRNAME"
