#include <stddef.h>
#include <stdint.h>

const uint8_t tab_width = 4;

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
  
  void set_color(vga_color fg, vga_color bg) {
    color = (uint16_t(bg)<<4 | uint16_t(fg)) << 8;
  }

  void set_bg(vga_color bg) {
    color = uint16_t(bg) << 12 | color & 0x0F00;
  }

  void set_fg(vga_color fg) {
    color = color & 0xF000 | uint16_t(fg) << 8;
  }

  vga_color get_bg() const {
    return vga_color((0xF000 & color) >> 12);
  }

  vga_color get_bg_at(uint16_t row, uint16_t col) {
    return vga_color((0xF000 & at(row,col)) >> 12);
  }

  vga_color get_fg() const {
    return vga_color((0x0F00 & color) >> 8);
  }

  vga_color get_fg_at(uint16_t row, uint16_t col) {
    return vga_color((0x0F00 & at(row,col)) >> 8);
  }

  // Shift the text several lines up the screen
  void scroll(size_t lines = 4, vga_color fill=vga_color::BLACK) {
    uint16_t * ptr = buffer;
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

  void put_char (char c) {
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

  void put_cstr(const char * str) {
    while (*str) {
      put_char(*str++);
    }
  }
};

extern "C" // Use C linkage for kernel_main

void kernel_main()
{
  VGA_Text_Buffer vga((uint16_t*)0xB8000);

  vga.set_color(vga_color::GREEN,vga_color::BLACK);
  vga.put_cstr("Hello, World\n");
  vga.put_cstr("This is a very long string that should span several lines. " \
	       "It goes on and on and on and on and on and on. I think this " \
	       "should finally be long enough.\n");
  vga.put_cstr("These\twords\tare\tall\tseparated\tby\ttabs.\n");
  vga.set_fg(vga_color::BLUE);
  vga.put_cstr("Blue Words...\n");
  vga.set_fg(vga_color::RED);
  vga.put_cstr("Red Words...\n");
  vga.set_color(vga_color::CYAN,vga_color::MAGENTA);
  vga.put_cstr("Cyan on magenta words.\n");
  vga.scroll(1);
  vga.put_cstr("This is more text.\n");
  //  vga.scroll(1);
}
