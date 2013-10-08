.global _atoi
.global _print

/* atoi takes a pointer to a string
 * Iterate through the string with
 * S as the sum so far, d current digit
 * S' = 10*S + d
 * This will assume no negatives!
 */

.text
_atoi:
	xor %rdi,%rdi
	# rsi : ptr to the string yet to be processed
	# rdi : sum
	# al : next digit
	mov 8(%rsp),%rsi		# A pointer to the string
	loop:
		xor %rcx,%rcx		# Zero out the upper bits of rcx
		movb (%rsi),%cl		# rcx has the ascii rep of next digit
		cmp $0,%cl		# Check for null byte
		je end
		inc %rsi
		sub $48,%cl		# rcx has the decimal value
		mov $10,%rax
		mul %rdi
		add %rcx,%rax
		mov %rax,%rdi
		jmp loop
	end:

	mov %rdi,%rax			# Move the result in %rax to return
	ret
