    .include "src/linux_const.s"
    .include "src/record_def.s"

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

    .long 20

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

    movl %eax, ST_OUTPUT_FILEDES(%ebp)

    push ST_OUTPUT_FILEDES(%ebp)
    push $record1
    call write_record
    addl $8, %esp

    movl $SYS_CLOSE, %eax
    movl ST_OUTPUT_FILEDES(%ebp), %ebx
    int $LINUX_SYSCALL

    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
