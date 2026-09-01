	.include "src/linux_const.s"
	.include "src/record_def.s"
	
	.type read_lib, @function
	.globl read_lib

	.equ ST_FILEDES, 12
	.equ ST_BUFFER, 8
	
read_lib:
	pushl %ebp                          #define stack
	movl %esp, %ebp			    #default, dont ask me why i have to do that shit!!!!!!!!!!!

	pushl %ebx
	movl $SYS_READ, %eax                #in linux machine, the way read the fd is ($SYS_READ) see linux_cosnt.s for more details
	movl ST_FILEDES(%ebp), %ebx         #fd to open
	movl ST_BUFFER(%ebp), %ecx          #need a buffer array to store what kind of data it read
	movl $RECORD_SIZE, %edx		    #max limit for a one-time read

	int $LINUX_SYSCALL                  #above is the syscall command (read() in c) you can look up to (https://man7.org/linux/man-pages/man2/read.2.html) for more details

	popl %ebx                           #for safety reason, any "callee" register must hold old value

	movl %ebp, %esp
	popl %ebp
	ret
	
	

	
	
