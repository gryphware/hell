	.type strlen, @function
	.globl strlen

	.equ ST_BUFFER_ADDRESS, 8
strlen:

	pushl %ebp
	movl %esp, %ebp
	
	movl $0, %ecx
	movl ST_BUFFER_ADDRESS(%ebp), %edx

loop:
	movb (%edx), %al

	cmpb $0, %al
	je end_loop

	incl %edx
	incl %ecx

	jmp loop

end_loop:
	movl %ecx, %eax
	popl %ebp
	ret
	
	
