#
# pikafw - 3ds custom firmware in rust
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

#
# root directory configuration!
#

# set the root directory for this project
export project_root := $(CURDIR)

# set the root directory for the entire project
export outer_project_root := $(project_root)/../

#
# general build configuration!
#

#
# name is the name of the project (should match the one set in Cargo.toml)
# build is the directory where all of the build files are contained
# output is the directory where the final artifacts are contained
# manifest is the Cargo.toml file to instruct cargo to use
#
export name     := pikafw-arm11
       build    := $(project_root)/build
       output   := $(project_root)/out
       manifest := $(project_root)/Cargo.toml

# target specification loaction
export spec := $(outer_project_root)/assets/arm11.json

#
# build flags!
#

#
# rustflags are the flags passed to rustc
# cargoflags are the flags passed to cargo
#
export cargoflags :=
       rustflags  :=

#
# targets!
#

#
# general build targets!
#

.PHONY: all
all: bin

.PHONY: bin
bin: $(output)/arm11.bin

.PHONY: clean
clean:
	@cargo clean
	@rm -rf $(output) $(build)

#
# file targets!
#

$(output)/arm11.bin:
	@mkdir -p $(@D)
	@cargo rustc                    \
	    --release                   \
	    --target-dir $(build)       \
	    --manifest-path $(manifest) \
	    --target $(spec)            \
	    $(cargoflags)               \
	    --                          \
	    -C opt-level=3              \
	    -C lto=thin                 \
	    -C debuginfo=0              \
	    -C link-arg=-Tlayout.ld     \
	    $(rustflags)
	@arm-none-eabi-objcopy -O binary $(build)/arm11/release/$(name).elf $@

