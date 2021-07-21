.equ SWI_Open, 0x66         @ open a file 
	.equ SWI_Close,0x68         @ close a file
	.equ SWI_PrChr,0x00         @ Write an ASCII char to Stdout 
	.equ SWI_PrStr, 0x69        @ Write a null-ending string 
	.equ SWI_PrInt,0x6b         @ Write an Integer 
	.equ SWI_RdInt,0x6c         @ Read an Integer from a file 
	.equ Stdout, 1          @ Set output target to be Stdout 
	.equ SWI_Exit, 0x11         @ Stop execution 
	
	.data
.align

	@Defining our data including filename, new lines, and messages for each Generation
	
filename:
	.asciz "Integers.dat"

	
LostMessage:
		.asciz "Lost generation:	"
	
GreatestMessage:
		.asciz "Greatest generation:	"
		
BoomerMessage:
		.asciz "Baby Boomer generation:	"
		
GenXMessage:
		.asciz "Generation X:	"

GenYMessage:
		.asciz "Generation Y:	"		

GenZMessage:
		.asciz "Generation Z:	"

NoneMessage:
		.asciz "Not Applicable:	"		
	.text

	.global _start
	
	
_start:
		@We will now open the file and prepare our Integer grabbing registers
		mov r3, #'\n	@our new line loading register
		ldr r0, =filename 
		mov r1, #0		@Preparing r1 for input
		swi SWI_Open
		bcs ReachedEnd     @Here we check the carry flag to see if the file exists
		mov r2, r0		   @Now that r0 is our filehandle, we store it in r2 for our loop
		
		
MyLoop:						@The loop for reading Integers and sending them to be categorized
		
		mov r0, r2		@Moving the file handle back on each loop to read Integers
		
		swi SWI_RdInt
		
		/*@Once we reach the end of our file in loop we begin the printing process.
			Alternatively, if this is the first iteration with no integers found in file
			at all, we will be sent to printTotal empty handed, which will just skip over 
			to our ReachedEnd protocol anyways.*/
			
		bcs PrintTotal 		
	
	/*We now have our Integer in r0, so we must categorize it,
			these checks will categorize into their respective generations*/
		
		
	/*these checks compare the Integer to the lower ranges of our Generations
			if they come out negative, it means the Integer is lower than that Generation and should keep searching */
			
			/*If the condition for a specific generation is met, 1 is added to their respective counters
				and the loop restarts once again.*/
		cmp r0, #128  
		addpl r10, r10, #1	
		bpl MyLoop
			
		cmp r0, #102
		addpl r4, r4, #1
		bpl MyLoop
		
		cmp r0, #93
		addpl r5, r5, #1
		bpl MyLoop
		
		cmp r0, #72
		addpl r10, r10, #1
		bpl MyLoop
		
		cmp r0, #53
		addpl r6, r6, #1
		bpl MyLoop
		
		cmp r0, #38
		addpl r7, r7, #1
		bpl MyLoop
		
		cmp r0, #37
		addeq r10, r10, #1
		beq MyLoop
		
		cmp r0, #22
		addpl r8, r8, #1
		bpl MyLoop
		
		cmp r0, #7
		addpl r9, r9, #1
		bpl MyLoop
		
		
		@If a number gets to this point in our code then it is automatically not applicable.
		
		add r10, r10, #1		
		
		
		bal MyLoop	@Always branches back to the beginning
		

	
	/*Our loop branches here once we reached the file end, now we check if the loop found any Integers for 
		each Gen to print out, then does so if true*/
	
	PrintTotal:			
	mov r0, #Stdout		@We prepare to output our Totals, and replace \n out of r0 for outputting for Generations below
	cmp r4, #0			@Our check to make sure an age within this group was actually found
	beq GreatestPrint 	@If the amount in this generation is 0, it skips to the next generation
	ldr r1, =LostMessage	@Assuming the amount is more than 0, we begin printing our message beginning with our Generation String
	swi SWI_PrStr
	mov r1, r4				@Next, printing the actual number in the generation itself.
	swi SWI_PrInt
	mov r0, r3				@Appending new line saved in r3 to r0 and printing to prepare for printing any other generation outputs
	swi SWI_PrChr

GreatestPrint:
	mov r0, #Stdout
	cmp r5, #0
	beq BoomerPrint
	ldr r1, =GreatestMessage
	swi SWI_PrStr
	mov r1, r5
	swi SWI_PrInt
	mov r0, r3
	swi SWI_PrChr

BoomerPrint:
	mov r0, #Stdout
	cmp r6, #0
	beq GenXPrint
	ldr r1, =BoomerMessage
	swi SWI_PrStr
	mov r1, r6
	swi SWI_PrInt 
	mov r0, r3
	swi SWI_PrChr

GenXPrint:
	mov r0, #Stdout
	cmp r7, #0
	beq GenYPrint
	ldr r1, =GenXMessage
	swi SWI_PrStr
	mov r1, r7
	swi SWI_PrInt 
	mov r0, r3
	swi SWI_PrChr

GenYPrint:
	mov r0, #Stdout
	cmp r8, #0
	beq GenZPrint
	ldr r1, =GenYMessage
	swi SWI_PrStr
	mov r1, r8
	swi SWI_PrInt 
	mov r0, r3
	swi SWI_PrChr

GenZPrint:
	mov r0, #Stdout
	cmp r9, #0
	beq NonePrint
	ldr r1, =GenZMessage
	swi SWI_PrStr
	mov r1, r9
	swi SWI_PrInt 
	mov r0, r3
	swi SWI_PrChr

NonePrint:
	mov r0, #Stdout
	cmp r10, #0
	beq ReachedEnd
	ldr r1, =NoneMessage
	swi SWI_PrStr
	mov r1, r10
	swi SWI_PrInt
	mov r0, r3
	swi SWI_PrChr
	

	
ReachedEnd:		@Here we close our file
	mov r0, #Stdout
	mov r0, r2	@FileHandle goes back into r0 to execute SWI_Close correctly
	swi SWI_Close
		
	swi SWI_Exit
	.end
