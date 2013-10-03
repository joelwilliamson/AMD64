.intel_syntax noprefix
# Read whatever is on stdin and write it to stdout
.global _start

.data
	.set length, 1		# Single character processing allows easy
				# identification of ^D
	.ascii "This string should appear in the assembled version."
.bss
	.lcomm buff, length

.text
	_start:

Read_Next_Byte:
	mov rsi,offset buff	# location to store the read data
	mov rdi,0 		# stdin
	mov rdx,length
	mov rax,0		# read()
	syscall

	# Check if we failed to read any characters => EOF
	xor r9,r9
	xor r10,r10
	add r10,1
	cmp rax,0
	cmove r9,r10		# Set r9 if no characters read

	mov rdx,rax		# read() returns the number of bytes read
	mov rdi,1		# stdout
	mov rax,1		# write()
	syscall

	# If any characters were read, there might be more waiting
	cmp r9,0
	je Read_Next_Byte

	mov rax,60		# exit()
	syscall
