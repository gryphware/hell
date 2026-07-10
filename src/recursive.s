        .section .data                #no value, so we need define stack
        .section .text

        .globl _start
        .globl factorial              #i need this fuction for another program

_start:
        pushl $5                      #factorial of 4 (4!)
        call factorial

        addl $4, %esp
        movl %eax, %ebx

        movl $1, %eax
        int $0x80


        .type factorial,@function
factorial:
        pushl %ebp                    #restore %ebp to prior state before
                                      #returning
        movl %esp, %ebp

        movl 8(%ebp), %eax            #load address have value 4
        cmpl $1, %eax                 #base case
        je factorial_end

        #else
        decl %eax                     #eax - 1 (n - 1)
        pushl %eax                    #push result of least %eax value
        call factorial                #call agian

        movl 8(%ebp), %ebx            #so %eax has value of the lastest stack address
                                      #we need another register for multiply with
                                      #%eax
        imull %ebx, %eax              #must return to %ebx so we can see result by
                                      #typing in bash "echo $?"
factorial_end:
        movl %ebp, %esp
        popl %ebp
        ret
