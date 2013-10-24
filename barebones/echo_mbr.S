.code16
.global _start
.text
_start:
loop:
	# Set up registers for reading a character from keyboard
	movb $0,%ah
	int $0x16	# int 16,0 is read character
			# http://stanislavs.org/helppc/int_16-0.html
			# ah = keyboard scan code
			# al = ASCII (0 if special character)
	# Set up the registers for teletype output
	cmp $0x0d,%al	# Check if the input was a line feed
	je newline
	movb $0x0e,%ah	# int 10,e is teletype
	xorb %bh,%bh	# write to page 0
	int $0x10	# No returns

	jmp loop

newline:
	movb $0x0e,%ah
	xorb %bh,%bh
	int $0x10
	movb $0x0a,%al
	movb $0x0e,%ah
	xorb %bh,%bh
	int $0x10

	jmp loop
