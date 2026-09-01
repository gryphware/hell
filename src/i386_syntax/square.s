        .section .data
        .section .text

        .globl _start
        .globl square

_start:
        pushl $4            #push value 4 into stack
        call square         #call square as a function

        addl $4, %esp
        movl %eax, %ebx

        movl $1, %eax
        int $0x80

        .type square,@function
square:
        pushl %ebp          #set pointer to default
        movl %esp, %ebp     #set base pointer

        movl 8(%ebp), %eax  #%eax now has value 4
        imull 8(%ebp), %eax #mullti with %eax and 8(%ebp) (4 * 4) and pass it to %eax

        movl %ebp, %esp
        popl %ebp
        ret
