;******************************************************************************
;   This file is a basic code template for code generation on the  PIC16F707. *
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
;    Files Required: P16F707.INC                                              *
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

     LIST      p=16F707             ; list directive to define processor
     #INCLUDE <P16F707.INC>         ; processor specific variable definitions

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

     __CONFIG    _CONFIG, _INTOSCIO & _WDT_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _BOREN_OFF & _BORV_25 & _PLLEN_OFF
     __CONFIG    _CONFIG2, _VCAPEN_OFF

;------------------------------------------------------------------------------
;
; VARIABLE DEFINITIONS
;
; Available Data Memory divided into Bank 0 through Bank 3.  Each Bank contains
; Special Function Registers and General Purpose Registers.
;
;------------------------------------------------------------------------------

; Example of using GPR Uninitialized Data
GPR_VAR        UDATA           0x20
MYVAR1         RES        1    ; User variable located at address 0x20
MYVAR2         RES        1    ; User variable located at address 0x21
MYVAR3         RES        1    ; User variable located at address 0x22

; Example of using Shared Uninitialized Data Section
INT_VAR        UDATA_SHR       0x7D
W_TEMP         RES        1    ; w register for context saving (Shared)
STATUS_TEMP    RES        1    ; status used for context saving 
PCLATH_TEMP    RES        1    ; variable used for context saving

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

RESET_VEC CODE    0x0000            ; processor reset vector
          GOTO    START             ; go to beginning of program

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

ISR       CODE    0x0004            ; interrupt vector location

;         Context saving for ISR
          MOVWF   W_TEMP            ; save off current W register contents
          SWAPF   STATUS, W         ; swap status to be saved into W 
                                    ; swaps don't affect the status bits
          MOVWF   STATUS_TEMP       ; save off contents of STATUS register
          MOVF    PCLATH,W          ; move pclath register into W register
          MOVWF   PCLATH_TEMP       ; save off contents of PCLATH register

;------------------------------------------------------------------------------
; USER INTERRUPT SERVICE ROUTINE GOES HERE
;------------------------------------------------------------------------------

;         Restore context before returning from interrupt

          MOVF    PCLATH_TEMP,W     ; retrieve copy of PCLATH register
          MOVWF   PCLATH            ; restore pre-isr PCLATH register contents
          SWAPF   STATUS_TEMP, W    ; Swap STATUS_TEMP register into W 
                                    ; (sets bank to original state)
          MOVWF   STATUS            ; restore pre-isr STATUS register contents
          SWAPF   W_TEMP,F
          SWAPF   W_TEMP,W          ; restore pre-isr W register contents
          RETFIE                    ; return from interrupt

;------------------------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------------------------

START

;------------------------------------------------------------------------------
; PLACE USER PROGRAM HERE
;------------------------------------------------------------------------------

          GOTO $

          END
