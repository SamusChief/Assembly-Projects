	;; Tristan Adams
	;; Due 10/2/2014
	;; Section 03
	;; Project 2 CMSC 313
	;; Description: takes in strings, filters out non-lowercase letters,
	;;   and does a selection sort on those letters. Prints between each
	;;   step.

section .bss			;section for uninitialized data
	Buff resb 500		;reserve 500 bytes for a buffer for string
	Blen equ $-Buff		;length of buffer
	Buff2 resb 500		;second buffer for filtering process
	B2len equ $-Buff	;length of second buffer

section .data			;section of code for initialized data
prompt:	db 10,"Enter the input: " ;the prompt to print for the user
plen:	equ $-prompt		  ;the length of the prompt
response:	db "Sorting string: " ;the response when beginning sort
rlen:	equ $-response			 ;the length of the response
returnKey:	db 10			 ;ascii for return key
returnLen:	equ $-returnKey		 ;length of return key

section .text
	global _start

_start:
	nop			;keeps debugger happy
	
	;; Read the input the user puts in the console
Read:
	mov esi, 0		;make esi a counter for the loop
.loop:
	inc esi		 	;increment loop counter
	;; print the prompt
	mov eax, 4		;sys_write call
	mov ebx, 1		;Standard Output Descriptor
	mov ecx, prompt		;the prompt's address
	mov edx, plen		;length of the prompt
	int 80H			;kernel call
	mov eax, 3		;sys_read call
	mov ebx, 0		;Standard Input Descriptor
	mov ecx, Buff		;pass Buffer to read into
	mov edx, Blen		;must be able to process up to 500 characters
	int 80H			;kernel call
	;; Call filter to filter out the word
	call Filter		;filter out non-lowercase characters
	;; push important values into stack in order of: word, word length
	push ecx		;push word into stack
	push eax		;push word length into stack
	;; print out response string
	mov ecx, response	;pass response address
	mov edx, rlen		;length of response
	mov ebx, 1		;stdout descriptor
	mov eax, 4		;sys_write call
	int 80H			;kernel call
	;; pop stack back into relevant registers: order is word length, word
	pop edx			;pop length of word to edx
	pop ecx			;pop word into ecx
	;; push word and length into stack to use later
	push ecx		;push word to stack
	push edx		;push word length to stack
	;; print the word
	mov eax, 4		;sys_read call
	mov ebx, 1		;stdout descriptor
	int 80H			;kernel call
	;; print a return key between 
	mov eax, 4		;sys_read call
	mov ebx, 1		;stdout descriptor
	mov ecx, returnKey	;pass address of return key
	mov edx, returnLen	;return key length
	int 80H			;kernel call
	pop edx			;restore word length
	pop ecx			;restore word reference
	push esi	    	;preserve loop counter
	call Sort		;jump down to sort, Sort does not work yet
	pop esi			;restore esi value
	cmp esi, 3		;compare to 3 to exit loop
	je Exit			;jump to exit if loop counter is done
	jmp .loop		;jump to top of loop

	;; Filter out the non lowercase characters from the string
Filter:
	mov eax, 0		;make eax 0 to use to loop through ecx
	mov edi, 0		;use edi to keep track of new string length
.loop:
	cmp byte[ecx+eax], 0AH	;compare to enter key
	je .done		;done with loop if at the end of string
	cmp byte [ecx+eax], 61H	;compare to lower a
	jae .pushCheck		;push to Buff2 if possibly lowercase
	inc eax			;increment eax and ignore char
	jmp .loop		;jump to top of loop
	
.pushCheck:
	cmp byte[ecx+eax], 7AH	;compare to lowercase z
	jbe .pushBuff		;confirmed lowercase, jump down to pushBuff
	inc eax			;increment counter to proceed to next character
	jmp .loop		;jump back to loop and restart

.pushBuff:
	push ebx		;preserve ebx using Batman-level paranoia
	mov bl, [ecx+eax]	;move char in current index into bl
	mov byte[Buff2+edi],bl  ;move character in bl to the current Buff index
	pop ebx			;restore ebx value just in case
	inc edi			;increase length of new buffer by one
	inc eax			;increment first word index to prevent inf loop
	jmp .loop		;jump back to loop

.done:
	mov eax, edi		;replace eax with length of new string
	mov ecx, Buff2		;move Buff2 reference into ecx
	ret			;resume code in Read:

	;; Use selection sort on the string to sort from a to z order (ascii)
Sort:
	;; assign each of the initial values to registers
	;; ecx and edx are already assigned as word and word length, resp.
	mov eax, 0		;use eax as outer loop iterator
	mov ebx, 0		;use ebx as inner loop iterator
	mov esi, 0		;use esi as index of minimum character
	mov edi, 0		;use edi as a check to see if a swap has been
				;made 

	;; outer loop of selection sort
.outer:
	mov ebx, eax		;reset inner iterator
	mov esi, ebx		;reset index for minimum
	;; 1. run the inner loop
	call .inner		;run the inner loop
	;; 2. swap values in minimum index and current progress index
	;; use expert paranoia to push and preserve all values used
	push eax		;push outer iterator to stack
	push ebx		;push inner iterator to stack
	push ecx		;preserve word reference
	push edx		;preserve word length
	push esi		;preserve minimum index
	push edi		;preserve swap flag
	call .swap		;call the swap to swap characters
	pop edi			;restore swap flag
	pop esi			;restore minimum index
	pop edx			;restore word length
	pop ecx			;restore word reference
	pop ebx			;restore inner iterator
	pop eax			;restore outer iterator
	;; 3. Print the word
	push ecx		;push word reference to stack
	push edx		;push length to stack
	push eax		;push outer iterator to stack
	push ebx		;push inner iterator to stack
	push esi		;push index of minimum to stack
	call .print		;print the word
	pop esi			;pop minimum index
	pop ebx			;pop inner iterator
	pop eax			;pop outer iterator
	pop edx			;pop word length
	pop ecx			;pop word
	;; 4. check for re-looping
	inc eax			;increment outer iterator
	cmp eax, edx		;compare outer iterator to length
	jne .outer		;jump to top of loop if not equal
	;; 5. return
	jmp .done			;return to Read

	;; swap the characters in minimum index of string and current progress
.swap:
	push edi	  	;preserve new min flag in stack
	mov ebx, ecx		;make ebx reference 1st char
	add ebx, esi		;move ebx to minimum
	mov bl, [ebx]		;move value in ebx into ebx's lowest byte
	
	push ebx		;push bl value onto stack

	mov ebx, ecx		;make ebx reference 1st char
	add ebx, eax		;move ebx to current index
	mov bl, [ebx]		;move value in ebx into ebx's lowest byte

	mov edi, ecx		;reference 1st character with edi
	add edi, esi		;move edi to the minimum character
	mov [edi], bl		;replace minimum character with current char

	pop ebx			;replace bl value with minimum char

	mov edi, ecx		;restore edi to 1st character reference
	add edi, eax		;move edi to current char
	mov [edi], bl		;move bl character into current index

	pop edi			;restore edi
	jmp .done 		;return to loop
	
	;; inner loop of selection sort
.inner:
	;; 1. Check current character against current minimum char
	;;    and if its less, replace current min index
	push eax	   	;preserve esi in the stack
	mov al, [ecx+esi]	;change esi to actual character at min index
	cmp [ecx+ebx], al	;compare inner iterator to minimum
	jb .newMin	  	;replace the minimum with ebx
	pop eax			;restore esi to minimum index
	;; 2. check to see if at the end of the loop
	inc ebx			;increment inner loop
	cmp ebx, edx		;compare current index to length of word
	jne .inner		;if not equal, re-loop
	;; 3. return
	jmp .done		;return to outer loop

.newMin:
	inc edi			;use edi as a flag for if a swap is made
	pop eax			;restore eax
	mov esi, ebx	  	;move value of ebx into esi as new minimum index
	;; check to see if at the end of the loop
	inc ebx			;increment inner counter
	cmp ebx, edx		;check if inner counter and length are equal
	jne .inner		;jump back to inner loop if not done
	jmp .done		;return if done
	
	;; print the current word
.print:
	cmp edi, 0		;check if a swap has been made
	je .doneP		;if no swap has been made, do not print
	mov eax, 4		;sys_write call
	mov ebx, 1		;stdout descriptor
	int 80H			;kernel call
	mov eax, 4		;sys_write call
	mov ebx, 1		;stdout descriptor
	mov ecx, returnKey	;print return key
	mov edx, returnLen	;return key length
	int 80H			;kernel call
	jmp .doneP		;done with printing

	;; do this when done printing
.doneP:
	mov edi, 0
	
	;; when done with a process, return
.done:
	ret			;return to previous process
	
	;; Exit program
Exit:	mov eax, 1		;Exit system call
	mov ebx, 0		;Return code 0 to linux
	int 80H			;kernel call