        .section .data
        .globl array
array:                          #define variable is array(a countinuos address in memory)
        .int 89 ,55, 11 , 69, 87, 42, 32, 41, 88, 100, 64, 9, 0

        .section .text
        .globl _start

_start:
        # set default register for sure
        movl $0, %edi
        movl $0, %eax
        movl $0, %ebx

        # load first value in array with 4 bytes and pass it to eax
        movl array(, %edi, 4), %eax

        # why pass to ebx? because we will something to see result(largest num)
        # so when this program has been execuabled, role of ebx is a status code
        # just do in your shell (bash) "echo $?"
        # boom!!!!!!!!
        movl %eax, %ebx

loop:
        cmpl $0, %eax           #compare eax with 0 => true => goto end
        je end                  #if false
        incl %edi               #load value
        movl array(, %edi, 4), %eax
        cmpl %ebx, %eax
        jle loop
        movl %eax, %ebx
        jmp loop

end:
        movl $1, %eax
        int $0x80
