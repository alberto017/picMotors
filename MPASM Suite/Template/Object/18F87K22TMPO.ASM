;******************************************************************************
;                                                                             *
;   This file is a basic code template for code generation on the             *
;   PIC18F87K22. This file contains the basic code building blocks to build   *
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
;    Files required: P18F87K22.INC                                            *
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

     LIST      P=PIC18F87K22          ; list directive to define processor
     #INCLUDE <P18F87K22.INC>         ; processor specific variable definitions

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

     CONFIG RETEN = OFF, INTOSCSEL = LOW, SOSCSEL = DIG, XINST = OFF
     CONFIG FOSC = INTIO2, PLLCFG = OFF, FCMEN = OFF, IESO = OFF
     CONFIG PWRTEN = OFF, BOREN = OFF, BORV = 3, BORPWR = LOW
     CONFIG WDTEN = OFF, WDTPS = 1, RTCOSC = INTOSCREF, EASHFT = OFF
     CONFIG ABW = MM, BW = 8, WAIT = OFF, CCP2MX = PORTBE
     CONFIG ECCPMX = PORTH, MSSPMSK = MSK5, MCLRE = ON, STVREN = OFF
     CONFIG BBSIZ = BB1K, CP0 = OFF, CP1 = OFF, CP2 = OFF 
     CONFIG CP3 = OFF, CP4 = OFF, CP5 = OFF, CP6 = OFF 
     CONFIG CP7 = OFF, CPB = OFF, CPD = OFF, WRT0 = OFF, WRT1 = OFF
     CONFIG WRT2 = OFF, WRT3 = OFF, WRT4 = OFF, WRT5 = OFF, WRT6 = OFF
     CONFIG WRT7 = OFF, WRTB = OFF, WRTC = OFF, WRTD = OFF
     CONFIG EBRT0 = OFF, EBRT1 = OFF, EBRT2 = OFF, EBRT3 = OFF
     CONFIG EBRT4 = OFF, EBRT5 = OFF, EBRT6 = OFF, EBRT7 = OFF
     CONFIG EBRTB = OFF

;------------------------------------------------------------------------------
;
; VARIABLE DEFINITIONS
;
; Refer to datasheet for available data memory (RAM) organization
;
;------------------------------------------------------------------------------

; Example of using GPR Uninitialized Data
GPR_VAR        UDATA           
MYVAR1         RES        1      ; User variable linker places
MYVAR2         RES        1      ; User variable linker places
MYVAR3         RES        1      ; User variable linker places

; Example of using Access Uninitialized Data Section
INT_VAR        UDATA_ACS       
W_TEMP         RES        1      ; w register for context saving (ACCESS)
STATUS_TEMP    RES        1      ; status used for context saving 
BSR_TEMP       RES        1      ; bank select used for ISR context saving

;------------------------------------------------------------------------------
; EEPROM INITIALIZATION
;
; The 18F87K22 has non-volatile EEPROM starting at 0xF00000
; 
;------------------------------------------------------------------------------

DATAEE    CODE    0xF00000 ; Starting address for EEPROM for 18F4553

    DE    "MCHP"           ; Place 'M' 'C' 'H' 'P' at address 0,1,2,3

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

RES_VECT  CODE    0x0000            ; processor reset vector
          GOTO    START             ; go to beginning of program

;------------------------------------------------------------------------------
; HIGH PRIORITY INTERRUPT VECTOR
;------------------------------------------------------------------------------

ISRHV     CODE    0x0008

          ; Run the High Priority Interrupt Service Routine
          GOTO    HIGH_ISR             

;------------------------------------------------------------------------------
; LOW PRIORITY INTERRUPT VECTOR
;------------------------------------------------------------------------------

ISRLV     CODE    0x0018
          
          ; Run the High Priority Interrupt Service Routine
          GOTO    LOW_ISR             

;------------------------------------------------------------------------------
; HIGH PRIORITY INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

ISRH      CODE                        ; let linker place high ISR routine

HIGH_ISR  

          ; Insert High Priority ISR Here

          RETFIE  FAST

;------------------------------------------------------------------------------
; LOW PRIORITY INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

ISRL      CODE                        ; let linker place low ISR routine

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

MAIN_PROG CODE                        ; let linker place main program

START

          ; Insert User Program Here

          GOTO $                      ; loop program counter

          END