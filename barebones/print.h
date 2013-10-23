# print takes the address of the c-string to print
# in (%bx)
print:
	push %ax
	push %bx
print_loop:
	movb (%bx), %al	# Get the next byte
	cmpb $0x00,%al
	je end_print
	movb $0x0e,%ah
	int $0x10		# int 10,e - teletype output
				#	%al - character to print
	inc %bx
	jmp print_loop

end_print:
	pop %bx
	pop %ax
	ret


# print_es takes the address of the c-string to print
# in %es:(%bx)
print_es:
	push %ax
	push %bx
print_loop_es:
	movb %es:(%bx), %al	# Get the next byte
	cmpb $0x00,%al
	je end_print_es
	movb $0x0e,%ah
	int $0x10		# int 10,e - teletype output
				#	%al - character to print
	inc %bx
	jmp print_loop_es

end_print_es:
	pop %bx
	pop %ax
	ret
