;******************************************************************************
;   This file is a basic code template for code generation on the             *
;   PIC12F519. This file contains the basic code building blocks to build     *
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
;    Files Required: P12F519.INC                                              *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Features of the 12F519:                                                  *
;                                                                             *
;    64 Bytes of Flash Data Memory (non-volatile data storage)                *
;    Precision 4/8 MHz internal oscillator                                    *
;    Baseline Core with 33 Instructions, 2 Stack Levels                       *
;    All Single-Cycle Instructions (except program branches which use 2)      *
;    12-bit wide instructions                                                 *
;    8-bit wide data pathistors (D+/D-)                                       *
;    25 mA source/sink current I/O                                            *
;    Low power (100 nA) slep current                                          *
;    One 8-bit Timer TMR0                                                     *
;    Watchdog Timer (WDT)                                                     *
;    In Circuit Serial Programming (ICSP) capability                          *
;    In Circuit Debugging Support                                             *
;    Programmable code protection                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Notes:                                                                   *
;                                                                             *
;    The 12F519 does not have interrupts                                      *
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

     LIST      p=12F519              ; list directive to define processor
     #INCLUDE <P12F519.INC>          ; processor specific variable definitions

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

     __CONFIG    _CPDF_OFF & _IOSCFS_8MHz & _MCLRE_ON & _CP_OFF & _WDTE_OFF & _IntRC_OSC

;------------------------------------------------------------------------------
;
; VARIABLE DEFINITIONS
;
; Available Data Memory divided into Bank 0 and Bank 1.  Each Bank contains 
; Special Function Registers and General Purpose Registers at the locations 
; below:  
;
;           SFR         OVERLAPPING GPR   SEPERATE GPR
; Bank 0    0x00-0x06   0x07-0x0F         0x10-0x1F    
; Bank 1    0x20-0x26   0x27-0x2F         0x30-0x3F
;
;------------------------------------------------------------------------------

    CBLOCK 0x07 ; Sample user GPR registers allocated contiguously 
        MYVAR1  ; user variable at address 0x07, can be in any GPR location
        MYVAR2  ; user variable at address 0x08
        MYVAR3  ; user variable at address 0x09
    ENDC

; Sample user variables allocated seperately
MYVAR4         EQU        0x10  ; Can be in any GPR location
MYVAR5         EQU        0x11  ; 
MYVAR6         EQU        0x12  ; 

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------
 
OSC       ORG     0x3FF             ; store move instruction here

; Internal RC calibration value is placed at location 0x3FF by Microchip as
; a MOVLW K instruction, where the K is a literal value to be loaded into 
; the OSCCAL register.  

;------------------------------------------------------------------------------
; RESTORE OSCILLATOR CALIBRATION VALUE
;------------------------------------------------------------------------------

RESET     ORG     0x0000            ; processor reset vector
          banksel OSCCAL            ; select data memory bank of OSCCAL
          MOVWF   OSCCAL            ; set oscillator tuning value     
          pagesel START             ; select page of beginning of program
          GOTO    START             ; go to beginning of program

;------------------------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------------------------

START

;------------------------------------------------------------------------------
; PLACE USER PROGRAM HERE
;------------------------------------------------------------------------------

          GOTO $

          END