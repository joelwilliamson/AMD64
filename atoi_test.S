.global _start
.global _atoi
.global print_integer

.data
	numstring: .ascii "51234a8"

.text
_start:
	push $numstring
	call _atoi
	pop %rbx	# clear the stack and toss the value

	push %rax	# Put the integer to be printed
	call _print
	pop %rax

	mov 0x10(%rsp),%r9	# Get argv
	mov (%r9),%r9	# Get argv[0]
	push %r9
	call _atoi
	pop %r9
	push %rax
	call _print

	mov $60,%rax	# exit()
	mov $0,%rdi
	syscall		# exit(0)
