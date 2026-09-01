	.include "src/linux_const.s"

	.section .data
newline:
	.ascii "\n"

	.equ ST_FILEDES, 12
	
	.type write_newline, @function
	.globl write_newline

	.section .text
write_newline:
	
	pushl %ebp
	movl %esp, %ebp

	pushl %ebx
	
	movl $SYS_WRITE, %eax
	movl ST_FILEDES(%ebp), %ebx
	movl $newline, %ecx
	movl $1, %edx

	int $LINUX_SYSCALL

	popl %ebx

	movl %ebp, %esp
	popl %ebp

	ret
