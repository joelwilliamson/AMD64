.intel_syntax noprefix
.global _start
.data
	message: .ascii "Hello World!\n"
	len = . - message

.text
 _start:
	mov rax, 0x1		# write() is syscall 0
	# write(fd,buffer,length)
	mov rdi, 0x1		# stdout is fd 1
	mov rsi, offset message
	mov rdx,len		# message is 13 bytes long
	syscall
	mov rax, 0x3c		# exit()
	syscall
