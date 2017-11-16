;**********************************************************************
;   This file is a basic template file for assembly code generation   *
;   for the PIC16C74. This file contains the basic code               *
;   building blocks to build upon.                                    *  
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).   This document     *
;   can be obtained from the WEB site at www.micrcohip.com            *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:      xxx.asm                                           *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     * 
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files required: P16C74.INC                                       *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************


    list      p=16c74             ; list directive to define processor
    #include <p16c74.inc>         ; processor specific variable definitions

    __CONFIG   _CP_OFF & _WDT_OFF & _PWRTE_ON & _XT_OSC

; '__CONFIG' directive is used to embedd configuration data within .asm file.
; The lables following the directive are located in the respective .inc file.

;***** VARIABLE DEFINITIONS
w_temp        EQU     0x20        ; variable used for context saving 
status_temp   EQU     0x21        ; variable used for context saving

;**********************************************************************
RESET_VECTOR    CODE    0x0000             ; processor reset vector
        pagesel PCLATH
        goto    start             ; go to beginning of program

ISR     CODE    0x0004            ; interrupt vector location

Interrupt:

    movwf   w_temp            ; save off current W register contents
    movf    STATUS,w          ; move status register into W register
    clrf    STATUS            ; ensure file register bank set to 0
    movwf   status_temp       ; save off contents of STATUS register

; ISR goes here
        
    clrf    STATUS            ; ensure file register bank set to 0
    movf    status_temp,w     ; retrieve copy of STATUS register
    movwf   STATUS            ; restore pre-isr STATUS register contents
    swapf   w_temp,f
    swapf   w_temp,w          ; restore pre-isr W register contents
    retfie                    ; return from interrupt

MAIN_PROG   CODE

start:

    ;Rest of program goes here

        goto $

    END                       ; directive 'end of program'

