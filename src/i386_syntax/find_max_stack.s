        .section .data
        .section .text

        .globl _start
        .globl find

_start:
        pushl $3
        pushl $67
        pushl $34
        pushl $222
        pushl $45
        call find

        addl $20, %esp             #one data is 4 bytes so we need to clean stack
        movl %eax, %ebx            #pass result to %ebx

        #exit code
        movl $1, %eax
        int $0x80

        .type find,@function
find:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %eax         #we need first element to compare with another
        movl $8, %ecx              #must start in index of 2 because 0 is return addrees, 1 is eax holding it

        jmp start_find

start_find:
        cmpl $28, %ecx
        je end_loop

        addl $4, %ecx
        movl (%ebp, %ecx, 1), %ebx
        cmpl %eax, %ebx
        jg set
        jmp start_find

set:
        movl %ebx, %eax
        jmp start_find

end_loop:
        movl %ebp, %esp
        popl %ebp
        ret
