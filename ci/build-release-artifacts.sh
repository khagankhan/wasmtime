#!/bin/bash

# A script to build the release artifacts of Wasmtime into the `target`
# directory. For now this is the CLI and the C API. Note that this script only
# produces the artifacts through Cargo and doesn't package things up. That's
# intended for the `build-tarballs.sh` script.
#
# This script takes a Rust target as its first input and optionally a parameter
# afterwards which can be "-min" to indicate that a minimal build should be
# produced with as many features as possible stripped out.

set -ex

build=$1
target=$2
wrapper=""

# If `$DOCKER_IMAGE` is set then run the build inside of that docker container
# instead of on the host machine. In CI this uses `./ci/docker/*/Dockerfile` to
# have precise glibc requirements for Linux platforms for example.
if [ "$DOCKER_IMAGE" != "" ]; then
  if [ -f "$DOCKER_IMAGE" ]; then
    docker build --tag build-image --file $DOCKER_IMAGE ci/docker
    DOCKER_IMAGE=build-image
  fi

  # Inherit the environment's rustc and env vars related to cargo/rust, and then
  # otherwise re-execute ourselves and we'll be missing `$DOCKER_IMAGE` in the
  # container so we'll continue below.
  exec docker run --interactive \
    --volume `pwd`:`pwd` \
    --volume `rustc --print sysroot`:/rust:ro \
    --workdir `pwd` \
    --interactive \
    --env-file <(env | grep 'CARGO\|RUST') \
    $DOCKER_IMAGE \
    bash -c "PATH=\$PATH:/rust/bin RUSTFLAGS=\"\$RUSTFLAGS \$EXTRA_RUSTFLAGS\" `pwd`/$0 $*"
fi

# Default build flags for release artifacts. Leave debugging for
# builds-from-source which have richer information anyway, and additionally the
# CLI won't benefit from catching unwinds and neither will the C API so use
# panic=abort in both situations.
export CARGO_PROFILE_RELEASE_STRIP=debuginfo
export CARGO_PROFILE_RELEASE_PANIC=abort

if [[ "$build" = *-min ]]; then
  # Configure a whole bunch of compile-time options which help reduce the size
  # of the binary artifact produced.
  export CARGO_PROFILE_RELEASE_OPT_LEVEL=s
  export RUSTFLAGS="-Zlocation-detail=none $RUSTFLAGS"
  export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
  export CARGO_PROFILE_RELEASE_LTO=true
  build_std=-Zbuild-std=std,panic_abort
  build_std_features=-Zbuild-std-features=std_detect_dlsym_getauxval
  flags="$build_std $build_std_features --no-default-features --features disable-logging"
  cmake_flags="-DWASMTIME_DISABLE_ALL_FEATURES=ON"
  cmake_flags="$cmake_flags -DWASMTIME_FEATURE_DISABLE_LOGGING=ON"
  cmake_flags="$cmake_flags -DWASMTIME_USER_CARGO_BUILD_OPTIONS:LIST=$build_std;$build_std_features"
else
  # For release builds the CLI is built a bit more feature-ful than the Cargo
  # defaults to provide artifacts that can do as much as possible.
  bin_flags="--features all-arch,component-model"
fi

if [[ "$target" = "x86_64-pc-windows-msvc" ]]; then
  # Avoid emitting `/DEFAULTLIB:MSVCRT` into the static library by using clang.
  export CC=clang
  export CXX=clang++
fi

cargo build --release $flags --target $target -p wasmtime-cli $bin_flags --features run

mkdir -p target/c-api-build
cd target/c-api-build
cmake \
  -G Ninja \
  ../../crates/c-api \
  $cmake_flags \
  -DCMAKE_BUILD_TYPE=Release \
  -DWASMTIME_TARGET=$target \
  -DCMAKE_INSTALL_PREFIX=../c-api-install \
  -DCMAKE_INSTALL_LIBDIR=../c-api-install/lib
cmake --build . --target install
