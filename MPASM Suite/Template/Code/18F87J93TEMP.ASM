;******************************************************************************
;                                                                             *
;   This file is a basic code template for code generation on the             *
;   PIC18F87J93. This file contains the basic code building blocks to build   *
;   upon.                                                                     *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on features    *
;   of the assembler.                                                         *
;                                                                             *
;   Refer to the respective data sheet for additional information on the      *
;   instruction set.                                                          *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Filename:         xxx.asm                                                *
;    Date:                                                                    *
;    File Version:                                                            *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Files Required: P18F87J93.INC                                            *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Notes:                                                                   *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Revision History:                                                        *
;                                                                             *
;******************************************************************************

;------------------------------------------------------------------------------
; PROCESSOR DECLARATION
;------------------------------------------------------------------------------

     LIST      P=PIC18F87J93          ; list directive to define processor
     #INCLUDE <P18F87J93.INC>         ; processor specific variable definitions

;------------------------------------------------------------------------------
;
; CONFIGURATION WORD SETUP
;
; The 'CONFIG' directive is used to embed the configuration word within the 
; .asm file. The lables following the directive are located in the respective 
; .inc file.  See the data sheet for additional information on configuration 
; word settings.
;
;------------------------------------------------------------------------------

     CONFIG WDTEN = OFF, STVREN = OFF, XINST = OFF, CP0 = OFF, OSC = INTOSC
     CONFIG T1DIG = OFF, LPT1OSC = OFF, FCMEN = OFF, IESO = OFF, WDTPS = 1
     CONFIG RTCSOSC = INTOSCREF, CCP2MX = ALTERNATE

;------------------------------------------------------------------------------
;
; VARIABLE DEFINITIONS
;
;------------------------------------------------------------------------------

    CBLOCK 0x60 ; Sample GPR variable register allocations
        MYVAR1  ; user variable at address 0x60
        MYVAR2  ; user variable at address 0x61
        MYVAR3  ; user variable at address 0x62
    ENDC
	


W_TEMP         EQU        0x000  ; w register for context saving (ACCESS)
STATUS_TEMP    EQU        0x001  ; status used for context saving 
BSR_TEMP       EQU        0x002  ; bank select used for ISR context saving

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

RES_VECT  ORG     0x0000            ; processor reset vector
          GOTO    START             ; go to beginning of program

;------------------------------------------------------------------------------
; HIGH PRIORITY INTERRUPT VECTOR
;------------------------------------------------------------------------------

ISRH      ORG     0x0008

          ; Run the High Priority Interrupt Service Routine
          GOTO    HIGH_ISR             

;------------------------------------------------------------------------------
; LOW PRIORITY INTERRUPT VECTOR
;------------------------------------------------------------------------------

ISRL      ORG     0x0018
          
          ; Run the High Priority Interrupt Service Routine
          GOTO    LOW_ISR             

;------------------------------------------------------------------------------
; HIGH PRIORITY INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

HIGH_ISR  

          ; Insert High Priority ISR Here

          RETFIE  FAST

;------------------------------------------------------------------------------
; LOW PRIORITY INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

LOW_ISR
          ; Context Saving for Low ISR
          MOVWF   W_TEMP              ; save W register
          MOVFF   STATUS, STATUS_TEMP ; save status register
          MOVFF   BSR, BSR_TEMP       ; save bankselect register

          ; Insert Low Priority ISR Here

          ; Context Saving for Low ISR
          MOVFF   BSR_TEMP, BSR       ; restore bankselect register
          MOVF    W_TEMP, W           ; restore W register
          MOVFF   STATUS_TEMP, STATUS ; restore status register
          RETFIE

;------------------------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------------------------

START

          ; Insert User Program Here

          GOTO $                      ; loop program counter

          END