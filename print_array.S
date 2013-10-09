.global _print_array
.global _print_integer
.global _exit

/* Take an array of integers and a length,
 * and print the integers separated by spaces.
 * --------------
 * return address
 * array ptr
 * array length
 */

.text
_print_array:
	push %rax
	push %rbx
	push %rcx
	mov 0x20(%rsp),%rax		# ptr
	mov 0x28(%rsp),%rbx		# length

	loop:
		cmp $0,%rbx
		je end_loop

		dec %rbx
		push (%rax)
		call _print_integer
		pop %rcx
		add $8,%rax
		jmp loop
	end_loop:

	pop %rcx
	pop %rbx
	pop %rax
	ret
