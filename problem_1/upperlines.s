.section .bss

.comm input, 1

.section .text
.globl _start

_start:

read:
	mov $0, %rax
	mov $0, %rdi
	mov $input, %rsi
	mov $1, %rdx
	syscall

	cmp $0, %rax
	je exit
		

cmp:
	cmp $97, (%rsi)
	jl write
	cmp $122, (%rsi)
	jg write
	sub $32, (%rsi)
	


write:
	mov $1, %rax
	mov $1, %rdi
	mov $input, %rsi
	mov $1, %rdx
	syscall
	
	cmp $10, input
	je read 

newline:
	mov $10, input
	jmp write



exit: 	
	mov $0, %rdi
	mov $60, %rax
	syscall
