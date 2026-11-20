    .include "do_a_shared_lib/linux_const.s"
    .include "do_a_shared_lib/record_def.s"
    .type write_lib, @function
    .globl write_lib

    .equ ST_FILEDES, 12
    .equ ST_BUFFER_READ, 8

write_lib:
    pushl %ebp
    movl %esp, %ebp

    pushl %ebx            #keep things from label _start from main program

    #write lib (write syscall in linux)
    movl $SYS_WRITE, %eax
    movl ST_FILEDES(%ebp), %ebx
    movl ST_BUFFER_READ(%ebp), %ecx
    movl $RECORD_SIZE, %edx

    int $LINUX_SYSCALL

    popl %ebx

    movl %ebp, %esp
    popl %ebp
    ret
