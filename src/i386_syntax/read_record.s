    .include "src/linux_const.s"
    .include "src/record_def.s"

    .section .data
file_name:
    .ascii "hello.dat\0"

    .section .bss
    .lcomm BUFFER_DATA, RECORD_SIZE

    .section .text
    .equ ST_INPUT_FILEDES, -4
    .equ ST_OUTPUT_FILEDES, -8

    .globl _start
_start:

    #define stack in _start and make
    #some spaces for store two file
    #descriptors
    movl %esp, %ebp
    subl $8, %esp

    #open file with that name in file_name
    movl $SYS_OPEN, %eax
    movl $file_name, %ebx
    movl $0, %ecx          #read-only file
    movl $0666, %edx

    int $LINUX_SYSCALL

    #store it to the stack of main
    #and store output file to main too
    movl %eax, ST_INPUT_FILEDES(%ebp)
    movl $STDOUT, ST_OUTPUT_FILEDES(%ebp)

read_record_loop:
    pushl ST_INPUT_FILEDES(%ebp)
    pushl $BUFFER_DATA
    call read_lib
    addl $8, %esp

    cmpl $RECORD_SIZE, %eax
    jne finish_reading

    pushl $RECORD_FIRSTNAME + BUFFER_DATA
    call strlen
    addl $4, %esp

    movl %eax, %edx
    movl $SYS_WRITE, %eax
    movl ST_OUTPUT_FILEDES(%ebp), %ebx
    movl $RECORD_FIRSTNAME + BUFFER_DATA, %ecx

    int $LINUX_SYSCALL

    pushl ST_OUTPUT_FILEDES(%ebp)
    call write_newline
    addl $4, %esp

    jmp read_record_loop

finish_reading:

    movl $SYS_CLOSE, %eax
    movl ST_INPUT_FILEDES(%ebp), %ebx
    int $LINUX_SYSCALL

    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
