#!/bin/sh

[ -z "$NAME" ] && NAME="lmg"
[ -z "$VERSION" ] && VERSION=0.0.1
[ -z "$DIRNAME" ] && DIRNAME="$(dirname "$0")"

docker build -t "$NAME:$VERSION" "$DIRNAME"