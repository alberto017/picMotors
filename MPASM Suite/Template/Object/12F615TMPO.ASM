;   This file is a basic relocatable code template for code generation         *
;   on the  PIC12F615. This file contains the basic code                       *
;   building blocks to build upon.                                             *
;                                                                              *
;   Refer to the MPASM User's Guide for additional information on              *
;   features of the assembler.                                                 *
;                                                                              *
;   Refer to the respective data sheet for additional                          *
;   information on the instruction set.                                        *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Filename:         xxx.asm                                                 *
;    Date:                                                                     *
;    File Version:                                                             *
;                                                                              *
;    Author:                                                                   *
;    Company:                                                                  *
;                                                                              *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Files required: P12F615.INC                                               *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Revision Information:                                                     *
;                                                                              *
;                                                                              *
;                                                                              *
;                                                                              *
;*******************************************************************************

;------------------------------------------------------------------------------
; PROCESSOR DECLARATION
;------------------------------------------------------------------------------

     LIST      p=12F615              ; list directive to define processor
     #INCLUDE <P12F615.INC>          ; processor specific variable definitions

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

     __CONFIG   _CP_OFF & _BOR_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT

;------------------------------------------------------------------------------
; VARIABLE DEFINITIONS
;------------------------------------------------------------------------------

; Example of using GPR (SEPERATE) Uninitialized Data Section
GPR_VAR           UDATA           
MYVAR1         RES        1      ; User var linker places in seperate GPR's
MYVAR2         RES        1      ; User var linker places in seperate GPR's
MYVAR3         RES        1      ; User var linker places in seperate GPR's

; Example of using Shared (OVERLAPPING) Uninitialized Data Section
INT_VAR           UDATA_SHR       
W_TEMP         RES        1      ; Interrupt Context Saving W
STATUS_TEMP    RES        1      ; Interrupt Context Saving STATUS
MYVAR4         RES        1      ; User var linker places in overlapping GPR's
MYVAR5         RES        1      ; User var linker places in overlapping GPR's
MYVAR6         RES        1      ; User var linker places in overlapping GPR's

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

START             CODE    0x0000      ; processor reset vector
          goto    START               ; go to beginning of program

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

INT_VECTOR        CODE   0x0004     ; Interrupt Vector Location

INTERRUPT                           ; Relocatable Interrupt Service Routine

;         Context saving for ISR
          MOVWF   W_TEMP            ; save off current W register contents
          MOVF    STATUS,W          ; move status register into W register
          MOVWF   STATUS_TEMP       ; save off contents of STATUS register

          ; Place ISR here 

;         Restore context before returning from interrupt
          MOVF    STATUS_TEMP, W    ; retrieve copy of STATUS register
          MOVWF   STATUS            ; restore pre-isr STATUS register contents
          SWAPF   W_TEMP, F
          SWAPF   W_TEMP, W         ; restore pre-isr W register contents
          RETFIE                    ; return from interrupt


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
