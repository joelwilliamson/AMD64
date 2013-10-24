#define FIRST_HARD_DRIVE 0x80
#define MAGICNUMBER 0xdada
#define CODE_MAGIC 0xadad
.code16

# load_code copies the second sector of the hard disk into the code segment,
# then executes the code. It expects the following to be in the first sector:
# 1. The magic number 0xdada
# 2. A zero terminated message to print.
# 3. The magic number 0xadad, aligned to word boundaries
# 4. 2-bytes containing the length of the code
# 5. The code to execute

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

	# Copy the read data from the extended segment into the code segment,
	# then jump to the beginning of the new code
skip_message:
	movw %es:(%bx), %ax	# Check the next word
	cmpw $CODE_MAGIC, %ax
	je found_code_magic	# Once we find the magic, break from the loop
	add $2, %bx		# Go to the next word
	jmp skip_message	# Keep looping
found_code_magic
	add $2, %bx		# Pass the magic number
	movw %es:(%bx), %cx	# Get the number of bytes to read
	add $2, %bx		# Go to the beginning of the code
	movw $end, %dx		# Start storing the code after everything important
	code_copy_loop:
		movw %es:(%bx), %si
		movw %si,(%dx)
		add $2,%bx
		add $2,%dx
		sub $2,%cx
		cmp $0,%cx	# Check if we have read all the bytes
		jnbe code_copy_loop
	jmp end
	

halt:
	jmp halt

start_message:
	.asciz "Checking for magic 0xdada\n\r"
found_message:
	.asciz "Magic found\n\r"
not_found_message:
	.asciz "Magic not found\n\r"

#include "print.h"

# ENSURE NOTHING FOLLOWS THIS LABEL!!
# It will be overwritten when new code is copied in from disk
_end:
