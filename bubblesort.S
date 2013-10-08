# Bubblesort repeatedly iterates over a list,
# swapping pairs of numbers if they are misordered.
# If the list is of length l, best case is O(n) if
# the list is sorted, average case is O(n^2) if the
# list is unsorted, worst case O(n^2)

.intel_syntax noprefix

.data
	array:
		.quad 9
		.quad 4
		.quad 0
		.quad 3
		.quad 7
		.quad 6
		.quad 5
		.quad 1
		.quad 8
		.quad 2
	array_end:

	.set array_length, array_end - array
.bss
	.lcomm ascii_rep,1

.text
	.global _start
_start:
	# Testing the print method
	mov r9, offset array
	jmp Print_Single_Digits


	xor r15,r15			# r15 is set to nonzero if a swap occurs
	mov r14,offset array
	mov r13,offset array
	add r13,1			# The offset of the second variable

Compare_and_Swap:
	mov rax,(r14)			# Get the first of the two variables
	mov rbx,(r13)
	cmp rax,rbx
	cmovg (r14), rbx		# If the variables are <=, don't swap
	cmovg (r13), rax		# If they are >, do swap
	cmovg r15,r13			# Set the flag to non-zero (r13>r14>=0)

	add r13,1
	add r14,1			# Advance to next pair

	cmp r13,array_end		# If we aren't at the end of the array,
	jb Compare_and_Swap		# keep looping

	cmp r15,0			# If no swaps occurred, make another pass
	jne _start

	mov r9, offset array
Print_Single_Digits:
	# Print out an array of single digits
	mov rdi,1			# stdout
	mov rsi,offset ascii_rep
	mov r10,[r9]
	mov [rsi],r10
	mov rdx,8			# length
	mov rax,1			# write()
	syscall

	add r9,8
	cmp r9,offset array_end
	jb Print_Single_Digits

	mov rax,60			# exit()
	syscall
