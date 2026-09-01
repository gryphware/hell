    .include "src/linux_const.s"
    .include "src/record_def.s"
    .type write_record, @function
    .globl write_record

    .equ ST_FILEDES, 12
    .equ ST_BUFFER_READ, 8

write_record:
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
