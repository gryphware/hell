	.type strlen, @function
	.globl strlen

	.equ ST_BUFFER_ADDRESS, 8
strlen:

	pushl %ebp
	movl %esp, %ebp
	
	movl $0, %ecx                     #this is for count char in defined string things
	movl ST_BUFFER_ADDRESS(%ebp), %edx
	
loop:
	movb (%edx), %al                  #we dont need bigger space for some data has only 0 to 127, byte is enough
	cmpb $0, %al                      #it mean end of file (in ascii table \0 - end of file equal 0)

	#if it true, we have size, exit this
	je end_loop

	#if not, increase address of %edx and %ecx
	incl %ecx
	incl %edx

	jmp loop                          #jump back to label "loop" and start over again until hit 0

end_loop:
	movl %ecx, %eax                   #every labels treat like function must pass the result to %eax
	popl %ebp                         #return old address in stack
	ret
	
