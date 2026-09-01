	#all interupt in linux system
	.equ SYS_EXIT, 1
	.equ SYS_READ, 3
	.equ SYS_WRITE, 4
	.equ SYS_OPEN, 5
	.equ SYS_CLOSE, 5
	.equ SYS_BRK, 45
	.equ LINUX_SYSCALL, 0x80
	
	#file descriptor
	.equ STDIN, 0
	.equ STDOUT, 1
	.equ STDERR, 2

	#end of file
	.equ END_OF_FILE, 0
	
