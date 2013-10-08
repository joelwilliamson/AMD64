.data
	str1: .asciz "This is a string.\n"
	str2: .asciz "Another string.\n"

.global _start
.text
_start:

	push $str1
	call _print_string
	pop %rax

	push $str2
	call _print_string
	pop %rax


	push $0
	call _exit
