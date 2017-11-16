;**********************************************************************
;   This file is a basic code template for assembly code generation   *
;   on the PIC16C56A. This file contains the basic code               *
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
;    Files Required: P16C56A.INC                                      *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************

	list      p=16c56a            ; list directive to define processor
	#include <p16c5x.inc>         ; processor specific variable definitions

	__CONFIG   _CP_OFF & _WDT_ON & _RC_OSC

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file. 
; See respective data sheet for additional information on configuration word.




;***** VARIABLE DEFINITIONS
temp          EQU     0x07        ;example variable definition








;**********************************************************************
		ORG     0x3FF             ; processor reset vector
		errorlevel -306		      ; disable page boundary message
		goto    start
		errorlevel +306			  ; enable page boundary message
		ORG     0x000


start	


; remaining code goes here







		END                       ; directive 'end of program'

