;******************************************************************************
;                                                                             *
;   This file is a basic code template for code generation on the             *
;   PIC18F26K20. This file contains the basic code building blocks to build   *
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
;    Files required: P18F26K20.INC                                            *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Features of the 18F26K20:                                                *
;                                                                             *
;    Self programmable under software control                                 *
;    Extended watchdog timer programmable from 4 ms to 131 s                  *
;    Single supply 3 V ICSP via two pins                                      *
;    Operating range 1.8 to 3.6 V                                             *
;    Interrupt on high/low voltage detection (HLVD)                           *
;    Programmable brownout with software enable option                        *
;    Four crystal modes, up to 64 MHz                                         *
;    4X phase lock loop                                                       *
;    Programmable on chip voltage reference                                   *
;    Dual analog comparators                                                  *
;    10 bit, 14 channel ADC                                                   *
;    Enhanced USART, supports RS-485, RS-232, and LIN 2.0                     *
;    MSSP module supporting SPI, and I2C with M/S modes with address mask     *
;    Programmable slew rate                                                   *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Notes:                                                                   *
;                                                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Revision History:                                                        *
;                                                                             *
;******************************************************************************

;------------------------------------------------------------------------------
; PROCESSOR DECLARATION
;------------------------------------------------------------------------------

     LIST      P=PIC18F26K20          ; list directive to define processor
     #INCLUDE <P18F26K20.INC>         ; processor specific variable definitions

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
     CONFIG FOSC = INTIO67, FCMEN = OFF, IESO = OFF
     ;Setup CONFIG2L
     CONFIG PWRT = ON, BOREN = OFF, BORV = 18
     ;Setup CONFIG2H
     CONFIG WDTEN = OFF, WDTPS = 1
     ;Setup CONFIG3H
     CONFIG MCLRE = ON, HFOFST = OFF, LPT1OSC = OFF, PBADEN = OFF
     ;Setup CONFIG4L
     CONFIG CCP2MX = PORTBE, STVREN = OFF, LVP = OFF, XINST = OFF, DEBUG = OFF
     ;Setup CONFIG5L
     CONFIG CP0 = OFF, CP1 = OFF, CP2 = OFF, CP3 = OFF
     ;Setup CONFIG5H
     CONFIG CPB = OFF, CPD = OFF
     ;Setup CONFIG6L
     CONFIG EBTR0 = OFF
     ;Setup CONFIG6H
     CONFIG EBTR1 = OFF
     ;Setup CONFIG7L
     CONFIG EBTR2 = OFF
     ;Setup CONFIG7H
     CONFIG EBTR3 = OFF

;------------------------------------------------------------------------------
;
; VARIABLE DEFINITIONS
;
; Available data memory (also RAM) address space is divided into 16 banks, of 
; which 9 may be addressed.  The Access Bank, Special Function Registers, 
; and and General Purpose Registers are shown below:
; 
; ACCESS LOW         0x000-0x05F   Bank 0
; GPR0               0x060-0x0FF   Bank 0
; GPR1               0x100-0x1FF   Bank 1
; GPR2               0x200-0x2FF   Bank 2
; GPR3               0x300-0x3FF   Bank 3
; GPR4               0x400-0x4FF   Bank 4
; GPR5               0x500-0x5FF   Bank 5
; GPR6               0x600-0x6FF   Bank 6
; GPR7               0x700-0x7FF   Bank 7
; GPR8               0x800-0x8FF   Bank 8
; GPR9               0x900-0x9FF   Bank 9
; GPR10              0xA00-0xAFF   Bank 10
; GPR11              0xB00-0xBFF   Bank 11
; GPR12              0xC00-0xCFF   Bank 12
; GPR13              0xD00-0xDFF   Bank 13
; GPR14              0xE00-0xEFF   Bank 14
; GPR15              0xF00-0xF5F   Bank 15
; ACCESS HIGH (SFR)  0xF60-0xFFF   Bank 15
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
; The 18F26K20 has 1024 bytes of non-volatile EEPROM starting at 0xF00000
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
          ; Context Saving for High ISR
          MOVWF   W_TEMP              ; save W register
          MOVFF   STATUS, STATUS_TEMP ; save status register
          MOVFF   BSR, BSR_TEMP       ; save bankselect register

          ; Insert High Priority ISR Here

          ; Restore Context for High ISR
          MOVF    W_TEMP, W           ; restore W register
          MOVFF   STATUS_TEMP, STATUS ; restore status register
          MOVFF   BSR_TEMP, BSR       ; restore bank select register
          RETFIE 

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
          MOVWF   W_TEMP              ; save W register
          MOVFF   STATUS, STATUS_TEMP ; save status register
          MOVFF   BSR, BSR_TEMP       ; save bankselect register
          RETFIE

;------------------------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------------------------

MAIN_PROG CODE                        ; let linker place main program

START

          ; Insert User Program Here

          GOTO $                      ; loop program counter

          END