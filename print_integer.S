# Prints an int to stdin, formatted as a base-10 number
.global _start
.global _print_integer

.set write_code,1
.set exit_code,60
.set zero_offset,48

.data
	newline_buffer: .ascii "\n"
.bss
	.lcomm digit,1
.text
/*
Following are several lines of code used in the testing of this program
_start:
	# Print the int backwards to start
	# Registers:	rax : syscall/divident
	#		rbx : base
	#		rdx : divident tail (ie value to print)
	

	pushq $9191
	call _print

	mov $60,%rax
	mov $0,%rdi
	syscall			# exit(0)
*/

_print_integer:
	# _print is a wrapper around print_actual that preserves the values of all
	# registers. This should ease its use in debugging, where I might not
	# wish to go to the effort of saving several registers
	push %rax
	push %rbx
	push %rsp
	push %rdx
	push %r15
	push %rsi
	push %rdi

	movq 0x40(%rsp),%rax
	push %rax
	call print_actual
	pop %rax


	pop %rdi
	pop %rsi
	pop %r15
	pop %rdx
	pop %rsp
	pop %rbx
	pop %rax
	ret

print_actual:
	# --------
	# return address
	# number to print in decimal
	
	mov $10,%rbx		# Print in base 10
	movq 0x8(%rsp),%rax	# Load the value to print from the stack

	# rbx : base
	# rax : value
	xor %rdx,%rdx	# 0 extend rax:rdx
	divq %rbx	# quotient -> rax, remainder -> rdx
	push %rdx
	push %rax
	cmp $0,%rax
	je print_digit

	# ------
	# remaining value
	# current digit
	# return address
	# previous value
	# previous digit
	call print_actual
	print_digit:
		pop %r15
		call print_single_digit
	pop %r15
	ret



print_single_digit:
	# The top of the stack here should have
	# --------
	# address to return to
	# digit to print
	movb 0x8(%rsp),%al	# Get the digit from the stack
	add $48,%al		# Convert the digit to ascii
	mov %al,digit

	mov $1,%rax		# write()
	mov $1,%rdi		# stdout
	mov $digit, %rsi	# buf
	mov $1,%rdx		# len

	syscall

	ret

