.section .bss                  # Uninitialized data section

.comm input, 1                 # Reserve 1 byte named 'input' (zero-initialized)

.section .text
.globl _start

_start:

read:                           # --- Read exactly 1 byte from stdin into 'input' ---
	mov $0, %rax               # rax = 0 → sys_read
	mov $0, %rdi               # rdi = 0 → fd: stdin
	mov $input, %rsi           # rsi = &input (destination buffer address)
	mov $1, %rdx               # rdx = 1 → read 1 byte
	syscall                    # perform read(0, &input, 1)

	cmp $0, %rax               # did read return 0 bytes?
	je exit                    # yes → EOF: exit program
		

cmp:                            # --- If byte is lowercase 'a'..'z', convert to uppercase ---
	cmp $97, (%rsi)            # compare *rsi with 'a' (97)
	jl write                   # if *rsi < 'a', skip conversion
	cmp $122, (%rsi)           # compare *rsi with 'z' (122)
	jg write                   # if *rsi > 'z', skip conversion
	sub $32, (%rsi)            # within 'a'..'z': make uppercase by subtracting 32
	

write:                          # --- Write one byte (current 'input') to stdout ---
	mov $1, %rax               # rax = 1 → sys_write
	mov $1, %rdi               # rdi = 1 → fd: stdout
	mov $input, %rsi           # rsi = &input (source buffer address)
	mov $1, %rdx               # rdx = 1 → write 1 byte
	syscall                    # perform write(1, &input, 1)
	
	cmp $10, input             # was the byte we just wrote a newline ('\n' = 10)?
	je read                    # yes → read next input byte (no extra newline)

newline:                        # not a newline: emit a newline after the character
	mov $10, input             # store '\n' (10) into 'input'
	jmp write                  # write the newline, then loop back via the check above


exit: 	                        # --- Exit program ---
	mov $0, %rdi               # rdi = 0 → exit status
	mov $60, %rax              # rax = 60 → sys_exit
	syscall                    # exit(0)
