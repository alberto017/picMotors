;**********************************************************************																																																																			;**********************************************************************
;   This file is a basic code template file for assembly code         *
;   generation for the PIC16CE624. This file contains the             *
;   basic code building blocks to build upon.                         *  
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:	    xxx.asm                                           *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     * 
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files Required: P16CE624.INC                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************


	list      p=16ce624          ; list directive to define processor
	#include <p16ce624.inc>      ; processor specific variable definitions

	__CONFIG   _CP_OFF & _WDT_ON & _BODEN_ON & _PWRTE_ON & _RC_OSC

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The lables following the directive are located in the respective .inc file. 
; See respective data sheet for additional information on configuration word.



;***** VARIABLE DEFINITIONS
w_temp        EQU     0x70        ; variable used for context saving 
status_temp   EQU     0x71        ; variable used for context saving








;**********************************************************************
		ORG     0x000             ; processor reset vector
		errorlevel -302			  ; Disable off bank bits message
		bsf		STATUS,RP0        ;
		bcf		EEINTF,EEVDD      ; set Vdd to off for internal EEPROM
		bcf		STATUS,RP0        ;
		errorlevel +302		      ; Enable bank bits message
  		goto    main              ; go to beginning of program


		ORG     0x004             ; interrupt vector location
		movwf   w_temp            ; save off current W register contents
		movf	STATUS,w          ; move status register into W register
		movwf	status_temp       ; save off contents of STATUS register


; isr code can go here or be located as a call subroutine elsewhere


		movf    status_temp,w     ; retrieve copy of STATUS register
		movwf	STATUS            ; restore pre-isr STATUS register contents
		swapf   w_temp,f
		swapf   w_temp,w          ; restore pre-isr W register contents
		retfie                    ; return from interrupt



main

; remaining code goes here










		END                      ; directive 'end of program'

