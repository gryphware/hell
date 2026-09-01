      .section .data
      .globl array
array:
      .long 23, 45, 65, 67, 36, 100, 0
      
      .section .text
      .globl _start
_start:
      movl $0, %edi
      movl $0, %ebx
      movl array(,%edi, 4), %eax

loop:
      cmpl $0, %eax
      je end
      incl %edi
      movl array(,%edi, 4), %eax
      add $1, %ebx
      jmp loop

end:
      movl $1, %eax
      int $0x80
    
