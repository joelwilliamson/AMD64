.global _start
.global _print		# Needs linking with print_integer.o

.data
	newline: .ascii "\n"

.text
_start:
	# Get the command line arguments
	# The number of command line arguments is the number to calculate
	mov (%rsp),%r9	# argc
	mov %r9, %r8	# Find the nth Fibonacci number
	xor %rax,%rax	# Counter
	xor %rbx,%rbx	# Previous
	xor %rcx,%rcx	# This
	inc %rbx

	loop:
		inc %rax
		add %rcx,%rbx	# Add the two and put it in previous
		xor %rcx,%rbx	# Swap
		xor %rbx,%rcx
		xor %rcx,%rbx

		push %rax
		push %rbx
		push %rcx
		call _print
		mov $1,%rax	# Print a newline
		mov $1,%rdi	# stdout
		mov $newline,%rsi
		mov $1,%rdx	#len
		syscall

		pop %rcx
		pop %rbx
		pop %rax

		cmp %rax,%r8
		jne loop
	
	mov $60,%rax
	mov $0,%rdi
	syscall

	
