        .section .data
        #no variable inneed
        .section .text                #this is main of program
        .globl _start                 #globl means this is important when assemble
_start:
        movl $1, %eax                 #in linux kernel, 1 for exit
        movl $0, %ebx                 #set status number, type in shell (bash) echo $?

        int $0x80                      #interupt
