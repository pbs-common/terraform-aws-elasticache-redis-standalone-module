#!/usr/bin/env bash

# Unofficial bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

GIT_ROOT=$(git rev-parse --show-toplevel)

mkdir -p "$GIT_ROOT"/examples/lambda/artifacts

PACKAGE_DIR="$GIT_ROOT/examples/lambda/src/package"
rm -rf "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR"

pip install redis hiredis \
  --target "$PACKAGE_DIR" \
  --platform manylinux2014_aarch64 \
  --only-binary=:all: \
  --python-version 3.13

pushd "$PACKAGE_DIR" >/dev/null
zip -r9 "$GIT_ROOT"/examples/lambda/artifacts/handler.zip ./*

popd >/dev/null
pushd "$GIT_ROOT"/examples/lambda/src >/dev/null
zip -g "$GIT_ROOT"/examples/lambda/artifacts/handler.zip index.py
