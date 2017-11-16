;**********************************************************************
;   This file is a basic code template for assembly code generation   *
;   on the PIC16C52. This file contains the basic code                *
;   building blocks to build upon.                                    *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
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
;    Files required: P16C52.INC                                       *
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

    list      p=16c52             ; list directive to define processor
    #include <p16c5x.inc>         ; processor specific variable definitions

    __CONFIG   _CP_OFF & _RC_OSC

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.





;***** VARIABLE DEFINITIONS
temp          EQU     0x07        ;example variable definition








;**********************************************************************
RESET_VECTOR    CODE    0x17F             ; processor reset vector
        goto    start

MAIN_PROGRAM        CODE


start   


; remaining code goes here





        END                       ; directive 'end of program'

