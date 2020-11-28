/*

pikafw - 3ds custom firmware in rust
Copyright (C) 2019 superwhiskers <whiskerdev@protonmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

*/

#![no_std]
#![no_main]

#![feature(global_asm)]

mod panic;

// include the assembly file that provides the _start function
global_asm!(include_str!("start.s"));

#[no_mangle]
pub extern "C" fn main() -> ! {
    // there's really nothing to do rn
    loop {}
}
