;******************************************************************************
;   This file is a basic code template for code generation on the             *
;   PIC18F4458. This file contains the basic code building blocks to build    *
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
;    Files required: P18F4458.INC                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Features of the 18F4458:                                                 *
;                                                                             *
;    Full Speed USB 2.0 (12Mbit/s) interface                                  *
;    1K byte Dual Port RAM + 1K byte GP RAM                                   *
;    Full Speed Transceiver                                                   *
;    16 Endpoints (IN/OUT)                                                    *
;    Streaming Port                                                           *
;    Internal Pull Up resistors (D+/D-)                                       *
;    48 MHz performance (12 MIPS)                                             *
;    Pin-to-pin compatible with PIC16C7X5                                     *
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

     LIST      p=18F4458              ; list directive to define processor
     #INCLUDE <P18F4458.INC>          ; processor specific variable definitions

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

     ;Setup CONFIG1L
     CONFIG PLLDIV = 1, CPUDIV = OSC1_PLL2, USBDIV = 1
     ;Setup CONFIG11H
     CONFIG FOSC = INTOSC_HS, FCMEN = OFF, IESO = OFF
     ;Setup CONFIG2L
     CONFIG PWRT = ON, BOR = OFF, BORV = 3, VREGEN = OFF
     ;Setup CONFIG2H
     CONFIG WDT = OFF, WDTPS = 1
     ;Setup CONFIG3H
     CONFIG MCLRE = ON, LPT1OSC = OFF, PBADEN = OFF, CCP2MX = OFF
     ;Setup CONFIG4L
     CONFIG STVREN = OFF, LVP = OFF, ICPRT = OFF, XINST = OFF, DEBUG = OFF
     ;Setup CONFIG5L
     CONFIG CP0 = OFF, CP1 = OFF, CP2 = OFF
     ;Setup CONFIG5H
     CONFIG WRTB = OFF, WRTC = OFF, WRTD = OFF
     ;Setup CONFIG6L
     CONFIG EBTR0 = OFF
     ;Setup CONFIG6H
     CONFIG EBTR1 = OFF
     ;Setup CONFIG7L
     CONFIG EBTR2 = OFF
     ;Setup CONFIG7H
     CONFIG EBTRB = OFF

;------------------------------------------------------------------------------
;
; VARIABLE DEFINITIONS
;
; Available data memory (also RAM) address space is divided into 16 banks, of 
; which 9 may be addressed.  The Access Bank, Special Function Registers, 
; and and General Purpose Registers are shown below:
;
; 
; ACCESS LOW         0x000-0x05F   Bank 0
; GPR0               0x060-0x0FF   Bank 0
; GPR1               0x100-0x1FF   Bank 1
; GPR2               0x200-0x2FF   Bank 2
; GPR3               0x300-0x3FF   Bank 3
; GPRUSB0            0x400-0x4FF   Bank 4
; GPRUSB1            0x500-0x5FF   Bank 5
; GPRUSB2            0x600-0x6FF   Bank 6
; GPRUSB3            0x700-0x7FF   Bank 7
;    <Bank 8 through 14 unimplemented> 
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
; The 18F4458 has 256 bytes of non-volatile EEPROM starting at 0xF00000
; 
;------------------------------------------------------------------------------

DATAEE    CODE    0xF00000 ; Starting address for EEPROM for 18F4458

    DE    "MCHP"         ; Place 'M' 'C' 'H' 'P' at address 0,1,2,3

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