.code16
.global _start
.text
_start:
	movw $msg,%di
	loop:
		movb 0x0(%di),%al
		cmpb $0,%al
		je stop
		movb $0x0e,%ah	# Use teletype output
		int $0x10
		inc %di
		jmp loop

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
