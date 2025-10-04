.section .data
numberofnumbers:
        .quad 7
mynumbers:
        .quad 5, 20, 33, 80, 52, 10, 1

.section .text
.globl _start

_start:

movq numberofnumbers, %rcx

# Index of the first element
movq $0, %rbx

#highest value
movq $0, %rdi

cmp $0, %rcx
je exit

loop:
movq mynumbers(, %rbx, 8), %rax
cmpq %rdi, %rax
jbe loopcontrol

movq %rax, %rdi

loopcontrol:
incq %rbx
decq %rcx
jnz loop

exit:
movq $60, %rax
syscall
