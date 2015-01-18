	# Multiboot constants
	.set ALIGN,	1<<0	# Align loaded modules on page boundaries
	.set MEMINFO,	1 << 1	# Use a memory map
	.set FLAGS, 	ALIGN | MEMINFO
	.set MAGIC,	0x1BADB002	# The multiboot magic number
	.set CHECKSUM, -(MAGIC + FLAGS)

	# Multiboot header
	# This goes in its own section so we can place it at the start of the file
	.section .multiboot
	.align 4
	.long MAGIC
	.long FLAGS
	.long CHECKSUM



	# Stack
	.section .bootstrap_stack, "aw", @nobits	# A segment of memory must be allocated,
	# put into write mode, and nothing written to it
stack_bottom:
	.skip 16384	# The stack is 16K
stack_top:

	.section .text
	.global _start
	.type _start, @function
_start:
	# The bootloader (GRUB) jumps to this point

	# Initialize the stack pointer to point where we specified
	mov $stack_top, %esp

	# Call to the C function kernel_main
	call kernel_main

	# Disable interupts and halt the processor
	cli
	hlt

.size _start, . - _start
