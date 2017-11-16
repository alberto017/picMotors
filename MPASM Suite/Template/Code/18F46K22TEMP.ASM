;******************************************************************************
;                                                                             *
;   This file is a basic code template for code generation on the             *
;   PIC18F46K22. This file contains the basic code building blocks to build   *
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
;    Files Required:                                                          *
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

     LIST      P=PIC18F46K22          ; list directive to define processor
     #INCLUDE <P18F46K22.INC>         ; processor specific variable definitions

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

     ;Setup CONFIG11H
     CONFIG FOSC = INTIO7, PLLCFG = OFF, PRICLKEN = OFF, FCMEN = OFF, IESO = OFF
     ;Setup CONFIG2L
     CONFIG PWRTEN = OFF, BOREN = OFF, BORV = 190
     ;Setup CONFIG2H
     CONFIG WDTEN = OFF, WDTPS = 1
     ;Setup CONFIG3H
     CONFIG MCLRE = EXTMCLR, CCP2MX = PORTB3, CCP3MX = PORTE0, HFOFST = OFF, T3CMX = PORTB5, P2BMX = PORTD2
     ;Setup CONFIG4L
     CONFIG STVREN = OFF, LVP = OFF, XINST = OFF
     ;Setup CONFIG5L
     CONFIG CP0 = OFF, CP1 = OFF, CP2=OFF, CP3=OFF
     ;Setup CONFIG5H
     CONFIG CPB = OFF, CPD = OFF
     ;Setup CONFIG6L
     CONFIG WRT0 = OFF, WRT1 = OFF, WRT2 = OFF, WRT3 = OFF
     ;Setup CONFIG6H
     CONFIG WRTB = OFF, WRTC = OFF, WRTD = OFF
     ;Setup CONFIG7L
     CONFIG EBTR0 = OFF, EBTR1 = OFF, EBTR2 = OFF, EBTR3 = OFF
     ;Setup CONFIG7H
     CONFIG EBTRB = OFF

;------------------------------------------------------------------------------
;
; VARIABLE DEFINITIONS
;
; Refer to datasheet for available data memory (RAM) organization
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
; EEPROM INITIALIZATION
;
; The 18F46K22 has 256 bytes of non-volatile EEPROM starting at 0xF00000
; 
;------------------------------------------------------------------------------

DATAEE    ORG  0xF00000 ; Starting address for EEPROM for 18F46K22

    DE    "MCHP"        ; Place 'M' 'C' 'H' 'P' at address 0,1,2,3

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