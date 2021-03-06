;******************************************************************************
;   This file is a basic code template for code generation                    *
;   on the  PIC16F87. This file contains the basic code building              *
;   blocks to build upon.                                                     *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on             *
;   features of the assembler.                                                *
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
;                                                                             *
;******************************************************************************
;                                                                             *
;    Files required: P16F87.INC                                               *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Features of the 16F87:                                                   *
;                                                                             *
;    1 10-bit PWM                                                             *
;    8 MHz Internal Oscillator                                                *
;    ICD support                                                              *
;    256 bytes of EEPROM data memory                                          *
;    Capture/Compare Module                                                   *
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

     LIST     P=16F87               ; list directive to define processor
     #INCLUDE <P16F87.INC>          ; processor specific variable definitions

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

     __CONFIG    _CONFIG1, _CP_OFF & _CCP1_RB0 & _DEBUG_OFF & _WRT_PROTECT_OFF & _CPD_OFF & _LVP_OFF & _BODEN_OFF & _MCLR_ON & _PWRTE_ON & _WDT_OFF & _INTRC_IO
     __CONFIG    _CONFIG2, _IESO_OFF & _FCMEN_OFF

;------------------------------------------------------------------------------
;
; VARIABLE DEFINITIONS
;
; Available Data Memory divided into Bank 0 through Bank 3.  Each Bank contains
; Special Function Registers and General Purpose Registers at the locations 
; below:  
;
;           SFR           GPR               SHARED GPR's
; Bank 0    0x00-0x1F     0x20-0x6F         0x70-0x7F    
; Bank 1    0x80-0x9F     0xA0-0xEF         0xF0-0xFF  
; Bank 2    0x100-0x10F   0x110-0x16F       0x170-0x17F
; Bank 3    0x180-0x18F   0x190-0x1EF       0x1F0-0x1FF
;
;------------------------------------------------------------------------------

; Example of using Shared Uninitialized Data Section
INT_VAR        UDATA_SHR       
W_TEMP         RES        1    ; w register for context saving (ACCESS)
STATUS_TEMP    RES        1    ; status used for context saving (ACCESS)
PCLATH_TEMP    RES        1    ; variable used for context saving

; Example of using GPR Uninitialized Data
GPR_VAR        UDATA           
MYVAR1         RES        1    ; User variable placed by linker
MYVAR2         RES        1    ; User variable placed by linker
MYVAR3         RES        1    ; User variable placed by linker

;------------------------------------------------------------------------------
; EEPROM INITIALIZATION
;
; The 16F87 has 256 bytes of non-volatile EEPROM, starting at address 0x2100
; 
;------------------------------------------------------------------------------

DATAEE    CODE  0x2100
    DE    "MCHP"          ; Place 'M' 'C' 'H' 'P' at address 0,1,2,3

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

RESET     CODE    0x0000            ; processor reset vector
          pagesel START
          GOTO    START             ; go to beginning of program

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

INT_VECT  CODE    0x0004            ; interrupt vector location

;         Context saving for ISR
          MOVWF   W_TEMP            ; save off current W register contents
          MOVF    STATUS,W          ; move status register into W register
          MOVWF   STATUS_TEMP       ; save off contents of STATUS register
          MOVF    PCLATH,W          ; move pclath register into W register
          MOVWF   PCLATH_TEMP       ; save off contents of PCLATH register

;------------------------------------------------------------------------------
; USER INTERRUPT SERVICE ROUTINE GOES HERE
;------------------------------------------------------------------------------

;         Restore context before returning from interrupt
          MOVF    PCLATH_TEMP,W     ; retrieve copy of PCLATH register
          MOVWF   PCLATH            ; restore pre-isr PCLATH register contents
          MOVF    STATUS_TEMP,W     ; retrieve copy of STATUS register
          MOVWF   STATUS            ; restore pre-isr STATUS register contents
          SWAPF   W_TEMP,F
          SWAPF   W_TEMP,W          ; restore pre-isr W register contents
          RETFIE                    ; return from interrupt

;------------------------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------------------------

PROGRAM   CODE    

START

;------------------------------------------------------------------------------
; PLACE USER PROGRAM HERE
;------------------------------------------------------------------------------

          GOTO $

          END