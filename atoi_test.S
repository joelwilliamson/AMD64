.global _start
.global _atoi
.global _print_integer

.data
	numstring: .ascii "51234"

.text
_start:
	push $numstring
	call _atoi
	pop %rbx	# clear the stack and toss the value

	push %rax	# Put the integer to be printed
	call _print_integer
	pop %rax


	mov $60,%rax	# exit()
	mov $0,%rdi
	syscall		# exit(0)
