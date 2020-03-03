$MODLP51
org 0000H
   ljmp MainProgram

CLK  EQU 22118400
BAUD equ 115200
BRG_VAL equ (0x100-(CLK/(16*BAUD)))

; These register definitions needed by 'math32.inc'
DSEG at 30H
x:   ds 4
y:   ds 4
bcd: ds 5
Result: ds 2

BSEG
mf: dbit 1

$include (LCD_4bit.inc)
$include (math32.inc)

; Configure the serial port and baud rate
InitSerialPort:
    ; Since the reset button bounces, we need to wait a bit before
    ; sending messages, otherwise we risk displaying gibberish!
    mov R1, #222
    mov R0, #166
    djnz R0, $   ; 3 cycles->3*45.21123ns*166=22.51519us
    djnz R1, $-4 ; 22.51519us*222=4.998ms
    ; Now we can proceed with the configuration
	orl	PCON,#0x80
	mov	SCON,#0x52
	mov	BDRCON,#0x00
	mov	BRL,#BRG_VAL
	mov	BDRCON,#0x1E ; BDRCON=BRR|TBCK|RBCK|SPD;
    ret ; return from function call - reti used to return from interrupt

; Send a character using the serial port
putchar:
    jnb TI, putchar ; TI: timer interrupt - one of these is a serial interrupt
    clr TI
    mov SBUF, a
    ret

; Send a constant-zero-terminated string using the serial port
SendString:
    clr A
    movc A, @A+DPTR
    jz SendStringDone ; jz: transfers control to specified address if acc = 0; else, just executes next instr.
    lcall putchar ; putchar: transmits character using serial port
    inc DPTR ; increments character by character through string
    sjmp SendString
SendStringDone:
    ret 
    
;Newline:
;	DB '\r', '\n', 0
	
CtoF:

	DB 'FG', 0 ;  17991
	
uproutine:

	DB 'up', 0
	
downroutine:

	DB 'dn', 0
 
;Hello_World:
 ;   DB  'Hello, World!', '\r', '\n', 0
  					
;-----------;
; SPI Comms ;
;-----------;

CE_ADC EQU P2.0
MY_MOSI EQU P2.1
MY_MISO EQU P2.2
MY_SCLK EQU P2.3
flagbutton EQU P2.5
upbutton EQU P2.6
downbutton EQU P2.7

INIT_SPI:
	setb MY_MISO ; Make MISO an input pin
	clr MY_SCLK ; For mode (0,0) SCLK is zero
	ret
	
DO_SPI_G:
	mov R1, #0 ; Received byte stored in R1
	mov R2, #8 ; Loop counter (8-bits)
	
DO_SPI_G_LOOP:

; Probable CONOPS: Save bit, shift left, save next bit, shift left... until 8 bits filled

	mov a, R0 ; Byte to write is in R0
	rlc a ; Carry flag has bit to write - rlc: rotates eight bits in acc and one bit in carry flag left one bit
	mov R0, a
	mov MY_MOSI, c
	setb MY_SCLK ; Transmit
	mov c, MY_MISO ; Read received bit
	mov a, R1 ; Save received bit in R1
	rlc a
	mov R1, a
	clr MY_SCLK
	djnz R2, DO_SPI_G_LOOP
	ret

;----------;
; SEND_BCD ;
;----------;

Send_BCD mac
	push ar0
	mov r0, %0
	;mov r0, Result
	lcall ?Send_BCD
	pop ar0
endmac

?Send_BCD:
	push acc
	; Write most sig digit
	mov a, r0
	swap a
	anl a, #0fh
	orl a, #30h
	lcall putchar
	; Write least sig digit
	mov a, r0
	anl a, #0fh
	orl a, #30h
	lcall putchar
	pop acc
	ret
		
;------;
; MAIN ;
;------;

MainProgram:
    mov SP, #7FH ; set the stack pointer to the begining of idata
    
    lcall InitSerialPort
    lcall INIT_SPI
 
Forever:   
    clr CE_ADC 
	mov R0, #00000001B
	lcall DO_SPI_G
	
	mov R0, #10000000B
	lcall DO_SPI_G
	mov a, R1
	anl a, #00000011B
	mov Result+1, a

	mov R0, #55H
	lcall DO_SPI_G
	mov Result, R1
	setb CE_ADC
	lcall Delay
	
	lcall Do_Something_With_Result
	
check:
	jb flagbutton, check2
;	jb flagbutton, return
	cpl P3.6
	
	mov DPTR, #CtoF
  	lcall SendString
    Wait_Milli_Seconds(#200)
	Wait_Milli_Seconds(#200)
	cpl P3.6
	
	sjmp return
	
;	Wait_Milli_Seconds(#200)
;	Wait_Milli_Seconds(#200)
;	Wait_Milli_Seconds(#200)

check2:
;
	jb upbutton, check3
	mov DPTR, #uproutine
	lcall SendString
	Wait_Milli_Seconds(#200)
	Wait_Milli_Seconds(#200)
;
	sjmp return
;	
check3:	
	
	jb downbutton, return
	mov DPTR, #downroutine
	lcall SendString
	Wait_Milli_Seconds(#200)
	Wait_Milli_Seconds(#200)
;	
	sjmp return
	
return:
	sjmp Forever
    
Delay: 
	Wait_Milli_Seconds(#200)
; 	Wait_Milli_Seconds(#200)
;	Wait_Milli_Seconds(#200)
;	Wait_Milli_Seconds(#200)
;	Wait_Milli_Seconds(#200)
	ret
    
Do_Something_With_Result:

	;mov Result, #2
	mov x, Result
	mov x+1, Result+1
	mov x+2, #0
	mov x+3, #0
	
	lcall hex2bcd
	mov Result, bcd
	
	LOAD_Y(410)
	lcall mul32
	
	LOAD_Y(1023)
	lcall div32
	
	LOAD_Y(273)
	lcall sub32
	
	lcall hex2bcd
	;Send_BCD(bcd+3)
	;Send_BCD(bcd+2)
	;Send_BCD(bcd+1)
	Send_BCD(bcd)
	
	
	
	
;	mov DPTR, #Period
 ; 	lcall SendString
	
	;Send_BCD(bcd-1)
	
;	mov DPTR, #Newline
;  	lcall SendString
	
	ret
	
;Period:
;	DB '.', 0
	
	; Displays correct value currently stored in register R1
	
;	mov a, R6
;	mov x, a
;	lcall hex2bcd
;	mov a, x
;	

	
;	mov a, #0x80 ; indicates Calculator mode
 ;   lcall ?WriteCommand
  ;  mov a, x
   ; lcall ?``
   
   ; mov a, #0x05
	
  
  ;  mov DPTR, #five
    ;lcall sendchar
    
;    clr A
;    movc A, @A+DPTR
    
 ;   lcall SendString
    
;five: DB '5', 0 
    
    
    sjmp $ ; This is equivalent to 'forever: sjmp forever'
    
END
