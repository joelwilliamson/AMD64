CXXFLAGS=-fno-exceptions -fno-rtti -ffreestanding --std=gnu++11 -Wall -Wextra

multiboot-header: boot.S
	i686-elf-as boot.S -o boot.o

vga: vga.hpp vga.cpp
	i686-elf-g++ $(CXXFLAGS) -c vga.cpp -o vga.o

long_mode: long_mode.cpp long_mode.hpp
	i686-elf-g++ $(CXXFLAGS) -c long_mode.cpp -o long_mode.o

kernel: kernel.cpp kernel.hpp
	i686-elf-g++ $(CXXFLAGS) -c kernel.cpp -o kernel.o

assemble: kernel vga multiboot-header long_mode
	i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o vga.o long_mode.o -lgcc

grub: assemble grub.cfg
	mkdir -p iso/boot/grub
	mv myos.bin iso/boot/myos.bin
	cp grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso iso
