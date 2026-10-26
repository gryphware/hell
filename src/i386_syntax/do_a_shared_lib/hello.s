	.include "linux_const.s"
	
	.section .data
hello_world:
	.ascii "Hello?"

	.section .text
	.globl _start
_start:
	pushl $hello_world
	call print_lib
	addl $4, %esp

	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
