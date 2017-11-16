;**********************************************************
;*  TUT452.ASM
;**********************************************************
;*  Microchip Technology Incorporated
;*  17 March 2003
;*  Assembled with MPASM V3.20 and MPLINK v3.20
;**********************************************************
;*  This program configures the A/D Module to convert on
;*  A/D channel 0 (the potentiometer) and display the
;*  results on the LEDS on PORTB.  
;**********************************************************

	list p=18f452

	; Include file, change directory if needed
	include "p18f452.inc"


	; Start at the reset vector
Reset_Vector  code 0x000
	goto Start

	; Start application beyond vector area

	code	0x002A
Start
	clrf	PORTB		;Clear PORTB
	clrf	TRISB		;PORTB all outputs, display 4 MSB's
				;of A/D result on LEDs

	movlw	B'01000001'	;Fosc/8, A/D enabled
	movwf	ADCON0
	movlw	B'00001110'	;Left justify,1 analog channel
	movwf	ADCON1		;VDD and VSS references

	movlw	B'11000111'	;TMR0 prescaler, 1:256
	movwf	T0CON

Main
	btfss	INTCON,TMR0IF	;Wait for Timer0 to timeout
	goto	Main
	bcf	INTCON,TMR0IF

	bsf	ADCON0,GO	;Start A/D conversion
Wait
	btfss	PIR1,ADIF	;Wait for conversion to complete
	goto	Wait

	swapf	ADRESH,W	;Swap A/D result nibbles
	andlw	0x0f		;Mask off lower 4 bits
	movwf	PORTB		;Write A/D result to PORTB

	clrf	PORTB
WaitPush			;Pause while switch is pressed
	btfss	PORTA,4
	goto	WaitPush

	movwf	PORTB
	goto	Main		;Do it again

	end
