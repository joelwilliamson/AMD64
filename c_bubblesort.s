	.file	"c_bubblesort.c"
	.text
	.globl	bubblesort
	.type	bubblesort, @function
bubblesort:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movb	$0, -1(%rbp)
.L5:
	movq	-40(%rbp), %rax
	movq	%rax, -16(%rbp)
	jmp	.L2
.L4:
	movq	-16(%rbp), %rax
	movl	(%rax), %edx
	movq	-16(%rbp), %rax
	addq	$4, %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	jle	.L3
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -20(%rbp)
	movq	-16(%rbp), %rax
	movl	4(%rax), %edx
	movq	-16(%rbp), %rax
	movl	%edx, (%rax)
	movq	-16(%rbp), %rax
	leaq	4(%rax), %rdx
	movl	-20(%rbp), %eax
	movl	%eax, (%rdx)
	movb	$1, -1(%rbp)
.L3:
	addq	$4, -16(%rbp)
.L2:
	movq	-16(%rbp), %rdx
	movq	-40(%rbp), %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	sarq	$2, %rax
	movq	%rax, %rdx
	movl	-44(%rbp), %eax
	subl	$1, %eax
	cltq
	cmpq	%rax, %rdx
	jl	.L4
	cmpb	$0, -1(%rbp)
	jne	.L5
	movq	-40(%rbp), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	bubblesort, .-bubblesort
	.ident	"GCC: (GNU) 4.8.1 20130725 (prerelease)"
	.section	.note.GNU-stack,"",@progbits
