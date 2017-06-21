	;; Tristan Adams
	;; Due 10/9/2014
	;; Section 03
	;; Project 3
	;;   Takes in user ID's and names, then allows modification of
	;;   names based on ID's

	;; Macros
	;;    Print: L83
	;;      Prints based on 2 parameters: address and length
	;;    Read: L94
	;;      Reads based on 2 parameters: address and length
	;;    nullName: L103
	;;      'Clears' the name buffer to prevent glitchy behavior
	;;    addName: L118
	;;      adds a name to the array buffer based on an index (0-4, inc)
	;;    PrintName: L285
	;;      Prints a name based on an index (0-4, inc)

	;; Procedures
	;;    Phase 1: L172
	;;      Takes in the 5 pairs of ID/Name. Then adds each to the array
	;;    Phase 2: L301
	;;      Allows modification of names linked to IDs when user inputs that
	;;      ID. Gives error message if ID is wrong.
	;;    Phase 3: L390
	;;      Prints out the final ID/Name combos
	;;    Exit: L422
	;;      Exits the program
	;;    convertID: L271
	;;      converts the value in id buffer to an integer stored in al
	
section .bss
	id resb 3		;reserve 2 bytes for id & enter key
	id_len equ $-id		;length of the id
	name resb 10		;reserve 9 bytes for name & enter key
	name_len equ $-name	;length of the name
	;; new buffers: one for the array creation, one for the inputs in phase
	;; 2
	arr resb 50		;50 bytes for array: 1 for ID, 9 for name,
				;  repeat times 5
	arr_len equ $-arr	;length of array
	;; use 5 id registers to store as characters
	;; for final printing in phase 3
	id1 resb 2		;2 bytes for id
	id1_len equ $-id1	;length of buffer
	id2 resb 2		;2 character
	id2_len equ $-id2	;length of buffer
	id3 resb 2		;2 char
	id3_len equ $-id3	;length of buffer
	id4 resb 2		;2 chars
	id4_len equ $-id4	;length of buffer
	id5 resb 2		;2 characters
	id5_len equ $-id5	;length of buffer

section .data
idPrompt:	db 10,"Please enter the id: " 	;prompt for id
idP_len:	equ $-idPrompt		      	;length of id prompt
namePrompt:	db 10,"Please enter the name: " ;prompt for name
nameP_len:	equ $-namePrompt		;length of name prompt
p2Prompt:	db 10,"Enter ids of names to change (00 to stop)",10 ;announce
								;phase 2
						;  for starting part two 
p2P_len:	equ $-p2Prompt			;length of announcement
invalid:	db 10,"Invalid id"		;invalid id entered
inv_len:	equ $-invalid			;length of invalid response
valid:		db 10,"The name was: "		;valid response
valid_len:	equ $-valid			;valid response length
newName:	db 10,"Enter the new name: "	;prompt for new name
new_len:	equ $-newName			;length of new name prompt
idP3:		db 10,"ID:",9			;before exit, print ID
idP3_len:	equ $-idP3			;print ID length
name3:		db 10,"NAME:",9			;before exit, print name
name3_len:	equ $-name3			;print name length
return:		db 10				;return key ascii value, just
						;  in case 
ret_len:	equ $-return			;return key length

section .text
	;; prints a message
	;; %1 is message address
	;; %2 is message length
%macro Print 2
	mov ecx, %1		;address of message to print
	mov edx, %2		;length of message
	mov eax, 4		;sys_write call
	mov ebx, 1		;stdout descriptor
	int 80H			;kernel call
%endmacro

	;; reads in input
	;; %1 is address of buffer
	;; %2 is length of buffer
%macro Read 2
	mov eax, 3		;sys_read call
	mov ebx, 0		;stdin descriptor
	mov ecx, %1		;address of buffer
	mov edx, %2		;length of buffer
	int 80H			;kernel call
%endmacro

	;; clears the name buffer
%macro nullName 0
	;; clear all 10 slots by replacing with null characters
	mov byte[name], 0	;clear first slot
	mov byte[name+1], 0	;clear 2nd slot
	mov byte[name+2], 0	;clear 3rd slot
	mov byte[name+3], 0	;clear 4th slot
	mov byte[name+4], 0	;clear 5th slot
	mov byte[name+5], 0	;clear 6th slot
	mov byte[name+6], 0	;clear 7th slot
	mov byte[name+7], 0	;clear 8th slot
	mov byte[name+8], 0	;clear last slot
%endmacro

	;; adds the current name into the array
	;; %1 is the index to start from (eg 0, 1, 2, 3, 4)
%macro addName 1
	mov eax, %1		;give eax the current loop iteration
	mov edx, 10		;make edx 10 to multiply by eax
	mul edx			;multiply as mentioned
	;; eax is now at one of the following indexes: 0, 10, 20, 30, 40

	;; 1st char
	inc eax			;add one, this skips the ID
	mov bl, [name]		;move the 1st char of name to bl
	mov byte[arr+eax], bl	;put this letter into the current array string
	;; 2nd char
	inc eax			;add one, now on second character
	mov bl, [name+1]	;bl now has second char
	mov byte[arr+eax], bl	;put this character in array
	;; 3rd char
	inc eax			;add one, now on 3rd
	mov bl, [name+2]	;bl now has 3rd char
	mov byte[arr+eax], bl	;place bl into array
	;; 4th char
	inc eax			;now on 4th
	mov bl, [name+3]	;bl has 4th char
	mov byte[arr+eax], bl	;place letter into array slot
	;; 5th char
	inc eax			;now on 5th
	mov bl, [name+4]	;bl has 5th char
	mov byte[arr+eax], bl	;place letter into array slot
	;; 6th char
	inc eax			;now on 6th
	mov bl, [name+5]	;bl has 6th char
	mov byte[arr+eax], bl	;place letter into array slot
	;; 7th char
	inc eax			;now on 7th
	mov bl, [name+6]	;bl has 7th char
	mov byte[arr+eax], bl	;place letter into array slot
	;; 8th char
	inc eax			;now on 8th
	mov bl, [name+7]	;bl has 8th char
	mov byte[arr+eax], bl	;place letter into array slot
	;; 9th char
	inc eax			;now on last
	mov bl, [name+8]	;bl has last char
	mov byte[arr+eax], bl	;place letter into array slot
	;; name is now placed into the array
%endmacro

	global _start

_start:	nop			;keeps debugger happy
	call Phase1		;begin program
	call Exit		;Phase 1 calls 2, 2 calls 3, 3 returns, so exit

	;; takes in an ID and a name, as a pair, 5 times
	;; adds these pairs to a 50 byte buffer acting as a list
	;; then moves on to Phase 2
Phase1:
	mov esi, 0		;keep track of loop iterations
.loop:
	;; get ID
	Print idPrompt, idP_len	;print prompt for id
	Read id, 3		;read in an id
	;; copy ID to separate buffer
	cmp esi, 0		;if first iteration
	je .copyID1		;then copy 1st ID
	cmp esi, 1		;if 2nd iteration
	je .copyID2		;then copy 2nd id
	cmp esi, 2		;if 3rd iteration
	je .copyID3		;then copy 3rd ID
	cmp esi, 3		;if 4th iteration
	je .copyID4		;then copy 4th ID
	cmp esi, 4		;if on last iteration
	je .copyID5		;then copy 5th id
.loopConvert:
	;; convert ID and add into array
	call convertID		;convert the two characters to one int, in eax
	push esi		;preserve loop counter in stack
	push eax		;preserve ID value in stack
	;; get the index for the buffer
	mov eax, esi		;place esi value into eax for multiplication
	mov esi, 10		;move 10 into esi
	mul esi			;multiply loop counter by 10 for index
	mov esi, eax		;move new index back into esi
	;; restore eax and then move ID into proper slot in arr
	pop eax			;restore ID value to eax
	mov byte[esi+arr], al	;move ID value into 1st byte
	;; restore loop iterator and continue reading
	pop esi			;restore loop counter
	Print namePrompt, nameP_len ;print the prompt for the name
	Read name, 10		;take in the name
	;; add name based on current loop progress, and clear name buffer
	addName esi		;add this name to the array
	nullName		;'clear' the name buffer
	;; check for re-looping
	inc esi			;increment loop counter
	cmp esi, 5		;if we've looped 5 times
	je .done		;move to next phase
	jmp .loop		;elsewise, loop again

	;; Complete Phase 1
.done:
	call Phase2		;move to phase 2
	ret			;return to start

	
	;; These copy sections copy the current id to its respective slot for
	;; use in phase 3
	
	;; copy id to id1
.copyID1:
	mov eax, 0		;reset eax
	mov al, byte[id]	;move first character into al
	mov bl, byte[id+1]	;move second character into bl
	mov byte[id1], al	;copy 1st byte to 1st byte of copy
	mov byte[id1+1], bl	;copy 2nd byte to 2nd byte of copy
	jmp .loopConvert	;jump back to resume loop
	
	;; copy id to id2
.copyID2:
	mov eax, 0		;reset eax
	mov al, byte[id]	;move first character to al
	mov bl, byte[id+1]	;move second char into bl
	mov byte[id2], al	;copy 1st char
	mov byte[id2+1], bl	;copy second char
	jmp .loopConvert	;jump back to loop
	
	;; copy id to id3
.copyID3:
	mov eax, 0		;reset eax
	mov al, byte[id]	;move 1st char to al
	mov bl, byte[id+1]	;move 2nd char to bl
	mov byte[id3], al	;copy 1st char
	mov byte[id3+1], bl	;copy 2nd char
	jmp .loopConvert	;jump back to loop
	
	;; copy id to id4
.copyID4:
	mov eax, 0		;reset eax
	mov al, byte[id]	;move 1st char to al
	mov bl, byte[id+1]	;2nd char to bl
	mov byte[id4], al	;copy 1st char
	mov byte[id4+1], bl	;copy second char
	jmp .loopConvert	;jump to resume loop
	
	;; copy id to id5
.copyID5:
	mov eax, 0		;reset eax
	mov al, byte[id]	;move 1st char to al
	mov bl, byte[id+1]	;2nd char to bl
	mov byte[id5], al	;copy 1st char
	mov byte[id5+1], bl	;copy 2nd char
	jmp .loopConvert	;jump to resume loop
	
	;; converts the input ID into a 1 byte integer and moves this value
	;; into eax, then returns
convertID:
	;; convert id address ascii values to integers, 0 is 48, so subtract 48
	sub byte[id], 48	;first index
	sub byte[id+1], 48	;second index
	;; make eax into an integer representing 
	mov eax, 0		;make eax 0
	add al, byte[id]	;add ID value to eax
	mov bl, 10		;move 10 for scaling first digit
	mul bl			;multiply first digit of buffer by ten, to scale
	add al, byte[id+1]	;add second digit of ID
	ret			;return to previous code

	;; prints a name based on the index of the array
	;; %1 is current index
%macro PrintName 1
	mov eax, %1		;pass index to eax
	mov edi, 10		;pass 10 to edi
	mul edi			;multiply eax by 10
	inc eax			;add 1
	;; eax is now the index in the buffer to print from
	mov ecx, arr		;ecx is now starting from array
	add ecx, eax		;increment ecx eax number of times
	mov edx, 9		;max length of name is 9
	mov eax, 4		;sys_write call
	mov ebx, 1		;stdout descriptor
	int 80H			;kernel call for printing
%endmacro
	
	;; takes in an id, then allows modification of the respective name
	;; until the ID input is '00', then calls Phase 3
Phase2:
	Print p2Prompt, p2P_len	;print phase 2 prompt
	;; This loop section reads in the ID and checks for  exit conditions
.loopRead:
	Print idPrompt, idP_len	;print ID prompt
	Read id, 3		;read a two character ID in
	cmp byte[id], 30H	;compare first character to ascii 0
	je .exitCheck		;if equal, jump to a check
	;; this part of the checks the ID against existing ones
	;; and modifies the name if valid
.loopModify:
	call convertID		;convert id to decimal, store in eax/al
	cmp al, byte[arr]	;compare input to first id
	je .first		;modify first name
	cmp al, byte[arr+10]	;compare input to 2nd id
	je .second		;modify second name
	cmp al, byte[arr+20]	;compare input to 3rd id
	je .third		;modify 3rd name
	cmp al, byte[arr+30]	;compare input to 4th id
	je .fourth		;modify 4th name
	cmp al, byte[arr+40]	;compare input to 5th id
	je .fifth		;modify 5th name
	Print invalid, inv_len	;if none of the checks pass, input is invalid
	jmp .loopRead		;jump to top of loop to restart

	;; replace first name
.first:
	Print valid, valid_len	;print the valid ID message
	PrintName 0		;print the correct name
	Print namePrompt, nameP_len ;ask for new name
	Read name, name_len	;read in the new name
	addName 0		;add this name into the array
	nullName		;clear name buffer
	jmp .loopRead		;jump to top of loop
	
	;; replace second name
.second:
	Print valid, valid_len	;print the valid ID message
	PrintName 1		;print correct index name
	Print namePrompt, nameP_len ;ask for new name
	Read name, name_len	;read in the new name
	addName 1		;add this name into the array
	nullName		;clear name buffer
	jmp .loopRead		;jump to top of loop
	
	;; replace third name
.third:
	Print valid, valid_len	;print the valid ID message
	PrintName 2		;print correct index name
	Print namePrompt, nameP_len ;ask for new name
	Read name, name_len	;read in the new name
	addName 2		;add this name into the array
	nullName		;clear name buffer
	jmp .loopRead		;jump to top of loop

	;; replace 4th name
.fourth:
	Print valid, valid_len	;print valid ID message
	PrintName 3		;print correct index Name
	Print namePrompt, nameP_len ;ask for new name
	Read name, name_len	;read in the new name
	addName 3		;add this name into the array
	nullName		;clear name buffer
	jmp .loopRead		;jump to top of loop
	
	;; replace 5th name
.fifth:
	Print valid, valid_len	;print valid ID message
	PrintName 4		;print correct index name
	Print namePrompt, nameP_len ;ask for new name
	Read name, name_len	;read in the new name
	addName 4		;add this name into the array
	nullName		;clear name buffer
	jmp .loopRead		;jump to top of loop
	
	
	;; if first character in ID is 0, come here to check second character
.exitCheck:
	cmp byte[id+1], 30H	;if second char is ascii 0 as well
	je .done		;then jump to Phase 3
	jmp .loopModify		;resume normal code

	;; Complete Phase 2, move to Phase 3
.done:
	call Phase3		;finish and move on to phase 3
	ret			;return to Phase 1
	
	;; print out each of the 5 id/array pairs
	;; then exit the program
Phase3:
	;; first ID and name
	Print idP3, idP3_len	;print ID line
	Print id1, 2		;print id 1
	Print name3, name3_len	;print name line
	PrintName 0		;print name 1
	;; 2nd ID and name
	Print idP3, idP3_len	;print ID line
	Print id2, 2		;print id 2
	Print name3, name3_len	;print name line
	PrintName 1		;print name 2
	;; 3rd ID and name
	Print idP3, idP3_len	;print ID line
	Print id3, 2		;print ID 3
	Print name3, name3_len	;print name line
	PrintName 2		;print name 3
	;; 4th ID and name
	Print idP3, idP3_len	;print ID line
	Print id4, 2		;print ID 4
	Print name3, name3_len	;print name line
	PrintName 3		;print name 3
	;; 5th ID and name
	Print idP3, idP3_len	;print ID line
	Print id5, 2		;print ID 5
	Print name3, name3_len	;print name line
	PrintName 4		;print name 5

	ret			;return back to start
	
	;; Exit the program
	;; AFTER 10000 YEARS IM FREEEEEEEEEEE
	;; TIME TO CONQUER EARTH
Exit:	mov eax, 1		;Exit system call
	mov ebx, 0		;return code of 0 to linux
	int 80H			;kernel call