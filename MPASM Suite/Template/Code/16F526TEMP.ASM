;******************************************************************************
;   This file is a basic code template for code generation on the  PIC16F526. *
;   This file contains the basic code building blocks to build upon.          *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on features of *
;   the assembler.                                                            *
;                                                                             *
;   Refer to the respective data sheet for additional                         *
;   information on the instruction set.                                       *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Filename:         xxx.asm                                                *
;    Date:                                                                    *
;    File Version:                                                            *
;                                                                             *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Files Required: P16F526.INC                                              *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Features of the 16F526:                                                  *
;                                                                             *
;    64 bytes flash data memory                                               *
;    14 pin packaging                                                         *
;    Precision 4/8 MHz oscillator                                             *
;    3 channels of 8 Bit ADC                                                  *
;    2 on board comparators                                                   *
;    1.125 ms device reset timer                                              *
;    Baseline core with 33 instructions, two stack levels                     *
;    All single cycle instructions except for branch instructions (2 cyc)     *
;    12 bit wide instructions, 8 bit wide data path                           *
;    25 mA source/sink current I/O                                            *
;    Low power (100 nA) sleep current                                         *
;    One 8-bit (TMR0)                                                         *
;    Watchdog timer (WDT)                                                     *
;    ICSP capability                                                          *
;    In-Circuit debug support                                                 *
;    Programmable code protection                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Notes:                                                                   *
;                                                                             *
;    The 16F526 does not have interrupts                                      *
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

     LIST      p=16F526             ; list directive to define processor
     #INCLUDE <P16F526.INC>         ; processor specific variable definitions

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

    __CONFIG    _CPDF_OFF & _IOSCFS_8MHz & _MCLRE_ON & _CP_OFF & _WDTE_OFF & _HS_OSC

;------------------------------------------------------------------------------
;
; VARIABLE DEFINITIONS
;
; Available Data Memory divided into Bank 0 through Bank 3.  Each Bank contains
; Special Function Registers and General Purpose Registers at the locations 
; below:  
;
;           SFR         SHARED GPR's   GPR's       
; Bank 0    0x00-0x0C   0x0D-0x0F      0x10-0x1F 
; Bank 1    0x20-0x2C   0x2D-0x2F      0x30-0x3F 
; Bank 2    0x40-0x4C   0x4D-0x4F      0x50-0x5F 
; Bank 3    0x60-0x6C   0x6D-0x6F      0x70-0x7F 
;
;------------------------------------------------------------------------------

    ; Sample GPR variable register allocations allocated contiguously
    CBLOCK 0x10  
        MYVAR1  ; User variable
        MYVAR2  ; User variable
        MYVAR3  ; User variable
    ENDC

MYVAR4         EQU        0x7F  ; Shared user variable                  
MYVAR5         EQU        0x7E  ; Shared user variable                  
MYVAR6         EQU        0x7D  ; Shared user variable                  

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------
 
RES_VECT  ORG     0x03FF             ; store move instruction here

; Internal RC calibration value is placed at location 0x3FF by Microchip as
; a MOVLW K instruction, where the K is a literal value to be loaded into 
; the OSCCAL register.  

;------------------------------------------------------------------------------
; RESTORE OSCILLATOR CALIBRATION VALUE
;------------------------------------------------------------------------------

OSC       ORG     0x0000            ; processor reset vector
          banksel OSCCAL            ; select data memory bank of OSCCAL
          MOVWF   OSCCAL            ; set oscillator tuning value     
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
