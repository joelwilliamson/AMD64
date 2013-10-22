# #define FIRST_HARD_DRIVE 0x80
.set MAGICNUMBER, 0xdada

.code16
.global _start
.text
_start:
	movb $0x02, %ah	# int 13,2 is "Read Disk Sectors"
	movb $0x01, %al	#	al - Number of sectors to read
	# The second sector should be head 0 , cylinder 0, sector 2
	# (sectors are one-indexed)
	movb $0x00, %ch	#	ch - cylinder number
	movb $0x02, %cl	#	cl [7:6]cylinder, [5:0] sector
	movb $0x00, %dh	#	dh - drive head
	movb $0x83, %dl	#	dl - drive number (should be looped through 80-84)
	movw $0xff, %bx	#	bx - beginning of buffer to use
	int $0x13	# Read the sector

	movw %es:(%bx), %ax	# Grab the first word read
	cmpw $MAGICNUMBER, %ax	# Is it magic?
	
	movb $0x0e,%ah		# If it is magic, print a
	movb $0x00, %bh
	movb $0x5c,%al
	int $0x10


halt:
	jmp halt
