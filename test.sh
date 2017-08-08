#!/bin/bash
set -ex

docker_build() {
  local -r crate="$1"crate
  docker run \
    --rm \
    -v "$PWD/test/${crate}:/volume" \
    -w /volume \
    -e RUST_BACKTRACE=1 \
    -t clux/muslrust \
    cargo build --verbose
  cd "test/${crate}"
  ./target/i686-unknown-linux-musl/debug/"${crate}"
  [[ "$(ldd target/i686-unknown-linux-musl/debug/${crate})" =~ "not a dynamic" ]] && \
    echo "${crate} is a static executable"
}

docker_build "$1"
