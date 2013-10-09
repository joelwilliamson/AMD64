/* printf takes a format string and a variable number of arguments
 * It then prints to stdout a string formed by inserting the arguments into the
 * format string.
 *
 * Backslash escaping conversion specifications is NOT currently supported
 *
 * The following conversion specifications are supported:
 *	%u - unsigned decimal
 *
 *
 * Example stack frame:
 * -----------------
 * return address
 * &"%u + %u = %u\n"
 * 10
 * 22
 * 32
 * -----------------
 * will print "10 + 22 = 32\n"
 *
 */

.global _printf

.global _print_integer
.global _exit

.text
_printf:
	push %rax
	push %rbx
	push %rcx
	push %rdx
	push %rdi
	push %rsi
	push %rbp


	mov 0x40(%rsp),%rax		# string ptr
	mov $0x48,%rbp			# Address of the first vararg
	add %rsp,%rbp
	mov %rax,%rcx			# Initialize %rcx
	
	
	loop:
		mov (%rax),%rbx
		and $0xff,%rbx
		push %rbx
#		call _print_integer
		pop %rbx
		cmp $0,%rbx		# Check for null byte
		je end_loop

		cmp $37,%rbx		# Check for beginning of conversion specifier (%)
		je conversion_specifier
		cmp $0,%rcx		# %rcx holds the pointer to the beginning of
		cmove %rax,%rcx		# a string to print whole
		inc %rax
		jmp loop

		conversion_specifier:
			mov %rax,%rdx
			sub %rcx,%rdx	# %rdx is the length of the string
			push %rax	# %rax is need for the syscall specification
			mov $1,%rax	# write()
			mov $1,%rdi	# stdout
			mov %rcx,%rsi	# buf
			syscall
			
			pop %rax	# restore the string pointer
			xor %rcx,%rcx	# no longer any string waiting to be printed
			inc %rax
			mov (%rax),%rbx	# Fetch the specifier
			inc %rax	# Update again
			cmp $117,%bl
			jne error	# Only accept %u
			unsigned_int:
				mov (%rbp),%rcx		# Get the int
				add $8,%rbp		# update the bp
				push %rcx
				call _print_integer
				pop %rcx
				xor %rcx,%rcx
				jmp loop
			error:
				push $0
				call _exit
	end_loop:

	mov %rax,%rdx		# Write the remnant of the string to stdout
	sub %rcx,%rdx
	mov $1,%rax
	mov $1,%rdi
	mov %rcx,%rsi
	syscall

	pop %rbp
	pop %rsi
	pop %rdi
	pop %rdx
	pop %rcx
	pop %rbx
	pop %rax
	ret
