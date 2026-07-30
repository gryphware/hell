        .section .data

  #syscall number
        .equ SYS_OPEN, 5            #for %eax
        .equ SYS_WRITE, 4
        .equ SYS_READ, 3
        .equ SYS_CLOSE, 6
        .equ SYS_EXIT, 1

  #O_FLAG for bahave with file like (write only or read, etc)
  #use for %ecx
        .equ O_RDONLY, 0
        .equ O_CREAT_WRONLY_TRUNC, 03101

  #stadard file descriptor
        .equ STDIN, 0
        .equ STDOUT, 1
        .equ STDERR, 2

  #linux interupt number in hex (0x80)
        .equ LINUX_INTERUPT, 0x80
        .equ END_OF_FILE, 0       #in any files, must end with \0(null terminator or in ascii is 0)
        .equ NUMBER_ARGV, 2

        .section .bss

        .equ BUFFER_SIZE, 100
        .lcomm BUFFER_DATA, BUFFER_SIZE

        .section .text
        .equ ST_SIZE_RESERVE, 8
        .equ ST_FD_IN, -4
        .equ ST_FD_OUT, -8
        .equ ST_ARGC, 0
        .equ ST_ARGV_0, 4
        .equ ST_ARGV_1, 8
        .equ ST_ARGV_2, 12

        .globl _start
_start:
        movl %esp, %ebp
        subl $ST_SIZE_RESERVE, %esp

open_files:
open_fd_in:
        #open syscall
        movl $SYS_OPEN, %eax
        #input file name
        movl ST_ARGV_1(%ebp), %ebx
        #O_FLAG
        movl $O_RDONLY, %ecx
        #permit in linux
        movl $0666, %edx

        int $LINUX_INTERUPT

store_fd_in:
        movl %eax, ST_FD_IN(%ebp)

open_fd_out:
        #open
        movl $SYS_OPEN, %eax
        #load filename
        movl ST_ARGV_2(%ebp), %ebx
        #O_FLAG
        movl $O_CREAT_WRONLY_TRUNC, %ecx
        #permit in linux
        movl $0666, %edx

        int $LINUX_INTERUPT

store_fd_out:
        movl %eax, ST_FD_OUT(%ebp)

read_loop_begin:

        #imagie in c we have read(int fd, void *buf, size_t size)
        movl $SYS_READ, %eax         #read() in linux kernel
        movl ST_FD_IN(%ebp), %ebx    #int fd
        movl $BUFFER_DATA, %ecx      #void *buf
        movl $BUFFER_SIZE, %edx      #size_t
        int $LINUX_INTERUPT

        cmpl $END_OF_FILE, %eax           #when end of file end this
        jle end_loop

continue:
        pushl $BUFFER_DATA
        pushl %eax                  #this is will return size of bytes read this will happen after int $LINUX_INTERUPT
        call convert_to_upper
        popl %eax                   #get size back
        add $4, %esp                #restore

        #write the block out to the output file

        #keep size
        movl %eax, %edx
        movl $SYS_WRITE, %eax

        #file to use
        movl ST_FD_OUT(%ebp), %ebx
        movl $BUFFER_DATA, %ecx
        int $LINUX_INTERUPT

        #read again
        jmp read_loop_begin

end_loop:
        movl $SYS_CLOSE, %eax
        movl ST_FD_OUT(%ebp), %ebx
        int $LINUX_INTERUPT

        movl $SYS_CLOSE, %eax
        movl ST_FD_IN(%ebp), %ebx
        int $LINUX_INTERUPT

        #exit
        movl $1, %eax
        movl $0, %ebx
        int $LINUX_INTERUPT

        .equ LOWERCASE_A, 'a'
        .equ LOWERCASE_Z, 'z'
        .equ UPPER_CONVERSION, 'A' - 'a'

        .equ ST_BUFFER_LEN, 8
        .equ ST_BUFFER, 12

convert_to_upper:
        pushl %ebp
        movl %esp, %ebp

        movl ST_BUFFER(%ebp), %eax
        movl ST_BUFFER_LEN(%ebp), %ebx
        movl $0, %edi

        #if buffer's size is zero
        #end this
        cmpl $0, %ebx
        je end_convert_loop

convert_loop:
        movb (%eax, %edi, 1), %cl             #take 1 byte from stack and give it to %cl

        cmpb $LOWERCASE_A, %cl
        jl next_byte                          #if currient byte is less than lowvercase a => skip
        cmpb $LOWERCASE_Z, %cl
        jg next_byte                          #if currient byte is greater than lowvercase z => skip

        addb $UPPER_CONVERSION, %cl
        movb %cl, (%eax, %edi, 1)

next_byte:
        incl %edi
        cmpl %edi, %ebx                       #if %ebi != %ebx (current index != size of buffer) => continue
        jne convert_loop

end_convert_loop:
        movl %ebp, %esp
        popl %ebp
        ret
