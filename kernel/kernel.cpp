#include <stddef.h>
#include <stdint.h>

#include "vga.hpp"

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
