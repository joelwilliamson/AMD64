# print takes the address of the c-string to print
# in %si:(%bx)
print:
	push %ax
	push %bx
print_loop:
	movb %si:(%bx), %al	# Get the next byte
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
