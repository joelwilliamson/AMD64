#include <stddef.h>
#include <stdint.h>

#include "vga.hpp"
#include "long_mode.hpp"

extern "C" // Use C linkage for kernel_main

void kernel_main()
{
  char name[13];
  VGA_Text_Buffer vga((uint16_t*)0xB8000);

  vga.set_color(vga_color::GREEN,vga_color::BLACK);
  vga.put("Hello, World\n");
  vga.put("This is a very long string that should span several lines. " \
	       "It goes on and on and on and on and on and on. I think this " \
	       "should finally be long enough.\n");
  vga.put("These\twords\tare\tall\tseparated\tby\ttabs.\n");
  vga.set_fg(vga_color::BLUE);
  vga.put("Blue Words...\n");
  vga.set_fg(vga_color::RED);
  vga.put("Red Words...\n");
  vga.set_color(vga_color::CYAN,vga_color::MAGENTA);
  vga.put("Cyan on magenta words.\n");
  vga.put("This is more text.\n");
  if (has_cpuid()) {
    vga.set_color(vga_color::GREEN,vga_color::BLACK);
    vga.put("CPUID present.\n");
    cpu_name(name);
    vga.put(name);
    vga.put("\n");
  } else {
    vga.set_color(vga_color::RED,vga_color::BLACK);
    vga.put("CPUID not present.\n");
    vga.set_fg(vga_color::GREEN);
  }
  vga.put("Done.\n");
}
