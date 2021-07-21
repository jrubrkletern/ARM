	.equ SWI_Open, 0x66         @ open a file 
	.equ SWI_Close,0x68         @ close a file
	.equ SWI_PrChr,0x00         @ Write an ASCII char to Stdout 
	.equ SWI_PrStr, 0x69        @ Write a null-ending string 
	.equ SWI_RdStr, 0x6a		@Reads a string from file
	.equ SWI_PrInt,0x6b         @ Write an Integer 
	.equ SWI_RdInt,0x6c         @ Read an Integer from a file 
	.equ Stdout, 1          @ Set output target to be Stdout 
	.equ SWI_Exit, 0x11         @ Stop execution 
	.equ SWI_MeAlloc, 0x12
	.equ SWI_MeDalloc, 0x13

	.data

	
EncryptCommand:
	.asciz "inputCommand.txt"

MessageFile:
	.asciz "messageInput.txt"

OutputFile:
	.asciz "output.txt"

MyArray:	.word 0

OutputArray:	.word 0




.align
	
	.global _start
	.text
	_start:
	
Load_Parameters:		@We start by loading our parameter file, which includes instructions to encrypt/decrypt, and encryption vector.
	ldr r0, =EncryptCommand
	mov r1, #0
	swi SWI_Open
	bcs ReachedEnd
	mov r4, r0
	bl Load_Parameters_Loop @This loop loads our integers

	mov r0, r4
	cmp r6, #0
	beq ReachedEnd
	swi SWI_Close
	cmp r8, #128
	bhs ReachedEnd			@If our encryption vector is greater than 127, we will close the program.


Mode_Selector:

	mov r0, #0
	cmp r7, #0
	ldr r0, =MessageFile
	beq Load_String
	cmp r7, #1
	ldr r0, =OutputFile
	beq Load_String			@Here we chose what to do based on our instructions.

	b ReachedEnd

	Load_String:			@Loading our dynamic array and input
		
		mov r1, #0
		swi SWI_Open
		bcs ReachedEnd
		mov r4, r0
		mov r2, #1000
		mov r0, #1000
		swi SWI_MeAlloc
		ldr r1, =MyArray
		str r0, [r1]
		mov r0, r4
		swi SWI_RdStr
		bcs ReachedEnd
		mov r9, r0

		sub r9, r9, #1
		mov r10, #0

b Encryption_Operations




Encryption_Operations:
	mov r6, #0
	bl Encryption_Loop_Stack		@We process our message and encrypt/decrypt it, and store in the stack.

	add r10, r10, #1
	sub r1, r1, r10
	mov r0, r4
	swi SWI_Close
	

	mov r0, #1000				@Allocating our 2nd dynamic array
	swi SWI_MeAlloc
	ldr r2, =OutputArray
	str r0, [r2]
	mov r10, #0

	bl Store_Output					@This function will reset our stack pointer and load the message into our 2nd array.


Print_Output:					@Now we print out the output.

	ldr r0, =OutputFile

	mov r1, #1
	swi SWI_Open
	
	mov r4, r0
	mov r10, r1				@Save our input array address before we move our output array to r1 for printing to file.
	mov r1, r2
	
	swi SWI_PrStr

	b ReachedEnd


ReachedEnd:
	swi SWI_MeDalloc
	mov r0, r4
	swi SWI_Close
	swi SWI_Exit

	
	
	

Store_Output:

	mov r6, #0
	stmfd r13!, {r6}

	
	resetStackLoop:
		cmp r10, r9

		beq Store_Stack
		ldmfd r13!, {r3}

		add r10, r10, #1
	b resetStackLoop

	Store_Stack:
		mov r10, #0
		add r9, r9, #1
		Store_Stack_Loop:
		cmp r10, r9
		beq reset_Output
		
		ldmfa r13!, {r3}
		
		strb r3, [r2]
		
		add r2, r2, #1
		add r10, r10, #1

		b Store_Stack_Loop

	
	reset_Output:
		sub r2, r2, r10
		mov r10, #0

		mov pc, r14

Encryption_Loop_Stack:

	cmp r10, r9
	moveq pc, r14
	ldrb r3, [r1]
	cmp r3, #128
	eorle r3, r3, r8
	
	mov r0, r3
	add r1, r1, #1
	add r10, r10, #1
	
	stmfd r13!, {r3}
b Encryption_Loop_Stack


Load_Parameters_Loop:
	mov r0, r4
	swi SWI_RdInt
	movcs pc, r14
	add r6, r6, #1
	cmp r6, #1
	moveq r7, r0
	movne r8, r0
	b Load_Parameters_Loop



	.end


