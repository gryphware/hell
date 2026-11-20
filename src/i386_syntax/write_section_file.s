	.include "lib/linux_const.s"
	.include "lib/record_def.s"

	.section .data
file_input:
	.ascii "hello.dat\0"
file_output:
	.ascii "file_output.dat\0"

	.section .bss
	.lcomm RECORD_BUFFER, RECORD_SIZE

	.equ ST_INPUT_FILE_DES, -4
	.equ ST_OUTPUT_FILE_DES, -8
	
	.section .text
	.globl _start
_start:
	#create some spaces in stack for store some
	#file des
	movl %esp, %ebp
	subl $8, %esp

	#open 2 file and check if "file.dat" or "file_output.dat"
	#return error at %eax
	#if any error when open 2 file: exit immediately
	#if not: do entire code below
	#all value created by result of sys_read or sys_open
	#must be stored in stack by index
	movl $SYS_OPEN, %eax
	movl $file_input, %ebx
	movl $0, %ecx                    #read only
	movl $0666, %edx
	
	int $LINUX_SYSCALL

	movl %eax, ST_INPUT_FILE_DES(%ebp)
	
	cmpl $0, ST_INPUT_FILE_DES(%ebp)
	jl close_input_file_error

	movl $SYS_OPEN, %eax
	movl $file_output, %ebx
	movl $0101, %ecx                   #read, create when file doesnt exist, write
	movl $0666, %edx

	int $LINUX_SYSCALL
	
	movl %eax, ST_OUTPUT_FILE_DES(%ebp)
	
	cmpl $0, ST_OUTPUT_FILE_DES(%ebp)
	jl close_output_file_error

	#read loop
read_loop:
	pushl ST_INPUT_FILE_DES(%ebp)
	pushl $RECORD_BUFFER
	call read_lib
	addl $8, %esp

	#when hit zero => out this program
	cmpl $RECORD_SIZE, %eax
	jne end_program

  pushl $RECORD_FIRSTNAME + RECORD_BUFFER
  call strlen
  addl $4, %esp
  
	#now we are having strlen of section buffer
  movl %eax, %edx
  movl $SYS_WRITE, %eax
  movl ST_OUTPUT_FILE_DES(%ebp), %ebx
  movl $RECORD_FIRSTNAME + RECORD_BUFFER, %ecx

  int $LINUX_SYSCALL

  
close_output_file_error:	
	movl $SYS_CLOSE, %eax
	movl ST_OUTPUT_FILE_DES(%ebp), %ebx
	int $LINUX_SYSCALL
	jmp close_input_file_error

close_input_file_error:
	movl $SYS_CLOSE, %eax
	movl ST_INPUT_FILE_DES(%ebp), %ebx
	int $LINUX_SYSCALL
	jmp end_program_error
	
end_program_error:
	movl $SYS_EXIT, %eax
	movl $1, %ebx
	int $LINUX_SYSCALL

end_program:
	movl $SYS_CLOSE, %eax
	movl ST_OUTPUT_FILE_DES(%ebp), %ebx
	int $LINUX_SYSCALL

	movl $SYS_CLOSE, %eax
	movl ST_INPUT_FILE_DES(%ebp), %ebx
	int $LINUX_SYSCALL
	
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
