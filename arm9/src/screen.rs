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

use crate::colors::Color;

pub const VRAM_START: u32 = 0x18300000;
pub const TOP_SCREEN: u32 = VRAM_START;
pub const TOP_VRAM_LENGTH: u32 = 400 * 240 * 4;
pub const BOTTOM_SCREEN: u32 = VRAM_START + TOP_VRAM_LENGTH;
pub const BOTTOM_VRAM_LENGTH: u32 = 320 * 240 * 4;
pub const VRAM_END: u32 = VRAM_START + TOP_VRAM_LENGTH + BOTTOM_VRAM_LENGTH;

/// height of both screens
pub const SCREEN_HEIGHT: u32 = 240;

macro_rules! pixel_offset {
    ($x:expr, $y:expr) => {
        ($x * SCREEN_HEIGHT) + (SCREEN_HEIGHT - $y - 1)
    };
}

/// a struct representing one of the two screens of the 3ds
pub struct Screen {
    start: u32,
    width: u32,
}

impl Screen {
    pub const fn new(start: u32, width: u32) -> Screen {
        Screen { start, width }
    }

    pub fn clear(&self, color: Color) {
        let color = color as u32 | (color as u32) << 16;
        for i in 0..self.width * SCREEN_HEIGHT / 2{
            unsafe {
                *(self.start as *mut u32).offset(i as isize) = color;
            }
        }
    }

    pub fn get_color(&self, x: u32, y: u32) -> u32 {
        unsafe { *(self.start as *const u32).offset(pixel_offset!(x, y) as isize) }
    }

    pub fn set_color(&self, x: u32, y: u32, color: u32) {
        unsafe {
            *(self.start as *mut u32).offset(pixel_offset!(x, y) as isize) = color;
        }
    }
}

/// the top screen
pub const SCREEN_TOP: Screen = Screen {
    start: TOP_SCREEN,
    width: 400,
};

/// the bottom screen
pub const SCREEN_BOTTOM: Screen = Screen {
    start: BOTTOM_SCREEN,
    width: 320,
};
