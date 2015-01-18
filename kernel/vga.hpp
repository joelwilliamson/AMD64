#pragma once

#include <stddef.h>
#include <stdint.h>

enum class vga_color {
    BLACK = 0,
    BLUE = 1,
    GREEN = 2,
    CYAN = 3,
    RED = 4,
    MAGENTA = 5,
    BROWN = 6,
    LIGHT_GREY = 7,
    DARK_GREY = 8,
    LIGHT_BLUE = 9,
    LIGHT_GREEN = 10,
    LIGHT_CYAN = 11,
    LIGHT_RED = 12,
    LIGHT_MAGENTA = 13,
    LIGHT_BROWN = 14,
    WHITE = 15,
};

// Find the length of a null-terminated string
size_t strlen (const char* str);
  
class VGA_Text_Buffer {
  uint16_t color; // This constant take the form 0xBF00

  uint16_t * const buffer;

  size_t row;
  size_t col;
  const size_t rows = 25;
  const size_t cols = 80;

  uint16_t make_entry(char c);
  uint16_t& at(uint16_t row, uint16_t col);
  
public:

  explicit VGA_Text_Buffer(uint16_t * buffer);
  
  void set_color(vga_color fg, vga_color bg);
  void set_bg(vga_color bg);
  void set_fg(vga_color fg);
  vga_color get_bg() const;
  vga_color get_bg_at(uint16_t row, uint16_t col);
  vga_color get_fg() const;
  vga_color get_fg_at(uint16_t row, uint16_t col);
  // Shift the text several lines up the screen
  void scroll(size_t lines = 4, vga_color fill=vga_color::BLACK);
  void put(char c);
  void put(const char * str);
  void put(uint32_t hex);
};

