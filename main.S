#include <asm/unistd.h>

.intel_syntax noprefix

.global _start

# calling convention here is:
# args in RSI, RDX, result in RAX 
# because it is convenient with syscalls
# which registers are preserved is not really defined, I'm lazy

.text
    _start:
        mov RSI, offset greeting
        mov RDX, 7
        call write_n

        call main
        
        # exit(0)
        mov RAX, __NR_exit 
        xor RDI, RDI
        syscall
    
    main:
        sub RSP, 16 # reserve string buffer
        mov RSI, RSP
        main_loop:
            call step
            cmp RAX, 1
            jg main_loop
        add RSP, 16
        ret       
    
    step:
        call getline # read line
        mov RDX, RAX
        push RAX # preserve RAX, we don't expect write to stdout to fail
        call write_n # write line
        pop RAX
        ret
    
    write_n: # void (char *RSI_in, uint64_t RDX_in_size)
        mov RAX, __NR_write
        mov RDI, 1 # stdout
        syscall
        ret
    
    getline: # uint64_t (char *RSI_out), returns RAX = string length
        push RSI # save old RSI

        xor RDI, RDI # stdin
        mov RDX, 1 # read 1 byte
        dec RSI # will inc
        getline_loop:
            mov RAX, __NR_read
            inc RSI
            syscall
            cmpb [RSI], 10 # newline
            jne getline_loop

        mov RAX, RSI
        pop RSI
        sub RAX, RSI # RAX = new_RSI - old_RSI
        inc RAX
        ret

    greeting:
        .ascii "Hello!\n"
