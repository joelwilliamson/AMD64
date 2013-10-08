.global _print_string

# ---------
# return address
# ptr to string
# ---------

.text
_print_string:
	push %rax
	push %rsi	# Use this for variable ptr
	push %rdi
	push %rdx	# Use this for length
	mov 0x28(%rsp),%rsi

	xor %rdx,%rdx
	loop:
		cmpb $0,(%rsi)
		je end_loop
		inc %rsi
		inc %rdx
		jmp loop
	end_loop:

	mov $1,%rax		# write()
	mov $0,%rdi		# stdout
	mov 0x28(%rsp),%rsi	# buf
	# %rdx already has the length
	syscall

	pop %rdx
	pop %rdi
	pop %rsi
	pop %rax
	ret
