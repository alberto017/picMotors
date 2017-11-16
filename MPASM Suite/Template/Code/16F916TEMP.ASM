;******************************************************************************
;   This file is a basic code template for code generation on the             *
;   PIC16F916. This file contains the basic code building blocks to build     *
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
;    Files Required: P16F916.INC                                              *
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


	list		p=16f916      ; list directive to define processor
	#include	<p16f916.inc> ; processor specific variable definitions

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
	
	__CONFIG _FCMEN_ON & _IESO_ON & _CP_OFF & _WDT_OFF & _BOD_OFF & _MCLRE_ON & _PWRTE_ON & _INTRC_OSC_NOCLKOUT

;------------------------------------------------------------------------------
; VARIABLE DEFINITIONS
;
; Available Data Memory divided into Bank 0,1,2, and 3.  Each Bank contains 
; Special Function Registers, General Purpose Registers, and Access RAM 
;
;------------------------------------------------------------------------------

    CBLOCK 0x20 ; Define GPR variable register locations
        MYVAR1  ; User variables allocated contiguously
        MYVAR2  ; 
        MYVAR3  ; 
    ENDC

W_TEMP         EQU    0x7D        ; w register for context saving (ACCESS)
STATUS_TEMP    EQU    0x7E        ; status used for context saving (ACCESS)
PCLATH_TEMP    EQU    0x7F        ; context saving of PC (ACCESS) 

;------------------------------------------------------------------------------
; EEPROM INITIALIZATION
;
; The 16F916 has 256 bytes of non-volatile EEPROM, starting at address 0x2100
; 
;------------------------------------------------------------------------------

DATAEE    ORG  0x2100
    DE    "MCHP"  ; Place 'M' 'C' 'H' 'P' at address 0,1,2,3

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

    ORG     0x0000            ; processor reset vector
    PAGESEL START
    GOTO    START             ; When using debug header, first inst.
                              ; may be passed over by ICD2.  

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

    ORG      0x0004
    ; Interrupt context saving
    MOVWF    W_TEMP           ; save off current W register contents
    MOVF     STATUS,W         ; move status register into W register
    MOVWF    STATUS_TEMP      ; save off contents of STATUS register
    MOVF     PCLATH,W         ; move pclath register into w register
    MOVWF    PCLATH_TEMP      ; save off contents of PCLATH register

;------------------------------------------------------------------------------
; USER INTERRUPT SERVICE ROUTINE GOES HERE
;------------------------------------------------------------------------------

    ; Interrupt context restoring
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