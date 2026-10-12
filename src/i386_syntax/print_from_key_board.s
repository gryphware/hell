    .include "linux_const.s"

    .equ BUFFER_SIZE, 100

    .section .bss
    .lcomm BUFFER_DATA, BUFFER_SIZE

    .section .text
    .globl _start
_start:
    movl $SYS_READ, %eax
    movl $STDIN, %ebx
    movl $BUFFER_DATA, %ecx
    movl $BUFFER_SIZE, %edx

    int $LINUX_SYSCALL

    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl $BUFFER_DATA, %ecx
    movl $BUFFER_SIZE, %edx

    int $LINUX_SYSCALL

    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
