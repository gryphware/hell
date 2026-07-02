      .section .data
  
      .section .text
      .global _start

_start:
# we need to calculate 3 ^ 4 + 4 ^ 3
# so we will cal (3^4) first
      pushl $3            #parameter #1
      pushl $4            #parameter #2
      call power
      addl $8, %esp
      pushl %eax          #store result of (3^4) at the top of stack

      pushl $4
      pushl $3
      call power
      add $8, %esp
      popl %ebx           #%eax had result, so in the top of stack (-4) has
                          #result for this, pop it out into %ebx

      addl %eax, %ebx     #type "echo $?" in bash mode for result
      movl $1, %eax       #exit code (success)
      int $0x80

  .type power, @function
power:
      pushl %ebp          #save all base pointer
      movl %esp, %ebp     #make stack pointer the base pointer
      subl $4, %esp       #more space for local value

      movl 8(%ebp), %ebx  #1 -> %ebx
      movl 12(%ebp), %ecx #2 -> %ecx

      movl %ebx, -4(%ebp) #result (not this time)

power_loop_start:
      cmpl $1, %ecx
      je end_loop_power
      movl -4(%ebp), %eax
      imull %ebx, %eax
      movl %eax, -4(%ebp)
      decl %ecx
      jmp power_loop_start

end_loop_power:
      movl -4(%ebp), %eax
      movl %ebp, %esp
      popl %ebp
      ret
  
