.code16
.global _start
.text
_start:
	movw $msg,%di
	loop:
		movb 0x0(%di),%al
		cmpb $0,%al
		je read_message
		movb $0x0e,%ah	# Use teletype output
		int $0x10
		inc %di
		jmp loop

read_message:
	mov %sp,%di		# Store the stack pointer so we can read the whole string
	mov %sp,%si		# Use %si to index the stack
	read_loop:
		xorb %bh,%bh	# Get from page 0
		movb $0x08, %ah
		int $0x10	# Get the character at cursor into al
		inc %si
		mov %al, (%si)	# Push the character onto the stack
		cmp $0x0a,%al	# If the character was '\n', write the string
		je write_message
		jmp read_loop

write_message:
	write_loop:
		inc %di
		movb (%di),%al	# Get the next byte
		cmp $0x0a,%al	# If the character was '\n', read another string
		je read_message
		movb $0x0e,%ah	# Teletype output
		int $0x10
		jmp write_loop


	stop: jmp stop
	

.data
	msg: .asciz "Hello World!"

	.fill 5,1,0x00 # Alignment
	.byte 0x80 # Bootable
	.byte 0x00 # This head
	.byte 0x00 # This cylinder
	.byte 0x01 # Next sector
	.byte 0xff # No partition/filesystem
	.byte 0xff # Ending Head number
	.word 0xffff # Ending cylinder & sector numbers
	.byte 0x01 # Starting sector
	.fill 3,1,0x00 # More starting sector
	.fill 4,1,0xff # Number of sectors in partition

	.fill 48,1,0xff # Other partitions are blank

	.byte 0x55
	.byte 0xAA
