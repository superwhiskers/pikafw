#!/bin/bash

#
# ferrisfw - 3ds custom firmware in rust
# Copyright (C) 2019 superwhiskers <whiskerdev@protonmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

# project root
project_root="$(pwd)"

# cargo command
cargo="cargo"

# objcopy command (assumes you have devkitarm's bin folder in your path)
objcopy="arm-none-eabi-objcopy"

# firmtool (assumes you have firmtool in your path)
firmtool="firmtool"

# cargo.toml file to use
cargo_toml="$project_root/Cargo.toml"

# rustc flags
rustcflags="--target $project_root/assets/arm9.json -C panic=abort -C link-arg=-nostartfiles"

#
# build functions
#

buildsh_clean() {
    cd $project_root
    rm -rf build
    rm -rf out
    $cargo clean
}

buildsh_rust_build_arm9_debug() {
    $cargo xrustc --target-dir $project_root/build --manifest-path $cargo_toml -- -C opt-level=0 -C debuginfo=2 $rustcflags
}

buildsh_rust_build_arm9_release() {
    $cargo xrustc --release --target-dir $project_root/build --manifest-path $cargo_toml -- -C opt-level=3 -C lto=thin -C debuginfo=0 $rustcflags
}

buildsh_build_arm9_firm() {
    cd $project_root/build/$1/deps
    elfs=( "*.elf" )
    $objcopy --set-section-flags .bss=alloc,load,contents -O binary ${elfs[0]}
    $firmtool build $project_root/out/ferrisfw.firm -n 0x23F00000 -e 0 -D ${elfs[0]} -A 0x23F00000 -C NDMA -i
}

#
# misc. functions
#

buildsh_usage() {
    echo "usage: $0 [-t {debug, release, clean}] [-vhu]"
}

buildsh_help() {
    echo
    echo "$0 - ferrisfw's buildscript"
    echo
    buildsh_usage
    echo
    echo "options:"
    echo "  -t build_type - set the build type (default \"debug\")"
    echo "  -v            - log verbosely"
    echo "  -h            - show this help message"
    echo "  -u            - show usage"
    echo
    echo "written with love by superwhiskers <whiskerdev@protonmail.com>"
    echo
}

#
# parse arguments
#

build_type="debug"
verbose=0
while getopts ":t:vhu" opt; do
    case $opt in
	t)
	    build_type=$OPTARG
	    ;;
	h)
	    buildsh_help
	    exit 0
	    ;;
	v)
	    verbose=1
	    ;;
	u)
	    buildsh_usage
	    exit 0
	    ;;
	:)
	    echo "build.sh: -$OPTARG requires an argument" >&2
	    buildsh_usage
	    exit 1
	    ;;
	\?)
	    echo "build.sh: invalid option: -$OPTARG" >&2
	    buildsh_usage
	    exit 1
	    ;;
    esac
done

#
# check dependencies
#

command -v $cargo > /dev/null 2>&1 || {
    echo "build.sh: cargo is required to build ferrisfw, please install cargo" >&2
    exit 1
}

command -v $objcopy > /dev/null 2>&1 || {
    echo "build.sh: objcopy for arm-none-eabi is required to build ferrisfw, please install arm-none-eabi-objcopy" >&2
    exit 1
}

command -v $firmtool > /dev/null 2>&1 || {
    echo "build.sh: firmtool is required to build ferrisfw, please install firmtool" >&2
    exit 1
}

#
# check for special build types
#

if [[ "$build_type" == "clean" ]]; then
    buildsh_clean
    exit 0
fi

#
# build ferrisfw
#

cd $project_root
mkdir build >/dev/null 2>&1
mkdir out >/dev/null 2>&1
cd build
case $build_type in
    release)
	buildsh_rust_build_arm9_release
	;;
    debug)
	buildsh_rust_build_arm9_debug
	;;
    *)
	echo "build.sh: unknown build type: $build_type"
	buildsh_usage
	exit 1
	;;
esac

buildsh_build_arm9_firm $build_type

