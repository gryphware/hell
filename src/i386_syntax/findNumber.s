        .section .data
array:
        .int 44, 55, 66, 77, 0

msg_found:
        .ascii "found!\n"
        msg_found_len = . - msg_found

msg_not_found:
        .ascii "cant find that number!\n"
        msg_not_found_len = . - msg_not_found

        .section .text
        .globl _start
_start:
        movl $0, %edi
        movl $0, %eax
        movl array(, %edi, 4), %eax
        jmp loop

found:
        movl $4, %eax       #this is for syscall (4 is sys_write)
        movl $1, %ebx       #file descriptor 1 is stdout
        movl $msg_found, %ecx   #pointer to first addess in msg_found
        movl $msg_found_len, %edx  #pass len of msg_found
        int $0x80
        jmp end

not_found:
        movl $4, %eax       #this is for syscall (4 is sys_write)
        movl $1, %ebx       #file descriptor 1 is stdout
        movl $msg_not_found, %ecx   #pointer to first addess in msg_found
        movl $msg_not_found_len, %edx  #pass len of msg_found
        int $0x80
        jmp end

loop:
        cmpl $0, %eax
        je not_found
        cmpl $2182, %eax
        je found
        incl %edi
        movl array(, %edi, 4), %eax
        jmp loop

end:
        movl $1, %eax
        int $0x80
