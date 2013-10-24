#define FIRST_HARD_DRIVE 0x80
#define MAGICNUMBER 0xdada
.code16


.global _start
.text
_start:
	mov $start_message, %bx	# Get the address of the message
	call print
	movb $0x02, %ah	# int 13,2 is "Read Disk Sectors"
	movb $0x01, %al	#	al - Number of sectors to read
	# The second sector should be head 0 , cylinder 0, sector 2
	# (sectors are one-indexed)
	movb $0x00, %ch	#	ch - cylinder number
	movb $0x02, %cl	#	cl [7:6]cylinder, [5:0] sector
	movb $0x00, %dh	#	dh - drive head
	movb $0x80, %dl	#	dl - drive number (should be looped through 80-84)
drive_loop:
	movw $0xff, %bx	#	bx - beginning of buffer to use
	int $0x13	# Read the sector

	movw %es:(%bx), %ax	# Grab the first word read
	movw %bx,%si		# Save the address of the read memory
	cmpw $MAGICNUMBER, %ax	# Is it magic?
	je found
	
	mov $not_found_message, %bx
	call print
	mov %si,%bx
	call print_es

	cmpb $0x84,%dl
	je halt
	inc %dl
	jmp drive_loop

found:	mov $found_message, %bx
	call print
	mov %si,%bx		# Restore the address of the read memory
	call print_es
	jmp halt
halt:
	jmp halt

start_message:
	.asciz "Checking for magic 0xdada\n\r"
found_message:
	.asciz "Magic found\n\r"
not_found_message:
	.asciz "Magic not found\n\r"

#include "print.h"
