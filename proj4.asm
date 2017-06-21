	;; Tristan Adams
	;; Due 10/30/2014
	;; Section 03
	;; Project 1 CMSC313
	;; Description: Takes in a number from 0 to 255 (decimal), converts that
	;;   to an input base using the division method


	extern printf		;use printf C function
	extern scanf		;use scanf C function
	extern fprintf		;use fprintf C function
	extern fclose		;use fclose C function
	extern fopen		;use fopen C function

section .bss
	result resb 9		;reserve 8 bytes for backwards remainders
				; and one extra byte for the null character
	remainders resb 32	;reserve 32 bytes to store remainders in order
	base resb 4		;store base input by user
	empty resb 5		;safety buffer between base and value
	value resb 4		;store value input by user
	empty2 resb 5		;safety buffer in between value and filename
	filename resb 32	;filename buffer

	;; store formats and strings, null terminated
section .data
	numPrompt db 10,"Enter a number between 0 and 255: ", 0 ;number prompt
	basePrompt db 10,"Enter a base between 2 and 9: ", 0 ;base prompt
	formNum db "%d", 0	;format input value as decimal
	formBase db "%d", 0	;format input base as decimal
	formRes db "%8d", 0	;format result as an 8 digit decimal
	formStr db 10,"%s",10, 0 ;format string output
	formFile db "%s", 10, 0	 ;format file string
	fileWrite db "w", 0	 ;file creation writing indicator

section .text
	global main
	
main:
	nop

	
	push ebp		;set up stack frame
	mov ebp, esp

	mov edx, [esp+12]	;make edx the command line argument
	add edx, 4		;move from program name to argument (filename)

	push dword fileWrite	;tell file to write
	push dword [edx]	;push filename
	call fopen		;open the file, file is now in eax
	add esp, 8		;restore stack

	push eax		;preserve file
	call readNum		;read in a number
	pop eax			;restore file
.loop:
	
	push eax		;preserve file
	call readBase		;read in a base
	pop eax			;restore file
	
	cmp edx, 0		;check input base against 0
	je .done		;exit if equal

	push eax		;preserve file
	call convert		;convert the value to the new base
	pop eax			;restore file

	push eax		;preserve file
	mov eax, 0		;clear eax
	mov al, [remainders+28]	;reverse last remainder
	mov [result], al	;to first result
	mov al, [remainders+24]	;reverse 7th remainder
	mov [result+1], al	;to 2nd result
	mov al, [remainders+20]	;flip 6th remainder
	mov [result+2], al	;to 3rd result
	mov al, [remainders+16]	;flip 5th remainder
	mov [result+3], al	;to 4th result
	mov al, [remainders+12]	;flip 4th remainder
	mov [result+4], al	;to 5th result
	mov al, [remainders+8]	;flip 3rd remainder
	mov [result+5], al	;to 6th result
	mov al, [remainders+4]	;flip 2nd remainder
	mov [result+6], al	;to 7th result
	mov al, [remainders]	;flip 1st remainder
	mov [result+7], al	;to last result
	mov al, 0		;0 for null termination
	mov [result+8], al	;null terminate string
	pop eax			;restore file

	push eax		;preserve file
	push result		;push string to stack
	push formStr		;specify string output
	call printf		;call printf C function
	add esp, 8		;update stack
	pop eax			;restore file
	
	push result		;push string to print
	push formFile		;format of string
	push eax		;push file to print to
	call fprintf		;print result to file
	pop eax			;restore file
	add esp, 4		;update stack 

	;; clear results for next loop
	push eax		;preserve file
	mov eax, 0		;use al as 0 for this
	mov [result], al	;1st slot
	mov [result+1], al	;2nd slot
	mov [result+2], al	;3rd slot
	mov [result+3], al	;4th slot
	mov [result+4], al	;5th slot
	mov [result+5], al	;6th slot
	mov [result+6], al	;7th slot
	mov [result+7], al	;8th slot
	mov [result+8], al	;9th slot (null termination)
	pop eax			;restore file

	;; clear remainders slots
	push eax		 ;preserve file
	mov eax, 0		;use al as 0 for this
	mov [remainders], eax	;1st slot
	mov [remainders+4], eax	;2nd slot
	mov [remainders+8], eax	;3rd slot
	mov [remainders+12], eax;4th slot
	mov [remainders+16], eax;5th slot
	mov [remainders+20], eax;6th slot
	mov [remainders+24], eax;7th slot
	mov [remainders+28], eax;8th slot
	pop eax			;restore file
	
	jmp .loop		;reloop

	;; wrap up program
.done:
	push eax		;push file 
	call fclose		;close file
	add esp, 4		;update stack
	
	mov esp, ebp		;take down stack frame
	pop ebp			;same as leave op
	ret			;exit the program

readNum:
.loop:
	mov ecx, numPrompt	;move prompt to register
	push ecx		;push prompt
	call printf		;call print function
	add esp, 4		;update stack
	
	push dword value	;push buffer for C
	push dword formNum	;push format for C
	call scanf		;call C scan function
	add esp, 8		;update stack

	mov edx, [value]	;put value of buffer to edx
	cmp edx, 0		;compare to 0
	jb .loop		;if below, reloop
	cmp edx, 255		;compare to 255
	ja .loop		;if above, reloop
.done:
	ret			;else, return

readBase:
.loop:
	mov ecx, basePrompt	;move prompt to register
	push ecx		;push prompt
	call printf		;call print function
	add esp, 4
	
	push dword base		;push buffer for C
	push dword formBase	;push format for C
	call scanf		;call C scan function
	add esp, 8		;update stack

	mov edx, [base]		;put value of buffer to edx
	cmp edx, 0		;compare to 0
	je .done		;if 0, jump back to function for exit check
	cmp edx, 2		;compare to 2
	jb .loop		;if below, reloop
	cmp edx, 9		;compare to 9
	ja .loop		;if above, reloop
.done:
	ret			;else, return

	;; converts the number in value to a new base using the division
	;; method.
convert:
	mov eax, [value]	;assign eax the value (dividend)
	mov ecx, [base]		;assign ecx the base (divisor)
	push esi		;preserve esi for C functions
	mov esi, 0		;use esi for loop iterator
	push ebx		;preserve ebx for C functions
	
.loop:
	mov edx, 0		;set edx to 0 to use idiv
	idiv ecx		;divide value by ecx, edx is remainder
	;; place this remainder into the correct remainder slot
	mov ebx, 0		;clear ebx to use for buffer reference

	mov ebx, [remainders]	;1st slot
	cmp ebx, 0		;check slot for emptiness
	je .add1		;if it is, add

	mov ebx, [remainders+4]	;2nd slot
	cmp ebx, 0		;make sure slot is empty
	je .add2		;if it is, add

	mov ebx, [remainders+8]	;3rd slot
	cmp ebx, 0		;make sure slot is empty
	je .add3		;if it is, add

	mov ebx, [remainders+12] ;4th slot
	cmp ebx, 0		;make sure slot is empty
	je .add4		;if it is, add

	mov ebx, [remainders+16] ;5th slot
	cmp ebx, 0		;make sure slot is empty
	je .add5		;if it is, add

	mov ebx, [remainders+20] ;6th slot
	cmp ebx, 0		;make sure slot is empty
	je .add6		;if it is, add

	mov ebx, [remainders+24] ;7th slot
	cmp ebx, 0		;make sure slot is empty
	je .add7		;if it is, add
	
	mov ebx, [remainders+28]	;8th slot
	cmp ebx, 0		;make sure slot is empty
	je .add8		;if it is, add

.add1:
	push eax		;preserve eax value
	mov eax, 0		;clear register
	mov al, 48		;move 48 to al
	mov [remainders], al	;fill slot
	pop eax			;restore eax
	add [remainders], edx 	;add in the remainder to this slot
	cmp eax, 0		;if eax is zero
	je .done1		;loop is complete
	jmp .loop		;reloop if necessary
.add2:
	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		;move 48 to al
	mov [remainders+4], al	;fill slot
	pop eax			;restore eax
	add [remainders+4], edx ;add in the remainder to this slot
	cmp eax, 0		;if eax is zero
	je .done2		;loop is complete
	jmp .loop		;reloop if necessary
.add3:
	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		;use eax to fill slot
	mov [remainders+8], al	;fill slot
	pop eax			;restore eax
	add [remainders+8], edx ;add in the remainder to this slot
	cmp eax, 0		;if eax is zero
	je .done3		;loop is complete
	jmp .loop		;reloop if necessary
.add4:
	push eax		 ;preserve eax
	mov eax, 0		 ;clear eax
	mov al, 48		 ;use eax to fill slot
	mov [remainders+12], al	;fill slot
	pop eax			;restore eax
	add [remainders+12], edx ;add in the remainder to this slot
	cmp eax, 0		;if eax is zero
	je .done4		;loop is complete
	jmp .loop		;reloop if necessary
.add5:
	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		;use eax to fill slot
	mov [remainders+16], al	;fill slot
	pop eax			;restore eax
	add [remainders+16], edx ;add in the remainder to this slot
	cmp eax, 0		;if eax is zero
	je .done5		;loop is complete
	jmp .loop		;reloop if necessary
.add6:
	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		 ;use eax to fill slot
	mov [remainders+20], al	;fill slot
	pop eax			;restore eax
	add [remainders+20], edx ;add in the remainder to this slot
	cmp eax, 0		;if eax is zero
	je .done6		;loop is complete
	jmp .loop		;reloop if necessary
.add7:
	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		;use eax to fill slot
	mov [remainders+24], al	;move remainder to slot
	pop eax			;restore eax
	add [remainders+24], edx ;add in the remainder to this slot
	cmp eax, 0		;if eax is zero
	je .done7		;loop is complete
	jmp .loop		;reloop if necessary
.add8:
	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		;use eax to fill slot
	mov [remainders+28], al	;move remainder to slot
	pop eax			;restore eax
	add [remainders+28], edx ;add in the remainder to this slot
	cmp eax, 0		;if eax is zero
	je .done8		;loop is complete
	jmp .loop		;reloop if necessary
	
.done1:
	pop ebx			;restore ebx for C functions
	pop esi			;restore esi

	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		;use al to fill leftover slots
	mov [remainders+4], al	;fill empty slot
	mov [remainders+8], al	;fill empty slot
	mov [remainders+12], al	;fill empty slot
	mov [remainders+16], al	;fill empty slot
	mov [remainders+20], al	;fill empty slot
	mov [remainders+24], al	;fill empty slot
	mov [remainders+28], al	;fill empty slot
	
	pop eax			;restore eax
	ret			;return to revious code
.done2:
	pop ebx			;restore ebx for C functions
	pop esi			;restore esi

	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		;use al to fill leftover slots
	mov [remainders+8], al	;fill empty slot
	mov [remainders+12], al	;fill empty slot
	mov [remainders+16], al	;fill empty slot
	mov [remainders+20], al	;fill empty slot
	mov [remainders+24], al	;fill empty slot
	mov [remainders+28], al	;fill empty slot

	pop eax			;restore eax 
	ret			;return to revious code
.done3:
	pop ebx			;restore ebx for C functions
	pop esi			;restore esi

	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		;use al to fill leftover slots
	mov [remainders+12], al	;fill empty slot
	mov [remainders+16], al	;fill empty slot
	mov [remainders+20], al	;fill empty slot
	mov [remainders+24], al	;fill empty slot
	mov [remainders+28], al	;fill empty slot

	pop eax			;restore eax 
	ret			;return to revious code
.done4:
	pop ebx			;restore ebx for C functions
	pop esi			;restore esi

	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		;use al to fill leftover slots
	mov [remainders+16], al	;fill empty slot
	mov [remainders+20], al	;fill empty slot
	mov [remainders+24], al	;fill empty slot
	mov [remainders+28], al	;fill empty slot

	pop eax			;restore eax 
	ret			;return to revious code
.done5:
	pop ebx			;restore ebx for C functions
	pop esi			;restore esi

	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		;use al to fill leftover slots
	mov [remainders+20], al	;fill empty slot
	mov [remainders+24], al	;fill empty slot
	mov [remainders+28], al	;fill empty slot

	pop eax			;restore eax 
	ret			;return to revious code
.done6:
	pop ebx			;restore ebx for C functions
	pop esi			;restore esi

	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		;use al to fill leftover slots
	mov [remainders+24], al	;fill empty slot
	mov [remainders+28], al	;fill empty slot

	pop eax			;restore eax 
	ret			;return to revious code
.done7:
	pop ebx			;restore ebx for C functions
	pop esi			;restore esi

	push eax		;preserve eax
	mov eax, 0		;clear eax
	mov al, 48		;use al to fill leftover slots
	mov [remainders+28], al	;fill empty slot

	pop eax			;restore eax 
	ret			;return to revious code
.done8:
	pop ebx			;restore ebx for C functions
	pop esi			;restore esi
	ret			;return to revious code