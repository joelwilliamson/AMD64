.global _exit
.text
_exit:
	mov $60,%rax	# exit()
	mov 0x8(%rsp),%rdi	# exit code
	syscall
