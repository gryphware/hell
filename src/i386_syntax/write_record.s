    .include "do_a_shared_lib/linux_const.s"
    .include "do_a_shared_lib/record_def.s"

    .section .data
record1:
    .ascii "Chanh\n\0"
    .rept 33
    .byte 0
    .endr

    .ascii "Duy\n\0"
    .rept 35
    .byte 0
    .endr

    .ascii "home\n\0"
    .rept 234
    .byte 0
    .endr

    .ascii "20\n\0"

file_name:
    .ascii "hello.dat\0"

    .equ ST_OUTPUT_FILEDES, -4

    .section .text
    .globl _start
_start:
    movl %esp, %ebp
    subl $4, %esp

    #trying open file
    movl $SYS_OPEN, %eax
    movl $file_name, %ebx
    movl $0101, %ecx            #create it when file doesnt exist, and open for write only
    movl $0666, %edx            #permit for all user

    int $LINUX_SYSCALL

    cmpl $0, %eax
    jle open_failed

    movl %eax, ST_OUTPUT_FILEDES(%ebp)

    push ST_OUTPUT_FILEDES(%ebp)
    push $record1
    call write_lib
    addl $8, %esp

    #when it done, jmp to success one
    jmp successful_exit
  
open_failed:
    movl %eax, %ebx
    movl $SYS_CLOSE, %eax
    int $LINUX_SYSCALL

    movl $SYS_EXIT, %eax
    movl $1, %ebx
    int $LINUX_SYSCALL
  
successful_exit:
    movl $SYS_CLOSE, %eax
    movl ST_OUTPUT_FILEDES(%ebp), %ebx
    int $LINUX_SYSCALL

    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
