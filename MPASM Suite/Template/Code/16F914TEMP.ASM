;******************************************************************************
;   This file is a basic code template for code generation on the             *
;   PIC16F914. This file contains the basic code building blocks to build     *
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
;******************************************************************************
;                                                                             *
;    Files Required: P16F914.INC                                              *
;                                                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Features of the 16F914:                                                  *
;                                                                             *
;    Up to 96 LCD segments                                                    *
;    7KB Flash Program Memory                                                 *
;    256B Data EEPROM                                                         *
;    Internal 32kHz to 8MHz oscillator                                        *
;    Low-power nanoWatt Technology                                            *
;    25 mA Source/Sink current I/O                                            *
;    Two 8-bit Timer (TMR0/TMR2)                                              *
;    One 16-bit Timer (TMR1)                                                  *
;    Extended Watchdog Timer (EWDT)                                           *
;    Wide Operating Voltage (2.0V – 5.5V)                                     *
;    Brown-Out Reset (BOR) with Software Control                              *
;    In Circuit Serial Programming (ICSP)                                     *
;    Programmable Low Voltage Detect (PLVD)                                   *
;    Wake on change                                                           *
;    I2C, SPI, AUSART                                                         *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Notes: 7/6/2007                                                          *
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

    LIST        P=16F914         ; list directive to define processor
    #INCLUDE    <P16F914.INC>    ; processor specific variable definitions

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
; Special Function Registers, General Purpose Registers, and Access RAM at
; the locations below:  
;
;           SFR (not continuous)  GPR          ACCESS
; Bank 0    0x00-0x1F             0x20-0x7F    Implied
; Bank 1    0x80-0x9F             0xA0-0xEF    0xF0-0xFF
; Bank 2    0x100-0x11E           0x120-0x16F  0x170-0x17F
; Bank 3    0x180-0x18D           0x190-0x1EF  0x1F0-0x1FF
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
; The 16F914 has 256 bytes of non-volatile EEPROM, starting at address 0x2100
; 
;------------------------------------------------------------------------------

    ORG   0x2100   
    DE    "MCHP"              ; Place 'M' 'C' 'H' 'P' at address 0,1,2,3

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