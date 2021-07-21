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
	.equ SWI_SETSEG8, 0x200 @display on 8 Segment
	.equ SWI_SETLED, 0x201 @LEDs on/off
	.equ SWI_CheckBlack, 0x202 @check Black button
	.equ SWI_CheckBlue, 0x203 @check press Blue button
	.equ SWI_DRAW_STRING, 0x204 @display a string on LCD
	.equ SWI_DRAW_INT, 0x205 @display an int on LCD
	.equ SWI_CLEAR_DISPLAY,0x206 @clear LCD
	.equ SWI_DRAW_CHAR, 0x207 @display a char on LCD
	.equ SWI_CLEAR_LINE, 0x208 @clear a line on LCD
	.equ SWI_EXIT, 0x11 @terminate program
	.equ SWI_GetTicks, 0x6d @get current time
	.equ LEFT_BLACK_BUTTON,0x02 @bit patterns for black buttons
	.equ RIGHT_BLACK_BUTTON,0x01 @and for blue buttons 
	.equ BLUE_KEY_00, 0x01 @button(0)	@Assigning various button values.
	.equ BLUE_KEY_01, 0x02 @button(1)
	.equ BLUE_KEY_02, 0x04 @button(2)
	.equ BLUE_KEY_03, 0x08 @button(3)
	.equ BLUE_KEY_04, 0x10 @button(4)
	.equ BLUE_KEY_05, 0x20 @button(5)
	.equ BLUE_KEY_06, 0x40 @button(6)
	.equ BLUE_KEY_07, 0x80 @button(7) 
	.equ BLUE_KEY_08, 1<<8 @button(8)
	.equ BLUE_KEY_09, 1<<9 @button(9)
	.equ BLUE_KEY_10, 1<<10 @button(10)
	.equ BLUE_KEY_11, 1<<11 @button(11)
	.equ BLUE_KEY_12, 1<<12 @button(12)
	.equ BLUE_KEY_13, 1<<13 @button(13)
	.equ BLUE_KEY_14, 1<<14 @button(14)
	.equ BLUE_KEY_15, 1<<15 @button(15)
	.equ SEG_A,0x80		@Assigning various 8 segment hex values.
	.equ SEG_B,0x40
	.equ SEG_C,0x20
	.equ SEG_D,0x08
	.equ SEG_E,0x04
	.equ SEG_F,0x02
	.equ SEG_G,0x01
	.equ SEG_P,0x10
	.equ THREE_SECONDS, 3000
	.equ Point1Sec, 100
	.equ EmbestTimerMask, 0x7fff
	.equ Top15bitRange, 0x0000ffff
	.equ CLEAR_LED, 0
	

	.data

Invalid_Button: .asciz "Invalid Button, use 0-9, or +/- keys."

Start_message: .asciz "Select a valid button to calculate."	

Add_message: .asciz "Addition Total = "

Sub_message: .asciz "Subtract Total = "


LED_Digit: 	@Our array/jump table for accessing different 8 segment patterns.
	.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G @0	
	.word SEG_B|SEG_C @1
	.word SEG_A|SEG_B|SEG_F|SEG_E|SEG_D @2
	.word SEG_A|SEG_B|SEG_F|SEG_C|SEG_D @3
	.word SEG_G|SEG_F|SEG_B|SEG_C @4
	.word SEG_A|SEG_G|SEG_F|SEG_C|SEG_D @5
	.word SEG_A|SEG_G|SEG_F|SEG_E|SEG_D|SEG_C @6
	.word SEG_A|SEG_B|SEG_C @7
	.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @8
	.word SEG_A|SEG_B|SEG_F|SEG_G|SEG_C @9
	.word 0 @Blank display


.align
	
	.global _start
	.text
	_start:
	Start_Message:

	bl Startup	@Sends a startup message
	
		
	
	Button_Listener:		@This is where we listen to see which buttons are pressed and subsequently what to do with them.
		
		swi SWI_CheckBlue	@If the swi command detects a button pressed it should have a value not zero, this will detect it
		cmp r0, #0			@And then move down further into our program, the same applies when checking for black buttons.
		bne Operation
	
		swi SWI_CheckBlack	
		cmp r0, #0
		bne Operation2
				
		
	B Button_Listener
	
	
	
	Operation2:	@If a Black Button was pressed
		swi SWI_CLEAR_DISPLAY
		mov r5, #0
		cmp r0, #LEFT_BLACK_BUTTON	
		beq lbb
		cmp r0, #RIGHT_BLACK_BUTTON
		beq rbb
	b Button_Listener
		
		
		
	lbb:	@Handles functions for the left black button, including clearing the 8 segment and flashing.
		mov r0, #0
		swi SWI_SETSEG8
		mov r0, #LEFT_BLACK_BUTTON
		bl bb_flash	
	b Button_Listener
	
	rbb:	@Handles functions for the right black button.
		mov r0, #0
		swi SWI_SETSEG8
		mov r0, #RIGHT_BLACK_BUTTON
		bl bb_flash	
	b Button_Listener
	
	
	Operation:	@If a Blue Button was pressed
	
		cmp r0, #BLUE_KEY_15
			beq Invalid
		cmp r0, #BLUE_KEY_14
			beq Invalid
		cmp r0, #BLUE_KEY_13
			beq Thirteen
		cmp r0, #BLUE_KEY_12
			beq Invalid
		cmp r0, #BLUE_KEY_11
			beq Invalid
		cmp r0, #BLUE_KEY_10
			beq Ten
		cmp r0, #BLUE_KEY_09
			beq Nine
		cmp r0, #BLUE_KEY_08
			beq Eight
		cmp r0, #BLUE_KEY_07
			beq Seven
		cmp r0, #BLUE_KEY_06
			beq Six
		cmp r0, #BLUE_KEY_05
			beq Five
		cmp r0, #BLUE_KEY_04
			beq Four
		cmp r0, #BLUE_KEY_03
			beq Three
		cmp r0, #BLUE_KEY_02
			beq Two
		cmp r0, #BLUE_KEY_01
			beq One
		cmp r0, #BLUE_KEY_00
			beq Zero
	
	Invalid:	@Displays 'invalid button' message on our LCD.
		swi SWI_CLEAR_DISPLAY
		ldr r2, =Invalid_Button @Loading invalid button message
		mov r0, #0
		mov r1, #0
		swi SWI_DRAW_STRING
		swi SWI_SETSEG8
	b Button_Listener
	
	
	Thirteen:	@Add/Subtract Zero
		bl Flash_Lights	@Executes the flashing of lights.
		ldr r2, =LED_Digit	@Since the pattern for 0 is the first in my array, I do not need to perform jumps.
		ldr r0, [r2]	@Loading the 8 segment pattern for 0.
		swi SWI_SETSEG8
		cmp r4, #0	@Checking if program is in subtraction mode and if so, we subtract instead of adding.
		addeq r5, r5, #0
		subne r5, r5, #0
	b Display_Result	@Branch to print the result to our LCD.
	
	Ten:	@Add/Subtract Three
		bl Flash_Lights
		ldr r2, =LED_Digit
		add r2, r2, #12	@Here we must jump three times to reach the 8 segment pattern for 3 before loading into r0.
		ldr r0, [r2]
		sub r2, r2, #12
		swi SWI_SETSEG8
		cmp r4, #0
		addeq r5, r5, #3
		subne r5, r5, #3
	b Display_Result
	
	Nine:	@Add/subtract Two
		bl Flash_Lights
		ldr r2, =LED_Digit
		add r2, r2, #8
		ldr r0, [r2]
		sub r2, r2, #8
		swi SWI_SETSEG8
		cmp r4, #0
		addeq r5, r5, #2
		subne r5, r5, #2
	b Display_Result
	
	Eight:	@Add/Subtract One
		bl Flash_Lights
		ldr r2, =LED_Digit
		add r2, r2, #4
		ldr r0, [r2]
		sub r2, r2, #4
		swi SWI_SETSEG8
		cmp r4, #0
		addeq r5, r5, #1
		subne r5, r5, #1
	b Display_Result
	
	Seven:	@Changes program mode to addition (This is also our default)
		mov r4, #0		
		mov r0, #0
		swi SWI_SETSEG8		@We change the program mode as well as clear the 8 segment, same logic as for handling subtraction.
	b Button_Listener
	
	Six:	@Add/Subtract Six
		bl Flash_Lights
		ldr r2, =LED_Digit
		add r2, r2, #24
		ldr r0, [r2]
		sub r2, r2, #24
		swi SWI_SETSEG8
		cmp r4, #0
		addeq r5, r5, #6
		subne r5, r5, #6
	b Display_Result
	
	Five:	@Add/Subtract Five
		bl Flash_Lights
		ldr r2, =LED_Digit
		add r2, r2, #20
		ldr r0, [r2]
		sub r2, r2, #20
		swi SWI_SETSEG8
		cmp r4, #0
		addeq r5, r5, #5
		subne r5, r5, #5
	b Display_Result
	
	Four:	@Add/Subtract Four
		bl Flash_Lights
		ldr r2, =LED_Digit
		add r2, r2, #16
		ldr r0, [r2]
		sub r2, r2, #16
		swi SWI_SETSEG8
		cmp r4, #0
		addeq r5, r5, #4
		subne r5, r5, #4
	b Display_Result
	
	Three:	@Changes program mode to subtraction
		mov r4, #1
		mov r0, #0
		swi SWI_SETSEG8
	b Button_Listener
	
	Two:	@Add/subtract Nine
		bl Flash_Lights	
		ldr r2, =LED_Digit
		add r2, r2, #36
		ldr r0, [r2]
		sub r2, r2, #36
		swi SWI_SETSEG8
		cmp r4, #0
		addeq r5, r5, #9
		subne r5, r5, #9
	b Display_Result
	
	One:	@Add/Subtract Eight
		bl Flash_Lights
		ldr r2, =LED_Digit
		add r2, r2, #32
		ldr r0, [r2]
		sub r2, r2, #32
		swi SWI_SETSEG8
		cmp r4, #0
		addeq r5, r5, #8
		subne r5, r5, #8
	b Display_Result
	
	Zero:	@Add/Subtract Seven
		bl Flash_Lights
		ldr r2, =LED_Digit
		add r2, r2, #28
		ldr r0, [r2]
		sub r2, r2, #28
		swi SWI_SETSEG8
		cmp r4, #0
		addeq r5, r5, #7
		subne r5, r5, #7



	
	Display_Result:		@Here we display our result, and decide whether to display a negative result or not.
		swi SWI_CLEAR_DISPLAY
		cmp r4, #0   @Check to see if we are subtracting or adding, and use the correct respective message.
		ldrgt r2, =Sub_message
		ldreq r2, =Add_message
		mov r0, #0
		mov r1, #0
		swi SWI_DRAW_STRING
		mov r0, #18
		mov r1, #0
		cmp r5, #0	@Due to the nature of the LCD, we must check if our result is negative, if so we print a - sign, compliment the number then print the unsigned number. 
		bge print_int
		mov r2, #'-
		mov r6, r5
		mvn r5, r5
		add r5, r5, #1
		swi SWI_DRAW_CHAR
		mov r0, #19
		mov r2, r5
		swi SWI_DRAW_INT
		mov r5, r6
		b Button_Listener
		
		print_int:
			mov r2, r5
			swi SWI_DRAW_INT
	
	b Button_Listener
	
	bb_flash:	@Button flashing starts here if the button is black, since different buttons flash.
		
		stmfd sp!, {r0-r6}
		b Turn_On
	
	Flash_Lights:	@This function handles our timed button flashing.
		
		stmfd sp!, {r0-r6}		@Storing all of the register values we will use for flashing in the stack before loading new parameters. 
		mov r0, #(LEFT_BLACK_BUTTON|RIGHT_BLACK_BUTTON)

	
	Turn_On:	@Here we begin by turning on the light and setting our 15 bit timer.
		
		swi SWI_SETLED
		ldr r1, =THREE_SECONDS
		ldr r4, =EmbestTimerMask
		ldr r5, =Top15bitRange
		ldr r3, =Point1Sec
		swi SWI_GetTicks
		mov r1, r0	
		and r1, r1, r4
	 
			Wait_Loop:	
				swi SWI_GetTicks
				mov r2, r0	
				and r2, r2, r4
				cmp r2, r1
				bge Roll
				sub r6, r5, r1
				add r6, r6, r2
			b CmpLoop
	
				Roll: 	
					sub r6, r2, r1
	
				CmpLoop:
					cmp r6, r3
		
			blt Wait_Loop
	
	
		mov r0, #CLEAR_LED
		swi SWI_SETLED
		ldmfd sp!, {r0-r6}	@Here we load back all of our stored values in the stack.
	
	
	bx lr
		
	Startup:
		mov r0, #0
		mov r1, #0
		ldr r2, =Start_message
		swi SWI_DRAW_STRING
	bx lr
	
	swi SWI_Exit
	.end



