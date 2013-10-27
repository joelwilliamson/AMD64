.global _atoi
.global _print

/* atoi takes a pointer to a string
 * Iterate through the string with
 * S as the sum so far, d current digit
 * S' = 10*S + d
 * This will assume no negatives!
 * The pointer is passed in %si
 */

.text
_atoi:
	xor %di,%di
	# si : ptr to the string yet to be processed
	# di : sum
	# al : next digit
	loop:
		xor %cx,%cx		# Zero out the upper bits of rcx
		movb (%si),%cl		# cl has the ascii rep of next digit
		cmp $0,%cl		# Check for null byte
		je end
		cmp $48,%cl		# Check for non-digit (too low)
		jb end
		cmp $58,%cl		# Check for non-digit (too high)
		jge end
		inc %si
		sub $48,%cl		# cl has the decimal value
		mov $10,%al
		mul %di
		add %cl,%ax
		mov %ax,%di
		jmp loop
	end:

	mov %di,%ax			# Move the result into %ax to return
	ret
