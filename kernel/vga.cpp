#include <stddef.h>
#include <stdint.h>

#include "vga.hpp"

const uint8_t tab_width = 4;

// Find the length of a null-terminated string
size_t strlen (const char* str) {
  size_t size = 0;
  while (*(str++)) ++size;
  return size;
}

uint16_t VGA_Text_Buffer::make_entry(char c) {
  return color | c;
}

uint16_t& VGA_Text_Buffer::at(uint16_t row, uint16_t col) {
  return buffer[row*cols + col];
}
  
VGA_Text_Buffer::VGA_Text_Buffer(uint16_t * buffer)
  : buffer(buffer),
    row(0),
    col(0)
{
  set_color(vga_color::LIGHT_GREY,vga_color::BLACK);
}
  
void VGA_Text_Buffer::set_color(vga_color fg, vga_color bg) {
  color = (uint16_t(bg)<<4 | uint16_t(fg)) << 8;
}

void VGA_Text_Buffer::set_bg(vga_color bg) {
  color = (uint16_t(bg) << 12) | (color & 0x0F00);
}

void VGA_Text_Buffer::set_fg(vga_color fg) {
  color = (color & 0xF000) | (uint16_t(fg) << 8);
}

vga_color VGA_Text_Buffer::get_bg() const {
  return vga_color((0xF000 & color) >> 12);
}

vga_color VGA_Text_Buffer::get_bg_at(uint16_t row, uint16_t col) {
  return vga_color((0xF000 & at(row,col)) >> 12);
}

vga_color VGA_Text_Buffer::get_fg() const {
  return vga_color((0x0F00 & color) >> 8);
}

vga_color VGA_Text_Buffer::get_fg_at(uint16_t row, uint16_t col) {
  return vga_color((0x0F00 & at(row,col)) >> 8);
}

// Shift the text several lines up the screen
void VGA_Text_Buffer::scroll(size_t lines, vga_color fill) {
  for (size_t row = 0; row + lines < rows; ++row) {
    for (size_t col = 0; col < cols; ++ col) {
      at(row,col) = at(row+lines,col);
    }
  }

  // Save the color
  vga_color bg = get_bg();
  vga_color fg = get_fg();
  // Make the foreground and background the same color
  set_color(fill,fill);
  for (size_t row = rows > lines ? rows - lines : 0;
       row < rows;
       ++row) {
    for (size_t col = 0; col < cols; ++col) {
      at(row,col) = make_entry(' ');
    }
  }
  // Restore the color
  set_color(fg,bg);
  row = row >= lines ? row - lines : 0;
}

void VGA_Text_Buffer::put_char (char c) {
  if (c == '\n') {
    col = -1; // The column get incremented at the end, need to counteract that
    ++row;
  } else if (c == '\t') {
    col = col - (col % tab_width) + tab_width - 1;
  } else {
    at(row,col) = make_entry(c);
  }
  if (++col >= cols) {
    ++row;
    col = 0;
  }
  if (row >= rows) scroll();
}

void VGA_Text_Buffer::put_cstr(const char * str) {
  while (*str) {
    put_char(*str++);
  }
}
