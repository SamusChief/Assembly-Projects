	;; Tristan Adams
	;; Due 9/25/2014
	;; Section 03
	;; Project 1 CMSC313
	;; Description: flips lower case characters to upper case and vice
	;;   versa. For numbers, prints 10 + x asterisks. Exits otherwise.

section .bss		             ;section of code for unitialized data
Buff resb 1     	             ;reserve 1 byte for a buffer for
	                             ;1 character
	
section .data		             ;section of code for initialized data
prompt:	  db 10,"Enter one char: "	     ;the prompt for input
plen:	  equ $-prompt	     ;length of prompt
response: db 10,"Here is the output: "  ;the response before output
rlen:	  equ $-response	     ;length of the response
ast:	  db "*"		     ;store an asterisk
itr:	  db "0"			     ;store current amount of runs
	
section .text
	global _start

_start:
	nop			     ;this statement keeps debugger happy
	
Prompt:	;;Print prompt
	mov eax, 4		     ;this is the sys_write call
	mov ebx, 1		     ;Standard File Descriptor Output
	mov ecx, prompt		     ;the prompt to write
	mov edx, plen		     ;the length of the prompt
	int 80H			     ;kernel call

Read:	;;Read the input
	mov eax, 3		     ;sys_read call
	mov ebx, 0		     ;Standard Input Descriptor
	mov ecx, Buff		     ;pass the buffer to read to
	mov edx, 2		     ;read 1 character plus enter key
	int 80H			     ;kernel call
	

	;;increment number of iterations
	inc byte [itr]		     ;increment iterator

	cmp eax, 0		     ;examine sys_read's return
	je Exit			     ;Exit if equal to zero

	cmp byte [Buff], 7BH	     ;Test input against lowercase z
	jb Lower		     ;jump to lowercase section if below

Lower:				     ;Print uppercase version of letter
	cmp byte [Buff], 61H	     ;Test against lowercase a
	jb Upper		     ;jump to uppercase if below
	;;Guaranteed lowercase at this point
	sub byte[Buff], 20H	     ;subtract 20H from lower to get upper
	jmp Write                    ;print uppercase letter
	
Upper:				     ;Print lowercase version of letter
	cmp byte [Buff], 41H	     ;Test input against upper A
	jb Number		     ;jump to number section if below
	
	cmp byte [Buff], 5AH	     ;Test input against uppercase Z
	ja Iterations		     ;jump to iterations section if above
	;;guaranteed uppercase at this point
	add byte [Buff], 20H	     ;add 20 to get lowercase letter
	jmp Write                    ;print lowercase letter
	
Number:				     ;Print 10+x asterisks
	cmp byte [Buff], 30H	     ;Test input against 0
	jb Iterations		     ;jump to iterations if below

	cmp byte [Buff], 39H	     ;Test against 9
	ja Iterations		     ;jump to iterations if above

	mov edi, 10		     ;store the base number of asterisks
	sub byte[Buff], 30H	     ;subtract hex value for 0 from buff
	                             ;to get a number value
	add edi, [Buff]              ;add the number in Buffer to loop register
	sub edi, 2560		     ;subtract 2560 to cut off Enter key from input

Loop:				     ;Loop through and make asterisks
	mov eax, 4		     ;Sys_write call
	mov ebx, 1		     ;Standard Output
	mov ecx, ast		     ;asterisk data
	mov edx, 1		     ;length of asterisk (1)
	int 80H			     ;kernel call
	dec edi 		     ;decrement edi
	jnz Loop		     ;jump if the register isn't zero
	cmp edi, 0		     ;compare loop counter against 0
	je Prompt		     ;jump to prompt if done

Iterations:	
	;;Print the total number of iterations
	;;Print response message
	mov eax, 4		     ;sys_write call
	mov ebx, 1		     ;Standard Output
	mov ecx, response	     ;pass response address
	mov edx, rlen		     ;pass response length
	int 80H			     ;kernel call
	;;Print iterations
	mov eax, 4		     ;sys_write call
	mov ebx, 1		     ;Standard Output
	mov ecx, itr		     ;pass iterator address
	mov edx, 1		     ;pass iterator length
	int 80H			     ;kernel call
	;;jump back to prompt when done
	jmp Prompt

Write:	;;Output the results
	mov eax, 4		     ;Sys_write call
	mov ebx, 1		     ;Standard Output
	mov ecx, response	     ;pass address of response
	mov edx, rlen		     ;length of response
	int 80H			     ;kernel call
	mov eax, 4		     ;Sys-write call
	mov ebx, 1		     ;Standard Output
	mov ecx, Buff		     ;pass address of Buffer
	mov edx, 1		     ;number of characters to print
	int 80H			     ;kernel call
	jmp Prompt		     ;jump back to prompt
		
Exit:	;;Exit the program
	mov eax, 1		     ;Exit system call
	mov ebx, 0		     ;Return code of 0 to Linux
	int 80H			     ;kernel call