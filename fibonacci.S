.global _start
.global _print		# Needs linking with print_integer.o

.data
	newline: .ascii "\n"

.text
_start:
	# Get the command line arguments
	pop %r15	# r15 is argc
	pop %r14	# r14 is argv[0], "fibonacci"
	call _atoi
	push %rax
	call _print
#	call _print
#	pop %rax
#	pop %r9
	mov %rax, %r8	# Find the r8^th Fibonacci number
	xor %rax,%rax	# Counter
	xor %rbx,%rbx	# Previous
	xor %rcx,%rcx	# This
	inc %rbx

	loop:
		inc %rax
		add %rcx,%rbx	# Add the two and put it in previous
		# Swap
		mov %rbx,%rdx
		mov %rcx,%rbx
		mov %rdx,%rcx

		cmp %rax,%r8
		jne loop
	
	push %rbx
	call _print
	push $0
	call _exit
	
