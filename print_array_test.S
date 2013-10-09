.global _print_array
.global _start
.global _exit

.data
	array:
		.quad 1
		.quad 4
		.quad 16
		.quad 64
		.quad 256
		.quad 1024
		.quad 4096
		.quad 16384
		.quad 65536
		.quad 262144
	end_array:
	.set array_length, (end_array-array)/8

.text
_start:
	push $array_length
	push $array
	call _print_array
	push $0
	call _exit
