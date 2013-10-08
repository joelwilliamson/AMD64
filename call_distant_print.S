.global _start
.global _print

.text
_start:
	pushq $4545
	call _print

	pushq $7878
	call _print

	mov $60,%rax
	mov $0,%rdi
	syscall
