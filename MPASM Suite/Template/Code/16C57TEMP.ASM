;**********************************************************************
;   This file is a basic code template for assembly code generation   *
;   on the PIC16C57. This file contains the basic code                *
;   building blocks to build upon.                                    *
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
;    Files Required: P16C57.INC                                       *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************

	list      p=16c57             ; list directive to define processor
	#include <p16c5x.inc>         ; processor specific variable definitions

;; Removing crossing page boundary messages (always happens during startup)
	errorlevel -306
	
	__CONFIG   _CP_OFF & _WDT_ON & _RC_OSC

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.



;***** VARIABLE DEFINITIONS
temp          EQU     0x08        ;example variable definition







;**********************************************************************
		ORG     0x7FF             ; processor reset vector
		goto    start
		ORG     0x000


start	clrf    FSR               ; ensure FSR register bits 5,6 are reset
                                  

; remaining code goes here






		END                       ; directive 'end of program'

