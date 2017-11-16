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
;    Files required: P12F519.INC                                              *
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

; Example of using GPR (SEPERATE) Uninitialized Data Section
GPR_VAR        UDATA           
MYVAR1         RES        1      ; User var linker places in seperate GPR's
MYVAR2         RES        1      ; User var linker places in seperate GPR's
MYVAR3         RES        1      ; User var linker places in seperate GPR's

; Example of using Shared (OVERLAPPING) Uninitialized Data Section
INT_VAR        UDATA_SHR       
MYVAR4         RES        1      ; User var linker places in overlapping GPR's
MYVAR5         RES        1      ; User var linker places in overlapping GPR's
MYVAR6         RES        1      ; User var linker places in overlapping GPR's

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------
 
OSC       CODE    0x3FF             ; store move instruction here

; Internal RC calibration value is placed at location 0x3FF by Microchip as
; a MOVLW K instruction, where the K is a literal value to be loaded into 
; the OSCCAL register.  

;------------------------------------------------------------------------------
; RESTORE OSCILLATOR CALIBRATION VALUE
;------------------------------------------------------------------------------

RESET     CODE    0x0000            ; processor reset vector
          banksel OSCCAL            ; select data memory bank of OSCCAL
          MOVWF   OSCCAL            ; set oscillator tuning value     
          pagesel START             ; select page of beginning of program
          GOTO    START             ; go to beginning of program

;------------------------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------------------------

MAIN_PROG CODE                      ; main program code is placed by linker

START

;------------------------------------------------------------------------------
; PLACE USER PROGRAM HERE
;------------------------------------------------------------------------------

          GOTO $
  
          END