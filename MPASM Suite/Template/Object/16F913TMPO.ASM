;******************************************************************************
;   This file is a basic code template for code generation on the             *
;   PIC16F913. This file contains the basic code building blocks to build     *
;   upon.                                                                     *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on             *
;   features of the assembler.                                                *
;                                                                             *
;   Refer to the respective data sheet for additional                         *
;   information on the instruction set.                                       *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Filename:        xxx.asm                                                 *
;    Date:                                                                    *
;    File Version:                                                            *
;                                                                             *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Files required: P16F913.INC                                              *
;                                                                             *
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

    LIST        P=16F913         ; list directive to define processor
    #INCLUDE    <P16F913.INC>    ; processor specific variable definitions

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

    __CONFIG _FCMEN_ON & _IESO_OFF & _CP_OFF & _WDT_OFF & _BOD_OFF & _MCLRE_ON & _PWRTE_ON & _INTOSC

;------------------------------------------------------------------------------
; VARIABLE DEFINITIONS
;
; Available Data Memory divided into Bank 0,1,2, and 3.  Each Bank contains 
; Special Function Registers, General Purpose Registers, and Access RAM
;
;------------------------------------------------------------------------------

; Example of using Shared Uninitialized Data Section
INT_VAR        UDATA_SHR       0x7D
W_TEMP         RES        1    ; w register for context saving (ACCESS)
STATUS_TEMP    RES        1    ; status used for context saving (ACCESS)
PCLATH_TEMP    RES        1    ; context saving of PC (ACCESS)

; Example of using GPR Uninitialized Data
GPR_VAR        UDATA           0x20
MYVAR1         RES        1    ; User variables placed by linker
MYVAR2         RES        1    ; 
MYVAR3         RES        1    ; 

;------------------------------------------------------------------------------
; EEPROM INITIALIZATION
;
; The 16F913 has 256 bytes of non-volatile EEPROM, starting at address 0x2100
; 
;------------------------------------------------------------------------------

EEPROM   CODE  0x2100 
    DE   "MCHP"               ; Place 'M' 'C' 'H' 'P' at address 0,1,2,3

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

RESET     CODE    0x0000            ; processor reset vector
    PAGESEL START
    GOTO    START             ; go to beginning of program

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

ISR       CODE    0x0004            ; interrupt vector location
;   Context saving for ISR
    MOVWF   W_TEMP            ; save off current W register contents
    MOVF    STATUS,W          ; move status register into W register
    MOVWF   STATUS_TEMP       ; save off contents of STATUS register
    MOVF    PCLATH,W          ; move pclath register into W register
    MOVWF   PCLATH_TEMP       ; save off contents of PCLATH register

;------------------------------------------------------------------------------
; USER INTERRUPT SERVICE ROUTINE GOES HERE
;------------------------------------------------------------------------------

;   Context restoring for ISR
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

START

;------------------------------------------------------------------------------
; PLACE USER PROGRAM HERE
;------------------------------------------------------------------------------

    GOTO $
    END