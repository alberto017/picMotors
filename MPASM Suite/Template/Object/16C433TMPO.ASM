;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PIC16C433. This file contains the               *
;   basic code building blocks to build upon.                         *                                                           *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler and linker (Document DS33014).          *
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
;    Files required: P16C433.INC                                      *
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

    list        p=16c433    ; list directive to define processor
    #include    <p16c433.inc>   ; processor specific variable definitions
    
    __CONFIG   _CP_OFF & _WDT_OFF & _MCLRE_ON & _PWRTE_ON & _EXTRC_OSC_CLKOUT

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

;***** VARIABLE DEFINITIONS (examples)

; example of using Shared Uninitialized Data Section
INT_VAR     UDATA_SHR   
w_temp      RES     1       ; variable used for context saving 
status_temp RES     1       ; variable used for context saving


; example of using Uninitialized Data Section
TEMP_VAR    UDATA   0x20        ; explicit address specified is not required
temp_count  RES 1       ; temporary variable (example)


; example of using Overlayed Uninitialized Data Section
; in this example both variables are assigned the same GPR location by linker
G_DATA      UDATA_OVR       ; explicit address can be specified
flag        RES 2       ; temporary variable (shared locations - G_DATA)

G_DATA      UDATA_OVR   
count       RES 2       ; temporary variable (shared locations - G_DATA)

;**********************************************************************
RESET_VECTOR    CODE    0x0000      ; processor reset vector
    goto    start           ; go to beginning of program


INT_VECTOR  CODE    0x0004      ; interrupt vector location

INTERRUPT

    movwf   w_temp          ; save off current W register contents
    movf    STATUS,w        ; move status register into W register
    movwf   status_temp     ; save off contents of STATUS register


; isr code can go here or be located as a call subroutine elsewhere


    movf    status_temp,w       ; retrieve copy of STATUS register
    movwf   STATUS          ; restore pre-isr STATUS register contents
    swapf   w_temp,f
    swapf   w_temp,w        ; restore pre-isr W register contents
    retfie              ; return from interrupt

MAIN_PROG   CODE

start

    nop             ; code starts here (example)
    banksel count           ; example
    clrf    count           ; example

; remaining code goes here

        goto $

    END                       ; directive 'end of program'

