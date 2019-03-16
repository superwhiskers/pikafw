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
# dependency checks!
#

# check if firmtool is up to date
ifneq ($(strip $(shell firmtool -v 2>&1 | grep usage)),)
$(error "please install firmtool v1.1 or greater")
endif

#
# root directory configuration!
#

# set the root directory for the project
export project_root := $(CURDIR)

#
# general build configuration!
#

#
# name is the name of the project
# build is the directory where all of the build files are contained
# directories is a list of directories containing makefiles which build those components 
# output is the directory where the final artifacts are contained
#
export name   := pikafw
       build  := $(project_root)/build
       output := $(project_root)/out

# component directory paths
export directory_arm9  := $(project_root)/arm9
       directory_arm11 := $(project_root)/arm11

#
# targets!
#

#
# general build targets!
#

.PHONY: all
all: firm

.PHONY: release
release: $(output)/$(name).zip

.PHONY: firm
firm: $(output)/boot.firm

.PHONY: clean
clean: $(directories)
	@$(MAKE) -C $(directory_arm9) clean
	@$(MAKE) -C $(directory_arm11) clean

#
# file targets!
#

$(output)/$(name).zip: all
	@mkdir -p $(output)/$(name)

$(output)/boot.firm: $(build)/arm9.bin $(build)/arm11.bin
	@mkdir -p $(@D)
	@firmtool build $@ -n 0x08006800 -e 0x1FF80000 -D $^ -A 0x08006800 0x1FF80000 -C NDMA XDMA

$(build)/arm9.bin: $(directory_arm9)
	@mkdir -p $(@D)
	@$(MAKE) -C $<

$(build)/arm11.bin: $(directory_arm11)
	@mkdir -p $(@D)
	@$(MAKE) -C $<
