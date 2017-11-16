;******************************************************************************
;   This file is a basic template for assembly code for a PIC18F6310. Copy    *
;   this file into your project directory and modify or add to it as needed.  *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on the         *
;   features of the assembler.                                                *
;                                                                             *
;   Refer to the PIC18FX515/X610 Data Sheet for additional                    *
;   information on the architecture and instruction set.                      *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Filename:                                                                *
;    Date:                                                                    *
;    File Version:                                                            *
;                                                                             *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             * 
;******************************************************************************
;                                                                             *
;    Files Required: P18F6310.INC                                             *
;                                                                             *
;******************************************************************************

	LIST P=18F6310	;directive to define processor
	#include <P18F6310.INC>	;processor specific variable definitions

;******************************************************************************
;Configuration bits
;Microchip has changed the format for defining the configuration bits, please 
;see the .inc file for futher details on notation.  Below are a few examples.



;   Oscillator Selection:
    CONFIG	OSC = LP             ;LP

;******************************************************************************
;Variable definitions
; These variables are only needed if low priority interrupts are used. 
; More variables may be needed to store other special function registers used
; in the interrupt routines.

		CBLOCK	0x080
		WREG_TEMP	;variable used for context saving 
		STATUS_TEMP	;variable used for context saving
		BSR_TEMP	;variable used for context saving
		ENDC

		CBLOCK	0x000
		EXAMPLE		;example of a variable in access RAM
		ENDC


;******************************************************************************
;Reset vector
; This code will start executing when a reset occurs.

RESET_VECTOR	org	0x0000

		goto	Main		;go to start of main code

;******************************************************************************
;High priority interrupt vector

HISR		org	0x0008

		goto 	HighInt		; go to High Priority Interrupt routine

;******************************************************************************
;Low priority interrupt vector and routine

LISR		org	0x0018

		goto 	LowInt		; go to Low Interrupt Routine

MAIN_PROGRAM	org	0x50

;******************************************************************************
;Low priority interrupt routine

LowInt:

		movff	STATUS,STATUS_TEMP	;save STATUS register
		movff	WREG,WREG_TEMP		;save working register
		movff	BSR,BSR_TEMP		;save BSR register
		movff	BSR_TEMP,BSR		;restore BSR register
		movff	WREG_TEMP,WREG		;restore working register
		movff	STATUS_TEMP,STATUS	;restore STATUS register
		retfie

;******************************************************************************
;High priority interrupt routine

HighInt:

;	*** high priority interrupt code goes here ***

		retfie	FAST

;******************************************************************************
;Start of main program
; The main program code is placed here.

Main:

;	*** main code goes here ***

;******************************************************************************
;End of program

		END
