	.type print_lib, @function
	.globl print_lib
	
	.include "linux_const.s"

	.equ ST_BUFFER, 12
	
	.section .text
	.globl print_lib
print_lib:

	pushl %ebx
	pushl %ebp
	movl %esp, %ebp
	
	#do thing
	pushl ST_BUFFER(%ebp)
	call strlen
	addl $4, %esp
	
	movl %eax, %edx
	movl $SYS_WRITE, %eax
	movl ST_BUFFER(%ebp), %ecx
	movl $STDOUT, %ebx
	int $LINUX_SYSCALL

	popl %ebx
	popl %ebp
	ret
	
	
	
	
	
	
