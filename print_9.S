.intel_syntax noprefix
.global _start
.data
	number = 9
.bss
	.lcomm char_buff,1

.text
_start:
	mov al,number
	add al,48
	mov char_buff,al

	mov rax,1	#write()
	mov rdi,1	# stdout
	mov rsi,offset char_buff # buf
	mov rdx,1	# len
	syscall

	mov rax,60	# exit()
	mov rdi,0	# exit code
	syscall
