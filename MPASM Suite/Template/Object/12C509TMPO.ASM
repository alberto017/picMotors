;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PIC12C509A. This file contains the              *
;   basic code building blocks to build upon.                         *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler and linker (Document DS33014F).         *
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
;    Files required: P12C509.INC                                      *
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

    list      p=12c509           ; list directive to define processor
    #include <p12c509.inc>       ; processor specific variable definitions

    __CONFIG   _CP_OFF & _WDT_ON & _MCLRE_ON & _ExtRC_OSC 

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.




;***** VARIABLE DEFINITIONS
TEMP_VAR      UDATA   0x07
temp          RES     1           ;example variable definition







;**********************************************************************
        CODE    0x3FF             ; processor reset vector
; Internal RC calibration value is placed at location 0x3FF by Microchip
; as a movlw k, where the k is a literal value.

MAIN    CODE                      ; coding begins here
        movwf   OSCCAL            ; update register with factory cal value 
         
        movlw   0xFF              ; example code
        banksel temp              ; ensure GPR bank is selected 
        movwf   temp              ; initialize variable "temp"

; remaining code goes here





        END                       ; directive 'end of program'

