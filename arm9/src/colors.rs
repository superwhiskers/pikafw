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

macro_rules! rgb {
    ($r:expr, $g:expr, $b:expr) => {
        ($r as u32 >> 3) << 11 | ($g as u32 >> 2) << 5 | ($b as u32 >> 3)
    };
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u32)]
pub enum Color {
    Black = rgb![0, 0, 0],
    White = rgb![255, 255, 255],
    Grey = rgb![128, 128, 128],

    Red = rgb![255, 0, 0],
    Green = rgb![0, 255, 0],
    Blue = rgb![0, 0, 255],
}
