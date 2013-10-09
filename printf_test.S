.global _printf
.global _exit
.global _start
.global _print_integer

.data
	str1: .asciz "%u + %u = %u\n"

.text
_start:
	pushq $32
	pushq $22
	pushq $10
	pushq $str1
	call _printf	# printf("%u + %u = %u\n",10,22,32)

	push $0
	call _exit
